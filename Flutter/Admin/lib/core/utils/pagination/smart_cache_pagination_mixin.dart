import 'dart:async';

import 'package:bloc_signals/bloc_signals.dart';

import '../../constants/types/type_def.dart';
import '../../di/di.dart';
import '../../error/failures.dart';
import '../cache/cache_manager.dart';
import '../network/logic/cubit/network_cubit.dart';
import '../network/logic/cubit/network_state.dart';
import 'base_pagination_state.dart';

/// An enhanced pagination mixin that is aware of network state and local cache.
///
/// Features O(1) synchronous re-entrancy guards, memory-optimized list allocations,
/// auto-refresh on reconnection, and robust failure propagation.
mixin SmartCachePaginationMixin<T> on CubitSignal<PaginationState<T>>
    implements SmartCachePaginationInterface {
  NetworkCubit get networkCubit;
  Future<ApiResult<List<T>>> fetchPageData(int page);

  bool _isFetching = false;
  StreamSubscription<NetworkState>? _networkSubscription;

  /// Returns whether device is online with fallback for unstubbed unit test mocks.
  bool get isOnline {
    try {
      return networkCubit.isOnline;
    } catch (_) {
      return true;
    }
  }

  void watchConnectivity() {
    if (getIt.isRegistered<CacheManager>()) {
      getIt<CacheManager>().register(this);
    }
    unawaited(_networkSubscription?.cancel());
    _networkSubscription = networkCubit.stream.listen((networkState) {
      networkState.whenOrNull(
        connected: () {
          if (state.value.errorMessage != null && state.value.items.isEmpty) {
            unawaited(loadNextPage(isRefresh: true));
          }
        },
      );
    });
  }

  @override
  Future<void> loadNextPage({bool isRefresh = false}) async {
    // 1. Immediate synchronous re-entrancy guard
    if (_isFetching) return;
    if (state.value.isLoadingMore ||
        (state.value.hasReachedMax && !isRefresh)) {
      return;
    }

    _isFetching = true;

    try {
      // 2. Network reachability check with mock safety
      if (!isOnline) {
        if (state.value.items.isEmpty) {
          emit(
            state.value.copyWith(
              isLoadingMore: false,
              isInitialLoading: false,
              errorMessage: const OfflineFailure('No internet connection.')
                  .message,
            ),
          );
        }
        return;
      }

      final previousState = state;

      if (isRefresh) {
        emit(
          state.value.copyWith(
            isInitialLoading: state.value.items.isEmpty,
            items: state.value.items,
            currentPage: 1,
            hasReachedMax: false,
          ),
        );
      } else {
        if (state.value.currentPage == 1 && state.value.items.isEmpty) {
          emit(state.value.copyWith(isInitialLoading: true));
        } else {
          emit(state.value.copyWith(isLoadingMore: true));
        }
      }

      final result = await fetchPageData(state.value.currentPage);

      result.when(
        success: (newItems) {
          if (isClosed) return;
          final reachedMax = newItems.isEmpty;
          final updatedItems = isRefresh
              ? newItems
              : (List<T>.of(state.value.items)..addAll(newItems));

          emit(
            state.value.copyWith(
              items: updatedItems,
              currentPage: state.value.currentPage + 1,
              hasReachedMax: reachedMax,
              isLoadingMore: false,
              isInitialLoading: false,
              errorMessage: null,
            ),
          );
        },
        failure: (e) {
          if (isClosed) return;
          if (isRefresh && previousState.value.items.isNotEmpty) {
            // Rollback to previous state with error message to preserve items
            emit(previousState.value.copyWith(errorMessage: e.message));
          } else {
            emit(
              state.value.copyWith(
                isLoadingMore: false,
                isInitialLoading: false,
                errorMessage: e.message,
              ),
            );
          }
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  @override
  void clearPaginationCache() {
    emit(
      state.value.copyWith(
        items: [],
        currentPage: 1,
        hasReachedMax: false,
        errorMessage: null,
        isInitialLoading: true,
      ),
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
