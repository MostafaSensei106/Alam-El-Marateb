import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

/// Retries only genuine transient failures.
///
/// Design notes:
/// - No request gating: requests always go to the network stack. A truly
///   offline device fails fast with [DioExceptionType.connectionError] from
///   the socket itself, which is never retried — the cache interceptor's
///   `onError` fallback (or the offline Failure mapping downstream) then
///   resolves immediately instead of paying back-off delays.
/// - App connectivity state is owned solely by [NetworkCubit]'s debounced
///   `ConnectivityPlus` stream. This interceptor never touches it, so a
///   single slow/failed request can't flap the global online/offline UI.
final class DioRetryInterceptor extends Interceptor {
  DioRetryInterceptor({required Dio dio, this.logger}) {
    _retryInterceptor = RetryInterceptor(
      dio: dio,
      logPrint: logger ?? _noopLogger,
      retries: _retryDelays.length,
      retryDelays: _retryDelays,
      retryEvaluator: (DioException error, int attempt) async {
        // Offline (or an immediately refused connection) can only fail again.
        if (error.type == DioExceptionType.connectionError) return false;

        final shouldRetry = _isTransientError(error);
        if (shouldRetry) {
          logger?.call('[Retry] Attempt $attempt for ${error.type}');
        }
        return shouldRetry;
      },
    );
  }

  /// Optional structured logger. Pass `debugPrint` in debug builds,
  /// or a Crashlytics/Datadog sink in release builds.
  /// Defaults to a no-op so nothing leaks to the console in production.
  final void Function(String message)? logger;

  late final RetryInterceptor _retryInterceptor;

  /// Exponential back-off: 1 s → 2 s → 4 s → 8 s.
  static const _retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
  ];

  /// HTTP status codes that indicate a transient server issue worth retrying.
  static const _retryableStatusCodes = {502, 503, 504};

  static void _noopLogger(String _) {}

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // connectionError is excluded: retrying a dead socket is pointless and
    // would delay the cache fallback / offline mapping behind back-offs.
    if (err.type != DioExceptionType.connectionError &&
        _isTransientError(err)) {
      return _retryInterceptor.onError(err, handler);
    }
    return handler.next(err);
  }

  /// `true` only for failures worth retrying: timeouts (the request left the
  /// device but the server was too slow) and transient 502/503/504.
  /// Deliberately excludes `cancel`, `badCertificate`, `unknown`, and every
  /// other 4xx/5xx — those are answers, not accidents.
  bool _isTransientError(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => true,
      DioExceptionType.badResponse => _retryableStatusCodes.contains(
        err.response?.statusCode,
      ),
      _ => false,
    };
  }
}
