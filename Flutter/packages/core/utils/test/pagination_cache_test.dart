import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_result/result.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeNetworkInfo implements BaseNetworkInfo {
  @override
  Stream<List<ConnectivityResult>> get connectivityChanged =>
      const Stream.empty();

  @override
  Future<bool> get isConnected async => true;

  @override
  Future<bool> get hasInternetAccess async => true;
}

class _FakeCubit extends Cubit<PaginationState<int>> with PaginationMixin<int> {
  _FakeCubit({required this.pages, this.failOnPage})
    : super(const PaginationState());

  final Map<int, List<int>> pages;
  final int? failOnPage;

  @override
  Future<ApiResult<List<int>>> fetchPageData(int page) async {
    if (failOnPage == page) {
      return const Result.failure(error: NetworkFailure('fetch failed'));
    }
    return Result.success(data: pages[page] ?? const []);
  }
}

class _FakeSmartCubit extends Cubit<PaginationState<int>>
    with SmartCachePaginationMixin<int> {
  _FakeSmartCubit({required this.pages}) : super(const PaginationState()) {
    _networkCubit = NetworkCubit(_FakeNetworkInfo());
  }

  final Map<int, List<int>> pages;
  late final NetworkCubit _networkCubit;

  @override
  NetworkCubit get networkCubit => _networkCubit;

  @override
  Future<ApiResult<List<int>>> fetchPageData(int page) async {
    return Result.success(data: pages[page] ?? const []);
  }

  @override
  Future<void> close() async {
    await _networkCubit.close();
    return super.close();
  }
}

void main() {
  group('PaginationMixin', () {
    test('loads pages and stops at empty page', () async {
      final cubit = _FakeCubit(
        pages: const {
          1: [1, 2],
          2: [3],
        },
      );

      await cubit.loadNextPage();
      expect(cubit.state.items, [1, 2]);
      expect(cubit.state.currentPage, 2);

      await cubit.loadNextPage();
      expect(cubit.state.items, [1, 2, 3]);
      expect(cubit.state.currentPage, 3);

      await cubit.loadNextPage();
      expect(cubit.state.hasReachedMax, isTrue);

      // No-op once max reached
      await cubit.loadNextPage();
      expect(cubit.state.items, [1, 2, 3]);
      await cubit.close();
    });

    test('refresh resets and reloads first page', () async {
      final cubit = _FakeCubit(
        pages: const {
          1: [1, 2],
        },
      );

      await cubit.loadNextPage();
      await cubit.loadNextPage(isRefresh: true);
      expect(cubit.state.items, [1, 2]);
      expect(cubit.state.currentPage, 2);
      await cubit.close();
    });

    test('maps failure to errorMessage', () async {
      final cubit = _FakeCubit(pages: const {}, failOnPage: 1);

      await cubit.loadNextPage();
      expect(cubit.state.errorMessage, 'fetch failed');
      expect(cubit.state.items, isEmpty);
      await cubit.close();
    });

    test('clearPaginationCache resets state', () async {
      final cubit = _FakeCubit(
        pages: const {
          1: [1, 2],
        },
      );

      await cubit.loadNextPage();
      cubit.clearPaginationCache();
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.currentPage, 1);
      await cubit.close();
    });

    test('toPagingState adapts to infinite_scroll_pagination', () async {
      final cubit = _FakeCubit(
        pages: const {
          1: [1, 2],
        },
      );
      await cubit.loadNextPage();
      final paging = cubit.state.toPagingState();
      expect(paging.pages?.single, [1, 2]);
      expect(paging.hasNextPage, isTrue);
      await cubit.close();
    });
  });

  group('CacheManager', () {
    test('refreshAllCache reloads registered pagination cubits', () async {
      // NOTE: only SmartCachePaginationMixin cubits implement
      // SmartCachePaginationInterface (mono behavior) — plain
      // PaginationMixin cubits are intentionally ignored by refresh.
      final manager = CacheManager();
      final cubit = _FakeSmartCubit(
        pages: const {
          1: [7],
        },
      );
      manager.register(cubit);

      await manager.refreshAllCache();
      expect(cubit.state.items, [7]);

      manager.unregister(cubit);
      await cubit.close();
    });

    test('refreshAllCache is a no-op when empty', () async {
      await CacheManager().refreshAllCache();
    });
  });
}
