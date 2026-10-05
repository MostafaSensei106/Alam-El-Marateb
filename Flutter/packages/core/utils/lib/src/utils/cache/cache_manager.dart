import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

abstract class SmartCacheCubitInterface {
  Future<void> fetchData({bool isRefresh = false});
}

abstract class SmartCachePaginationInterface {
  void clearPaginationCache();
  Future<void> loadNextPage({bool isRefresh = false});
}

/// Central cache registry manager that coordinates cache invalidation and refresh
/// operations across all active cubits with O(1) registration overhead.
@lazySingleton
class CacheManager {
  final Set<Cubit> _activeCubits = {};

  /// Registers an active Cubit into the cache manager in O(1) time.
  void register(Cubit cubit) {
    _activeCubits.add(cubit);
  }

  /// Unregisters a Cubit upon disposal in O(1) time.
  void unregister(Cubit cubit) {
    _activeCubits.remove(cubit);
  }

  /// Refreshes cache concurrently across all registered active Cubits.
  Future<void> refreshAllCache() async {
    if (_activeCubits.isEmpty) return;

    // Snapshot current registered set to prevent concurrent mutation during iteration.
    final activeSet = Set<Cubit>.of(_activeCubits);
    final futures = <Future<void>>[];

    for (final cubit in activeSet) {
      if (cubit.isClosed) continue;

      if (cubit is SmartCacheCubitInterface) {
        futures.add(
          (cubit as SmartCacheCubitInterface).fetchData(isRefresh: true),
        );
      } else if (cubit is SmartCachePaginationInterface) {
        final paginated = cubit as SmartCachePaginationInterface;
        paginated.clearPaginationCache();
        futures.add(paginated.loadNextPage(isRefresh: true));
      }
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }
}
