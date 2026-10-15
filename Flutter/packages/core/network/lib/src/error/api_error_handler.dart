import 'dart:developer';
import 'dart:io';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';

import 'package:alam_el_marateb_network/src/error/api_error_model.dart';
import 'package:alam_el_marateb_network/src/error/api_failure.dart';
import 'package:alam_el_marateb_network/src/error/error_type.dart';

/// A typed failure factory that wraps every network/HTTP error into a
/// unified [ApiFailure].
///
/// Callers only ever see a [Failure] subtype, never a raw [DioException].
///
/// Usage:
/// ```dart
/// try {
///   await dio.get('/endpoint');
/// } on DioException catch (e, st) {
///   throw APIErrorHandler.handle(e, stackTrace: st);
/// }
/// ```
abstract class APIErrorHandler {
  // ── static helper ──────────────────────────────────────────────────────────

  /// Converts any [error] into an [ApiFailure].
  ///
  /// Pass [stackTrace] so callers can forward it to an error-reporting service.
  static ApiFailure handle(Object error, {StackTrace? stackTrace}) {
    // Keep a hook here for Crashlytics / Sentry:
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);

    final (model, errorType, statusCode) = switch (error) {
      DioException() => _fromDio(error),
      SocketException() => (
        _noInternetModel(),
        ErrorType.offline,
        null as int?,
      ),
      FormatException() => (
        _buildModel(HttpMessages.unknownError),
        ErrorType.unknown,
        null as int?,
      ),
      TypeError() => (
        _buildModel(HttpMessages.unknownError),
        ErrorType.unknown,
        null as int?,
      ),
      _ => (_unknownModel(), ErrorType.unknown, null as int?),
    };

    return ApiFailure(
      model,
      errorType: errorType,
      statusCode: statusCode,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  // ── private helpers ─────────────────────────────────────────────────────────

  static (ApiErrorModel, ErrorType, int?) _fromDio(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionError => (
        _fromConnectionError(error.error),
        ErrorType.offline,
        null,
      ),
      DioExceptionType.connectionTimeout || DioExceptionType.receiveTimeout => (
        _timeoutModel(),
        ErrorType.timeout,
        null,
      ),
      DioExceptionType.sendTimeout => (
        _buildModel(HttpMessages.sendTimeout),
        ErrorType.timeout,
        null,
      ),
      DioExceptionType.cancel => (
        _buildModel(HttpMessages.requestCancelled),
        ErrorType.cancelled,
        null,
      ),
      DioExceptionType.badCertificate => (
        _buildModel(HttpMessages.badCertificate),
        ErrorType.certificate,
        null,
      ),
      DioExceptionType.badResponse => _fromResponse(error.response),
      DioExceptionType.unknown => _fromUnknown(error.error, error.response),
      // transformTimeout is a valid timeout — never crash.
      DioExceptionType.transformTimeout => (
        _timeoutModel(),
        ErrorType.timeout,
        null,
      ),
    };
  }

  static ApiErrorModel _fromConnectionError(Object? cause) {
    if (cause is SocketException) return _noInternetModel();
    return _noInternetModel(); // connectionError type is always connectivity
  }

  static (ApiErrorModel, ErrorType, int?) _fromResponse(
    Response<dynamic>? response,
  ) {
    final statusCode = response?.statusCode;
    final errorType = _errorTypeFromStatus(statusCode);
    final data = response?.data;

    // 1. Try to parse a structured JSON error body.
    if (data is Map) {
      try {
        final map = Map<String, dynamic>.from(data);
        return (ApiErrorModel.fromJson(map), errorType, statusCode);
      } catch (_) {
        // JSON structure didn't match our model — fall through.
      }
    }

    // 2. If the body is a plain string (e.g. HTML error page from nginx),
    //    extract a short snippet for debugging but use the standard message.
    if (data is String && data.isNotEmpty) {
      // Don't expose raw HTML/text to the user — use the HTTP status message.
      final statusMessage = _httpStatusMessage(statusCode);
      return (_buildModel(statusMessage), errorType, statusCode);
    }

    // 3. Fallback: no body or unrecognisable format.
    final statusMessage = _httpStatusMessage(statusCode);
    return (_buildModel(statusMessage), errorType, statusCode);
  }

  static (ApiErrorModel, ErrorType, int?) _fromUnknown(
    Object? cause,
    Response<dynamic>? response,
  ) {
    // Prefer typed checks over fragile string matching.
    if (cause is SocketException) {
      return (_noInternetModel(), ErrorType.network, null);
    }

    if (response != null) {
      return _fromResponse(response);
    }
    log('APIErrorHandler _fromUnknown cause: $cause, response: $response');

    return (_unknownModel(), ErrorType.unknown, null);
  }

  // ── error type classification ───────────────────────────────────────────────

  static ErrorType _errorTypeFromStatus(int? statusCode) {
    if (statusCode == null) return ErrorType.unknown;
    return switch (statusCode) {
      >= 400 && < 500 => ErrorType.clientError,
      >= 500 => ErrorType.serverError,
      _ => ErrorType.unknown,
    };
  }

  // ── model factories ─────────────────────────────────────────────────────────

  static ApiErrorModel _buildModel(String message) =>
      ApiErrorModel(success: false, message: message, errors: const []);

  static ApiErrorModel _noInternetModel() =>
      _buildModel(HttpMessages.noInternet);

  static ApiErrorModel _timeoutModel() =>
      _buildModel(HttpMessages.gatewayTimeout);

  static ApiErrorModel _unknownModel() =>
      _buildModel(HttpMessages.unknownError);

  // ── HTTP status → message ───────────────────────────────────────────────────

  static String _httpStatusMessage(int? statusCode) => switch (statusCode) {
    400 => HttpMessages.badRequest,
    401 => HttpMessages.unauthorized,
    403 => HttpMessages.forbidden,
    404 => HttpMessages.notFound,
    408 => HttpMessages.requestTimeout,
    409 => HttpMessages.conflict,
    422 => HttpMessages.unprocessableEntity,
    429 => HttpMessages.tooManyRequests,
    500 => HttpMessages.internalServerError,
    502 => HttpMessages.badGateway,
    503 => HttpMessages.serviceUnavailable,
    504 => HttpMessages.gatewayTimeout,
    _ => HttpMessages.unknownError,
  };
}
