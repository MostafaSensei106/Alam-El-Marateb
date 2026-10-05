import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/types/type_def.dart';
import '../../di/di.dart';
import '../../error/failures.dart';
import '../cache/cache_manager.dart';
import '../network/logic/cubit/network_cubit.dart';
import '../network/logic/cubit/network_state.dart';
import '../result/result.dart';

/// A mixin for Cubits to achieve SOLID, offline-first smart caching.
/// Handles background fetching, offline modes, and auto-retry on reconnection.
mixin SmartCacheCubitMixin<State, Data> on Cubit<State>
    implements SmartCacheCubitInterface {
  NetworkCubit get networkCubit;

  /// Returns whether device is online with fallback for unstubbed unit test mocks.
  bool get isOnline {
    try {
      return networkCubit.isOnline;
    } catch (_) {
      return true;
    }
  }

  /// Retrieves the cached data from the current state if available.
  Data? getCachedData(State state);

  /// Builds the loading state.
  State buildLoadingState();

  /// Builds the success state.
  State buildSuccessState(Data data);

  /// Builds the failure state with the typed [Failures] object
  /// so the UI can localise the message via [FailureLocalizer].
  State buildFailureState(Failures error);

  /// Checks if the current state represents a network failure.
  bool isNetworkFailureState(State state);

  /// Executes the remote network request.
  Future<ApiResult<Data>> executeRequest();

  /// Called when a background refresh fails but cached data exists.
  ///
  /// Override this in your Cubit to show a transient notification
  /// (toast / snackbar) informing the user that fresh data could not
  /// be loaded, while still displaying the cached version.
  ///
  /// By default this is a no-op — override to surface the error.
  void onRefreshFailed(Failures error) {}

  StreamSubscription<NetworkState>? _networkSubscription;

  /// Starts watching network changes to auto-retry failed requests.
  void watchConnectivity() {
    if (getIt.isRegistered<CacheManager>()) {
      getIt<CacheManager>().register(this);
    }
    unawaited(_networkSubscription?.cancel());
    _networkSubscription = networkCubit.stream.listen((networkState) {
      networkState.whenOrNull(
        connected: () {
          if (isNetworkFailureState(state)) {
            unawaited(fetchData(isRefresh: true));
          }
        },
      );
    });
  }

  /// Retries the request by refreshing the data.
  Future<void> retryRequest() => fetchData(isRefresh: true);

  /// The smart entry point for fetching data.
  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    final cached = getCachedData(state);

    // 1. Handling offline scenario
    if (!isOnline) {
      if (cached != null) {
        emit(buildSuccessState(cached));
        return;
      } else {
        emit(
          buildFailureState(const OfflineFailure('No internet connection.')),
        );
        return;
      }
    }

    // 2. If online and no cache (or if refresh is requested), show loading spinner
    if (cached == null || isRefresh) {
      emit(buildLoadingState());
    }

    // 3. Perform network call
    final result = await executeRequest();

    result.when(
      success: (newData) {
        if (isClosed) return;
        emit(buildSuccessState(newData));
      },
      failure: (failure) {
        if (isClosed) return;
        if (cached != null) {
          // Surface the error so it's not silently swallowed, then
          // re-emit the cached data so the UI still has something to show.
          onRefreshFailed(failure);
          emit(buildSuccessState(cached));
        } else {
          emit(buildFailureState(failure));
        }
      },
    );
  }

  @override
  Future<void> close() async {
    if (getIt.isRegistered<CacheManager>()) {
      getIt<CacheManager>().unregister(this);
    }
    await _networkSubscription?.cancel();
    return super.close();
  }
}
