import 'package:alam_el_marateb_result/result.dart';

import 'package:alam_el_marateb_network/src/error/api_error_handler.dart';

/// Executes an async [action] and wraps any thrown error into a typed
/// [Failure] via [APIErrorHandler] — so repositories always return
/// `Result<T, Failure>` and never leak raw exceptions.
///
/// NOTE: the retrofit `ApiService` with domain endpoints intentionally does
/// NOT live here — each module in `packages/modules/*` owns its own service
/// interface. This executor is the only shared piece.
final class ApiExecutor {
  const ApiExecutor._();

  static Future<Result<T, Failure>> execute<T>({
    required Future<T> Function() action,
  }) => Result.tryCatching(
    action: action,
    onError: (e, st) => APIErrorHandler.handle(e, stackTrace: st),
  );
}
