import 'package:dio/dio.dart';

/// Server error envelope mirror: {success, message, errors[]}.
/// Backend `errors` is a list of machine codes
/// (TOKEN_MISSING / TOKEN_EXPIRED / TOKEN_INVALID / CLIENT_REJECTED / ...).
class ApiErrorModel {
  const ApiErrorModel({
    required this.success,
    required this.message,
    this.errors = const <String>[],
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    final errors = json['errors'];
    return ApiErrorModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'An unexpected error occurred.',
      errors: errors is List
          ? errors.map((e) => e.toString()).toList()
          : const <String>[],
    );
  }

  final bool success;
  final String message;
  final List<String> errors;

  /// First machine code, if the backend sent any.
  String? get code => errors.isEmpty ? null : errors.first;
}

/// Root-cause classification so UI can tell offline/timeout/auth apart.
enum ErrorType {
  offline,
  network,
  timeout,
  unauthorized,
  forbidden,
  clientError,
  serverError,
  cancelled,
  certificate,
  unknown,
}

/// Base failure: the rest of the app only ever sees these, never Dio.
sealed class Failures {
  const Failures(this.message);
  final String message;
}

class ServerFailure extends Failures {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failures {
  const NetworkFailure(super.message);
}

class OfflineFailure extends Failures {
  const OfflineFailure(super.message);
}

class TimeoutFailure extends Failures {
  const TimeoutFailure(super.message);
}

class AuthFailure extends Failures {
  const AuthFailure(super.message, {this.code});

  final String? code;
}

class ClientRejectedFailure extends Failures {
  const ClientRejectedFailure(super.message);
}

class UnknownFailure extends Failures {
  const UnknownFailure(super.message);
}

/// Typed failure wrapping every Dio error into [ApiErrorModel].
abstract final class ApiErrorHandler {
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
        if (statusCode == 401) {
          return AuthFailure(model.message, code: model.code);
        }
        if (statusCode == 403) {
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
      >= 500 => const ServerFailure('Server error. Please try again later.'),
      _ => const UnknownFailure('An unexpected error occurred.'),
    };
  }
}
