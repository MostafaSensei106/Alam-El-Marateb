/// Deduplicates identical in-flight API calls.
///
/// If two screens request the same endpoint with the same key in parallel,
/// only a single network round-trip is performed and both callers share the
/// same [Future]. The entry is removed as soon as the request completes.
final class RequestDeduplicator {
  final Map<String, Future<dynamic>> _inFlight = {};

  Future<T> run<T>({
    required String key,
    required Future<T> Function() action,
  }) async {
    final existing = _inFlight[key];
    if (existing != null) {
      return existing as Future<T>;
    }

    final future = action();
    _inFlight[key] = future;
    await future.whenComplete(() => _inFlight.remove(key));
    return future;
  }
}
