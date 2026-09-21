import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// `Idempotency-Key` handling.
///
/// The backend requires an idempotency key on mutating money/stock
/// endpoints (`place-order`, `complete-sale`, `receive`, `checkout`…).
/// Replays with the same key return the original result plus an
/// `Idempotent-Replay` header instead of double-charging.
///
/// - Call [withKey] explicitly when the caller owns the key (e.g. one key
///   per checkout attempt, reused across retries of the same user action).
/// - Otherwise the interceptor auto-generates a UUID v4 for POSTs to known
///   mutating paths that arrive without a key.
final class IdempotencyInterceptor extends Interceptor {
  IdempotencyInterceptor({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  /// Paths (substrings, lowercase) that must carry an idempotency key.
  static const mutatingPaths = [
    'place-order',
    'complete-sale',
    'custom-order',
    '/receive',
    '/checkout/',
    '/pay-balance',
    '/pay',
    '/fulfill',
  ];

  /// Applies [key] (or a fresh UUID) to [options].
  static RequestOptions withKey(RequestOptions options, [String? key]) {
    options.headers['Idempotency-Key'] =
        (key == null || key.isEmpty) ? const Uuid().v4() : key;
    return options;
  }

  /// Builds headers containing a fresh (or provided) idempotency key,
  /// for use with retrofit `@Header` / manual calls.
  Map<String, String> headers([String? key]) => {
    'Idempotency-Key':
        (key == null || key.isEmpty) ? _uuid.v4() : key,
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'POST' &&
        !options.headers.containsKey('Idempotency-Key') &&
        mutatingPaths.any(
          (p) => options.path.toLowerCase().contains(p),
        )) {
      options.headers['Idempotency-Key'] = _uuid.v4();
    }
    handler.next(options);
  }
}
