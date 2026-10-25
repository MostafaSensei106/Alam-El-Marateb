import '../../constants/types/type_def.dart';
import '../../error/failures.dart';
import '../../utils/result/result.dart';
import '../api_error_handler.dart';

final class ApiExecutor {
  const ApiExecutor._();
  static Future<ApiResult<T>> execute<T>({
    required Future<T> Function() action,
  }) => Result.tryCatching<T, Failures>(
    action: action,
    catchErrors: true,
    onError: (e, st) => APIErrorHandler.handle(e, stackTrace: st),
  );

  static Future<ApiResult<T>> executeMapped<D, T>({
    required Future<D> Function() action,
    required T Function(D dto) mapper,
  }) => execute<T>(action: () async => mapper(await action()));
}
