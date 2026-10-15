import 'package:alam_el_marateb_result/result.dart';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';

import 'package:alam_el_marateb_utils/src/pagination/base_pagination_state.dart';

mixin PaginationMixin<T> on CubitSignal<PaginationState<T>> {
  Future<ApiResult<List<T>>> fetchPageData(int page);

  bool _isFetching = false;

  Future<void> loadNextPage({bool isRefresh = false}) async {
    // Immediate synchronous re-entrancy guard
    if (_isFetching) return;
    if (stateValue.isLoadingMore || (stateValue.hasReachedMax && !isRefresh)) return;

    _isFetching = true;

    final previousState = stateValue;

    if (isRefresh) {
      emit(
        stateValue.copyWith(
          isInitialLoading: true,
          items: [],
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

    try {
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
}
