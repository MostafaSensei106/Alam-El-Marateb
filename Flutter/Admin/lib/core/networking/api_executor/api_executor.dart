import '../../constants/types/type_def.dart';
import '../api_error_handler.dart';

final class ApiExecutor {
  static Future<ApiResult<T>> execute<T>({
    required Future<T> Function() action,
  }) => ApiResult.tryCatching(
    action: action,
    onError: (e, st) => APIErrorHandler.handle(e, stackTrace: st),
  );
}
