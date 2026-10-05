import 'package:dio/dio.dart';

import 'api_error_model.dart';
import 'failures.dart';

/// Converts any error into a typed [Failures] subtype.
///
/// Usage:
/// ```dart
/// try {
///   await dio.get('/endpoint');
/// } on DioException catch (e, st) {
///   throw ApiErrorHandler.handle(e, stackTrace: st);
/// }
/// ```
abstract final class ApiErrorHandler {
  /// Converts any [error] into a [Failures].
  ///
  /// Pass [stackTrace] so callers can forward it to an error-reporting service.
  static Failures handle(Object error, {StackTrace? stackTrace}) {
    if (error is DioException) {
      return _fromDio(error);
    }
    return const UnknownFailure('An unexpected error occurred.');
  }

  static Failures _fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        return const OfflineFailure('No internet connection.');
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure('Request timed out.');
      case DioExceptionType.cancel:
        return const UnknownFailure('Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const UnknownFailure('Certificate error.');
      case DioExceptionType.badResponse:
        return _fromResponse(error.response);
      case DioExceptionType.unknown:
        return const NetworkFailure('Network error. Please try again.');
    }
  }

  static Failures _fromResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      try {
        final model = ApiErrorModel.fromJson(data);
        if (statusCode == 401 && model.code == 'CLIENT_REJECTED') {
          return ClientRejectedFailure(model.message);
        }
        if (statusCode == 401 || statusCode == 403) {
          return AuthFailure(model.message, code: model.code);
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerFailure(model.message);
        }
        return ServerFailure(
          model.errors.isNotEmpty ? model.errors.first : model.message,
        );
      } catch (_) {
        // Body didn't match the envelope — fall through to status mapping.
      }
    }
    return switch (statusCode) {
      401 => const AuthFailure('Session expired. Please log in again.'),
      403 => const AuthFailure(
        'You are not allowed to perform this action.',
      ),
      final int code when code >= 500 =>
        const ServerFailure('Server error. Please try again later.'),
      _ => const UnknownFailure('An unexpected error occurred.'),
    };
  }
}
