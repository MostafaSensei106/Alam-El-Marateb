import 'api_exception.dart';

/// Executes an API call and converts any thrown error into an
/// [ApiException]. (Port of Hadidi-Win `ApiExecutor`.)
abstract final class ApiExecutor {
  static Future<T> execute<T>({required Future<T> Function() action}) async {
    try {
      return await action();
    } catch (e, st) {
      throw ApiErrorHandler.handle(e, stackTrace: st);
    }
  }
}
