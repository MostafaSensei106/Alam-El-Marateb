import 'api_error_model.dart';
import 'error_type.dart';

/// Base failure: the rest of the app only ever sees these, never Dio.
sealed class Failures implements Exception {
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

/// Typed failure wrapping every network error into [ApiErrorModel].
class ApiFailure extends Failures {
  ApiFailure(
    this.apiErrorModel, {
    required this.errorType,
    this.statusCode,
    this.originalError,
    this.stackTrace,
  }) : super(
         apiErrorModel.errors.isNotEmpty
             ? apiErrorModel.errors.first
             : apiErrorModel.message,
       );

  final ApiErrorModel apiErrorModel;
  final ErrorType errorType;

  /// The HTTP status code from the server response, if available.
  final int? statusCode;
  final Object? originalError;
  final StackTrace? stackTrace;
}
