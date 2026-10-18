import 'package:bloc_signals/bloc_signals.dart';

import '../../constants/types/type_def.dart';
import '../result/result.dart';
import 'base_pagination_state.dart';

mixin PaginationMixin<T> on CubitSignal<PaginationState<T>> {
  Future<ApiResult<List<T>>> fetchPageData(int page);

  bool _isFetching = false;

  Future<void> loadNextPage({bool isRefresh = false}) async {
    // Immediate synchronous re-entrancy guard
    if (_isFetching) return;
    if (state.value.isLoadingMore ||
        (state.value.hasReachedMax && !isRefresh)) {
      return;
    }

    _isFetching = true;

    final previousState = state;

    if (isRefresh) {
      emit(
        state.value.copyWith(
          isInitialLoading: true,
          items: [],
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

    try {
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
}
