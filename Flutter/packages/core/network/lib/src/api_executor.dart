import 'package:dio/dio.dart';

import 'error/api_error_handler.dart';

/// Executes one backend call against the slim envelope contract.
///
/// - Parses `data` with [fromData] when `success` is true.
/// - Throws the mapped [Failures] otherwise (never a raw [DioException]).
///
/// Usage:
/// ```dart
/// final product = await ApiExecutor.call(
///   () => dio.get('/products/$id'),
///   (json) => Product.fromJson(json as Map<String, dynamic>),
/// );
/// ```
abstract final class ApiExecutor {
  static Future<T> call<T>(
    Future<Response<dynamic>> Function() request,
    T Function(Object? json) fromData,
  ) async {
    try {
      final response = await request();
      final body = response.data;
      if (body is Map<String, dynamic> && body['success'] == true) {
        return fromData(body['data']);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    } on DioException catch (e, st) {
      throw ApiErrorHandler.handle(e, stackTrace: st);
    }
  }
}
