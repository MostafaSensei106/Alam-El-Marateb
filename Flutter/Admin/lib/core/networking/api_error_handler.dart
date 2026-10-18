import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/http_messages.dart';
import '../constants/http_status_code.dart';
import '../error/failures.dart';
import 'api_error_model/api_error_model.dart';
import 'error_type.dart';

/// Pure failure mapper that classifies raw exceptions and HTTP responses
/// into structured domain [ApiFailure] instances.
///
/// Decouples network/Dio exceptions from application business logic.
abstract final class ApiFailureMapper {
  /// Maps any [error] into an [ApiFailure].
  static ApiFailure map(Object error, {StackTrace? stackTrace}) {
    final (model, errorType, statusCode) = switch (error) {
      DioException() => _fromDio(error),
      SocketException() => (_noInternetModel(), ErrorType.offline, null),
      FormatException() => (
        _buildModel(HttpMessages.serializationError),
        ErrorType.serialization,
        null,
      ),
      TypeError() => (
        _buildModel(HttpMessages.serializationError),
        ErrorType.serialization,
        null,
      ),
      _ => (_unknownModel(), ErrorType.unknown, null),
    };

    return ApiFailure(
      model,
      errorType: errorType,
      statusCode: statusCode,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  // ── private classification & mapping ───────────────────────────────────────

  static (ApiErrorModel, ErrorType, int?) _fromDio(DioException error) {
    // Response-first: if the server returned a response, prioritize its status code and payload
    if (error.response != null) {
      return _fromResponse(error.response);
    }

    return switch (error.type) {
      DioExceptionType.connectionError => (
        _fromConnectionError(error.error),
        ErrorType.offline,
        null,
      ),
      DioExceptionType.connectionTimeout => (
        _buildModel(HttpMessages.connectionTimeout),
        ErrorType.timeout,
        null,
      ),
      DioExceptionType.receiveTimeout => (
        _buildModel(HttpMessages.gatewayTimeout),
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
      DioExceptionType.transformTimeout => (
        _buildModel(HttpMessages.gatewayTimeout),
        ErrorType.timeout,
        null,
      ),
    };
  }

  static ApiErrorModel _fromConnectionError(Object? cause) {
    if (cause is SocketException) return _noInternetModel();
    return _noInternetModel();
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
        final model = ApiErrorModel.fromJson(map);

        final hasMeaningfulMessage =
            model.message.trim().isNotEmpty &&
            model.message != 'An unexpected error occurred.';
        final hasErrors = model.errors != null && model.errors!.isNotEmpty;

        if (hasMeaningfulMessage || hasErrors) {
          return (model, errorType, statusCode);
        }

        return (model, errorType, statusCode);
      } catch (_) {
        // Fall through to status code message
      }
    }

    // 2. Fallback: string body (e.g. HTML or plain text) or empty body.
    final statusMessage = _httpStatusMessage(statusCode);
    return (_buildModel(statusMessage), errorType, statusCode);
  }

  static (ApiErrorModel, ErrorType, int?) _fromUnknown(
    Object? cause,
    Response<dynamic>? response,
  ) {
    // 1. Response check first: retain status code and payload if available
    if (response != null) {
      return _fromResponse(response);
    }

    // 2. Classify cause when no response is available
    if (cause is SocketException) {
      return (_noInternetModel(), ErrorType.network, null);
    }

    return (_unknownModel(), ErrorType.unknown, null);
  }

  // ── error type classification ───────────────────────────────────────────────

  static ErrorType _errorTypeFromStatus(int? statusCode) {
    if (statusCode == null) return ErrorType.unknown;
    return switch (statusCode) {
      >= 400 && <= 499 => ErrorType.clientError,
      >= 500 && <= 599 => ErrorType.serverError,
      _ => ErrorType.unknown,
    };
  }

  // ── model factories ─────────────────────────────────────────────────────────

  static ApiErrorModel _buildModel(String message) =>
      ApiErrorModel(success: false, message: message, errors: const {});

  static ApiErrorModel _noInternetModel() =>
      _buildModel(HttpMessages.noInternet);

  static ApiErrorModel _unknownModel() =>
      _buildModel(HttpMessages.unknownError);

  // ── HTTP status → message mapping (all HttpStatusCodes) ─────────────────────

  static String _httpStatusMessage(int? statusCode) {
    if (statusCode == null) return HttpMessages.unknownError;

    return switch (statusCode) {
      // 4xx Client Errors
      HttpStatusCodes.badRequest => HttpMessages.badRequest,
      HttpStatusCodes.unauthorized => HttpMessages.unauthorized,
      HttpStatusCodes.paymentRequired => HttpMessages.paymentRequired,
      HttpStatusCodes.forbidden => HttpMessages.forbidden,
      HttpStatusCodes.notFound => HttpMessages.notFound,
      HttpStatusCodes.methodNotAllowed => HttpMessages.methodNotAllowed,
      HttpStatusCodes.notAcceptable => HttpMessages.notAcceptable,
      HttpStatusCodes.proxyAuthenticationRequired =>
        HttpMessages.proxyAuthenticationRequired,
      HttpStatusCodes.requestTimeout => HttpMessages.requestTimeout,
      HttpStatusCodes.conflict => HttpMessages.conflict,
      HttpStatusCodes.gone => HttpMessages.gone,
      HttpStatusCodes.lengthRequired => HttpMessages.lengthRequired,
      HttpStatusCodes.preconditionFailed => HttpMessages.preconditionFailed,
      HttpStatusCodes.payloadTooLarge => HttpMessages.payloadTooLarge,
      HttpStatusCodes.uriTooLong => HttpMessages.uriTooLong,
      HttpStatusCodes.unsupportedMediaType => HttpMessages.unsupportedMediaType,
      HttpStatusCodes.rangeNotSatisfiable => HttpMessages.rangeNotSatisfiable,
      HttpStatusCodes.expectationFailed => HttpMessages.expectationFailed,
      HttpStatusCodes.imATeapot => HttpMessages.imATeapot,
      HttpStatusCodes.misdirectedRequest => HttpMessages.misdirectedRequest,
      HttpStatusCodes.unprocessableEntity => HttpMessages.unprocessableEntity,
      HttpStatusCodes.locked => HttpMessages.locked,
      HttpStatusCodes.failedDependency => HttpMessages.failedDependency,
      HttpStatusCodes.tooEarly => HttpMessages.tooEarly,
      HttpStatusCodes.upgradeRequired => HttpMessages.upgradeRequired,
      HttpStatusCodes.preconditionRequired => HttpMessages.preconditionRequired,
      HttpStatusCodes.tooManyRequests => HttpMessages.tooManyRequests,
      HttpStatusCodes.requestHeaderFieldsTooLarge =>
        HttpMessages.requestHeaderFieldsTooLarge,
      HttpStatusCodes.unavailableForLegalReasons =>
        HttpMessages.unavailableForLegalReasons,

      // 5xx Server Errors
      HttpStatusCodes.internalServerError => HttpMessages.internalServerError,
      HttpStatusCodes.notImplemented => HttpMessages.notImplemented,
      HttpStatusCodes.badGateway => HttpMessages.badGateway,
      HttpStatusCodes.serviceUnavailable => HttpMessages.serviceUnavailable,
      HttpStatusCodes.gatewayTimeout => HttpMessages.gatewayTimeout,
      HttpStatusCodes.httpVersionNotSupported =>
        HttpMessages.httpVersionNotSupported,
      HttpStatusCodes.variantAlsoNegotiates =>
        HttpMessages.variantAlsoNegotiates,
      HttpStatusCodes.insufficientStorage => HttpMessages.insufficientStorage,
      HttpStatusCodes.loopDetected => HttpMessages.loopDetected,
      HttpStatusCodes.notExtended => HttpMessages.notExtended,
      HttpStatusCodes.networkAuthenticationRequired =>
        HttpMessages.networkAuthenticationRequired,
      HttpStatusCodes.networkConnectTimeoutError =>
        HttpMessages.networkConnectTimeoutError,

      // Fallbacks within standard HTTP error ranges
      >= 400 && <= 499 => HttpMessages.badRequest,
      >= 500 && <= 599 => HttpMessages.internalServerError,

      _ => HttpMessages.unknownError,
    };
  }
}

/// Facade maintaining backward compatibility with the existing codebase.
abstract final class APIErrorHandler {
  APIErrorHandler._();

  /// Converts any [error] into an [ApiFailure] by delegating to [ApiFailureMapper].
  static ApiFailure handle(Object error, {StackTrace? stackTrace}) =>
      ApiFailureMapper.map(error, stackTrace: stackTrace);
}
