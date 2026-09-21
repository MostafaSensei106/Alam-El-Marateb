/// Deduplicates identical in-flight API calls.
///
/// If two callers request the same [key] in parallel, only one network
/// round-trip runs and both share the same [Future].
/// (Port of Hadidi-Win `RequestDeduplicator`.)
final class RequestDeduplicator {
  final Map<String, Future<dynamic>> _inFlight = {};

  Future<T> run<T>({
    required String key,
    required Future<T> Function() action,
  }) async {
    final existing = _inFlight[key];
    if (existing != null) return existing as Future<T>;
    final future = action();
    _inFlight[key] = future;
    try {
      return await future;
    } finally {
      _inFlight.remove(key);
    }
  }
}
