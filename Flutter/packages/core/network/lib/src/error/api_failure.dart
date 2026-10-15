import 'package:alam_el_marateb_result/result.dart';

import 'package:alam_el_marateb_network/src/error/api_error_model.dart';
import 'package:alam_el_marateb_network/src/error/error_type.dart';

/// Typed network failure carrying the parsed backend error body.
///
/// Extends the core [Failure] so callers only ever handle [Failure]
/// subtypes and stay decoupled from Dio. Lives in the network package
/// (not `result`) because it depends on [ApiErrorModel]/[ErrorType`.
final class ApiFailure extends Failure {
  ApiFailure(
    this.apiErrorModel, {
    required this.errorType,
    this.originalError,
    this.stackTrace,
    super.statusCode,
  }) : super(
         // Prefer the backend's human message (already localized server-side);
         // machine codes stay available via [apiErrorModel.errors].
         apiErrorModel.message,
       );

  final ApiErrorModel apiErrorModel;
  final ErrorType errorType;

  /// The HTTP status code from the server response, if available.
  /// (Also exposed via [Failure.statusCode].)
  final Object? originalError;
  final StackTrace? stackTrace;
}
