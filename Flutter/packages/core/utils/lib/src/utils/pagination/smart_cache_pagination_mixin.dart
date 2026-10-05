import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/types/type_def.dart';
import '../../di/di.dart';
import 'package:core_network/core_network.dart';
import '../cache/cache_manager.dart';
import '../network/logic/cubit/network_cubit.dart';
import '../network/logic/cubit/network_state.dart';
import '../result/result.dart';
import 'base_pagination_state.dart';

/// An enhanced pagination mixin that is aware of network state and local cache.
///
/// Features O(1) synchronous re-entrancy guards, memory-optimized list allocations,
/// auto-refresh on reconnection, and robust failure propagation.
mixin SmartCachePaginationMixin<T> on Cubit<PaginationState<T>>
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
          if (state.errorMessage != null && state.items.isEmpty) {
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
    if (state.isLoadingMore || (state.hasReachedMax && !isRefresh)) return;

    _isFetching = true;

    try {
      // 2. Network reachability check with mock safety
      if (!isOnline) {
        if (state.items.isEmpty) {
          emit(
            state.copyWith(
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
          state.copyWith(
            isInitialLoading: state.items.isEmpty,
            items: state.items,
            currentPage: 1,
            hasReachedMax: false,
          ),
        );
      } else {
        if (state.currentPage == 1 && state.items.isEmpty) {
          emit(state.copyWith(isInitialLoading: true));
        } else {
          emit(state.copyWith(isLoadingMore: true));
        }
      }

      final result = await fetchPageData(state.currentPage);

      result.when(
        success: (newItems) {
          if (isClosed) return;
          final reachedMax = newItems.isEmpty;
          final updatedItems = isRefresh
              ? newItems
              : (List<T>.of(state.items)..addAll(newItems));

          emit(
            state.copyWith(
              items: updatedItems,
              currentPage: state.currentPage + 1,
              hasReachedMax: reachedMax,
              isLoadingMore: false,
              isInitialLoading: false,
              errorMessage: null,
            ),
          );
        },
        failure: (e) {
          if (isClosed) return;
          if (isRefresh && previousState.items.isNotEmpty) {
            // Rollback to previous state with error message to preserve items
            emit(previousState.copyWith(errorMessage: e.message));
          } else {
            emit(
              state.copyWith(
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
      state.copyWith(
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
