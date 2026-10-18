import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class SmartCacheCubitSignalInterface {
  Future<void> fetchData({bool isRefresh = false});
}

abstract class SmartCachePaginationInterface {
  void clearPaginationCache();
  Future<void> loadNextPage({bool isRefresh = false});
}

/// Central cache registry manager that coordinates cache invalidation and refresh
/// operations across all active CubitSignals with O(1) registration overhead.
@lazySingleton
class CacheManager {
  final Set<CubitSignal> _activeCubitSignals = {};

  /// Registers an active CubitSignal into the cache manager in O(1) time.
  void register(CubitSignal CubitSignal) {
    _activeCubitSignals.add(CubitSignal);
  }

  /// Unregisters a CubitSignal upon disposal in O(1) time.
  void unregister(CubitSignal CubitSignal) {
    _activeCubitSignals.remove(CubitSignal);
  }

  /// Refreshes cache concurrently across all registered active CubitSignals.
  Future<void> refreshAllCache() async {
    if (_activeCubitSignals.isEmpty) return;

    // Snapshot current registered set to prevent concurrent mutation during iteration.
    final activeSet = Set<CubitSignal>.of(_activeCubitSignals);
    final futures = <Future<void>>[];

    for (final CubitSignal in activeSet) {
      if (CubitSignal.isClosed) continue;

      if (CubitSignal is SmartCacheCubitSignalInterface) {
        futures.add(
          (CubitSignal as SmartCacheCubitSignalInterface).fetchData(
            isRefresh: true,
          ),
        );
      } else if (CubitSignal is SmartCachePaginationInterface) {
        final paginated = CubitSignal as SmartCachePaginationInterface;
        paginated.clearPaginationCache();
        futures.add(paginated.loadNextPage(isRefresh: true));
      }
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }
}
