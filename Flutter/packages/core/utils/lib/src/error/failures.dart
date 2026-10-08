import 'package:flutter/foundation.dart';

/// Base class for all domain failures.
/// Uses [sealed] to guarantee exhaustive pattern matching across the app.
@immutable
sealed class Failure {
  const Failure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;

  @override
  String toString() =>
      '$runtimeType(message: $message, statusCode: $statusCode)';
}

// -----------------------------------------------------------------------------
// Concrete Failures
// -----------------------------------------------------------------------------

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.statusCode});
}

final class CooldownFailure extends Failure {
  const CooldownFailure(super.message, {super.statusCode});
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.statusCode});
}

final class OfflineFailure extends Failure {
  const OfflineFailure(super.message, {super.statusCode});
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.statusCode});
}

final class LocalStorageFailure extends Failure {
  const LocalStorageFailure(super.message, {super.statusCode});
}

final class BadResponseParsingFailure extends Failure {
  const BadResponseParsingFailure(super.message, {super.statusCode});
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.statusCode});
}
