import '../networking/api_error_model/api_error_model.dart';
import '../networking/error_type.dart';

export 'failure_extension.dart';

sealed class Failures {
  const Failures(this.message);
  final String message;
}

class ServerFailure extends Failures {
  const ServerFailure(super.message);
}

class CacheFailure extends Failures {
  const CacheFailure(super.message);
}

class CooldownFailure extends Failures {
  const CooldownFailure(super.message);
}

class NetworkFailure extends Failures {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failures {
  const UnknownFailure(super.message);
}

class TimeoutFailure extends Failures {
  const TimeoutFailure(super.message);
}

class OfflineFailure extends Failures {
  const OfflineFailure(super.message);
}

class LocalStorageFailure extends Failures {
  const LocalStorageFailure(super.message);
}

class ApiFailure extends Failures {
  ApiFailure(
    this.apiErrorModel, {
    required this.errorType,
    this.statusCode,
    this.originalError,
    this.stackTrace,
  }) : super(
         apiErrorModel.errors?.values.firstOrNull?.firstOrNull ??
             apiErrorModel.message,
       );

  final ApiErrorModel apiErrorModel;
  final ErrorType errorType;

  /// The HTTP status code from the server response, if available.
  final int? statusCode;
  final Object? originalError;
  final StackTrace? stackTrace;
}
