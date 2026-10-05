import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'base_pagination_state.dart';

extension PaginationStateAdapter<T> on PaginationState<T> {
  PagingState<int, T> toPagingState() {
    final items = this.items;
    if (items.isEmpty) {
      return PagingState<int, T>(
        pages: isInitialLoading ? null : <List<T>>[],
        keys: isInitialLoading ? null : <int>[],
        error: errorMessage,
        hasNextPage: !hasReachedMax,
        isLoading: isInitialLoading,
      );
    }
    return PagingState<int, T>(
      pages: [items],
      keys: const [1],
      error: errorMessage,
      hasNextPage: !hasReachedMax,
      isLoading: isLoadingMore,
    );
  }
}
