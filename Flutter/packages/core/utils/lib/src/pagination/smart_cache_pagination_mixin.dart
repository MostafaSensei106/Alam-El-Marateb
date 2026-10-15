import 'dart:async';

import 'package:alam_el_marateb_di/di.dart';
import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_result/result.dart';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';

import 'package:alam_el_marateb_utils/src/cache/cache_manager.dart';
import 'package:alam_el_marateb_utils/src/pagination/base_pagination_state.dart';

/// An enhanced pagination mixin that is aware of network stateValue and local cache.
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
          if (stateValue.errorMessage != null && stateValue.items.isEmpty) {
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
    if (stateValue.isLoadingMore || (stateValue.hasReachedMax && !isRefresh)) {
      return;
    }

    _isFetching = true;

    try {
      // 2. Network reachability check with mock safety
      if (!isOnline) {
        if (stateValue.items.isEmpty) {
          emit(
            stateValue.copyWith(
              isLoadingMore: false,
              isInitialLoading: false,
              errorMessage: const OfflineFailure('No internet connection.')
                  .message,
            ),
          );
        }
        return;
      }

      final previousState = stateValue;

      if (isRefresh) {
        emit(
          stateValue.copyWith(
            isInitialLoading: stateValue.items.isEmpty,
            items: stateValue.items,
            currentPage: 1,
            hasReachedMax: false,
          ),
        );
      } else {
        if (stateValue.currentPage == 1 && stateValue.items.isEmpty) {
          emit(stateValue.copyWith(isInitialLoading: true));
        } else {
          emit(stateValue.copyWith(isLoadingMore: true));
        }
      }

      final result = await fetchPageData(stateValue.currentPage);

      result.when(
        success: (newItems) {
          if (isClosed) return;
          final reachedMax = newItems.isEmpty;
          final updatedItems = isRefresh
              ? newItems
              : (List<T>.of(stateValue.items)..addAll(newItems));

          emit(
            stateValue.copyWith(
              items: updatedItems,
              currentPage: stateValue.currentPage + 1,
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
            // Rollback to previous stateValue with error message to preserve items
            emit(previousState.copyWith(errorMessage: e.message));
          } else {
            emit(
              stateValue.copyWith(
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
      stateValue.copyWith(
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
