import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/types/type_def.dart';
import '../result/result.dart';
import 'base_pagination_state.dart';

mixin PaginationMixin<T> on Cubit<PaginationState<T>> {
  Future<ApiResult<List<T>>> fetchPageData(int page);

  bool _isFetching = false;

  Future<void> loadNextPage({bool isRefresh = false}) async {
    // Immediate synchronous re-entrancy guard
    if (_isFetching) return;
    if (state.isLoadingMore || (state.hasReachedMax && !isRefresh)) return;

    _isFetching = true;

    final previousState = state;

    if (isRefresh) {
      emit(
        state.copyWith(
          isInitialLoading: true,
          items: [],
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

    try {
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
}
