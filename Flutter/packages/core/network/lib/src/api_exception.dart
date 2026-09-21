import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

/// Classifies the root cause of an API failure so the UI layer can
/// distinguish "no internet" from "server error" from "timeout", etc.
/// (Port of Hadidi-Win `core/networking/error_type.dart`.)
enum ErrorType {
  /// No network adapter enabled (WiFi off, airplane mode).
  offline,

  /// Adapter on but request failed (DNS, socket, connection drop).
  network,

  /// Connect / send / receive timeout.
  timeout,

  /// Server responded 4xx.
  clientError,

  /// Server responded 5xx.
  serverError,

  /// Request cancelled.
  cancelled,

  /// TLS / certificate error.
  certificate,

  /// Anything else.
  unknown,
}

/// Typed failure wrapping every network/HTTP error.
///
/// Callers only ever see [ApiException], never a raw [DioException].
/// `message` prefers the backend `ApiResponse.message`, then the first
/// entry of `errors`, then an HTTP-status fallback.
final class ApiException implements Exception {
  ApiException(
    this.message, {
    required this.errorType,
    this.statusCode,
    this.traceId,
    this.errors = const [],
    this.originalError,
    this.stackTrace,
    this.retryAfter,
  });

  final String message;
  final ErrorType errorType;
  final int? statusCode;
  final String? traceId;
  final List<String> errors;
  final Object? originalError;
  final StackTrace? stackTrace;

  /// Backend `Retry-After` (seconds) on HTTP 429, if provided.
  final Duration? retryAfter;

  bool get isOffline =>
      errorType == ErrorType.offline || errorType == ErrorType.network;
  bool get isUnauthorized => statusCode == 401;
  bool get isRateLimited => statusCode == 429;

  @override
  String toString() => 'ApiException($statusCode, $errorType): $message';
}

/// Converts any thrown [error] into an [ApiException].
/// (Port of Hadidi-Win `APIErrorHandler`, adapted to the
/// `ApiResponse` envelope where `errors` is `List<String>`.)
abstract final class ApiErrorHandler {
  static ApiException handle(Object error, {StackTrace? stackTrace}) {
    final (message, errorType, statusCode, traceId, errors, retryAfter) =
        switch (error) {
      DioException() => _fromDio(error),
      SocketException() => (
        'No internet connection. Please check your network.',
        ErrorType.offline,
        null as int?,
        null as String?,
        const <String>[],
        null as Duration?,
      ),
      FormatException() => (
        'Unexpected response format.',
        ErrorType.unknown,
        null as int?,
        null as String?,
        const <String>[],
        null as Duration?,
      ),
      TypeError() => (
        'Unexpected response format.',
        ErrorType.unknown,
        null as int?,
        null as String?,
        const <String>[],
        null as Duration?,
      ),
      _ => (
        'An unexpected error occurred.',
        ErrorType.unknown,
        null as int?,
        null as String?,
        const <String>[],
        null as Duration?,
      ),
    };

    return ApiException(
      message,
      errorType: errorType,
      statusCode: statusCode,
      traceId: traceId,
      errors: errors,
      originalError: error,
      stackTrace: stackTrace,
      retryAfter: retryAfter,
    );
  }

  // ── private helpers ────────────────────────────────────────────────

  static (String, ErrorType, int?, String?, List<String>, Duration?)
  _fromDio(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionError => (
        'No internet connection. Please check your network.',
        ErrorType.offline,
        null,
        null,
        const <String>[],
        null,
      ),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => (
        'Request timed out. Please try again.',
        ErrorType.timeout,
        null,
        null,
        const <String>[],
        null,
      ),
      DioExceptionType.sendTimeout => (
        'Request timed out while sending. Please try again.',
        ErrorType.timeout,
        null,
        null,
        const <String>[],
        null,
      ),
      DioExceptionType.cancel => (
        'Request was cancelled.',
        ErrorType.cancelled,
        null,
        null,
        const <String>[],
        null,
      ),
      DioExceptionType.badCertificate => (
        'Secure connection failed. Please try again later.',
        ErrorType.certificate,
        null,
        null,
        const <String>[],
        null,
      ),
      DioExceptionType.badResponse => _fromResponse(
        error.response,
        retryAfter: _parseRetryAfter(error.response),
      ),
      DioExceptionType.unknown => _fromUnknown(error),
    };
  }

  static (String, ErrorType, int?, String?, List<String>, Duration?)
  _fromResponse(Response<dynamic>? response, {Duration? retryAfter}) {
    final statusCode = response?.statusCode;
    final errorType = _errorTypeFromStatus(statusCode);
    final data = response?.data;

    final traceId = response?.headers['X-Trace-Id']?.firstOrNull;

    // 1. Structured `ApiResponse` error body.
    if (data is Map) {
      try {
        final map = Map<String, dynamic>.from(data);
        traceId ??= map['traceId'] as String?;
        final message = (map['message'] as String?)?.trim();
        final errors = _parseErrors(map['errors']);
        if (message != null && message.isNotEmpty) {
          return (message, errorType, statusCode, traceId, errors, retryAfter);
        }
        if (errors.isNotEmpty) {
          return (
            errors.first,
            errorType,
            statusCode,
            traceId,
            errors,
            retryAfter,
          );
        }
      } catch (_) {
        // Body didn't match the envelope — fall through.
      }
    }

    // 2. Plain-string body (e.g. nginx HTML page): never expose raw HTML.
    return (
      _httpStatusMessage(statusCode),
      errorType,
      statusCode,
      traceId,
      const <String>[],
      retryAfter,
    );
  }

  static (String, ErrorType, int?, String?, List<String>, Duration?)
  _fromUnknown(DioException error) {
    if (error.error is SocketException) {
      return (
        'No internet connection. Please check your network.',
        ErrorType.network,
        null,
        null,
        const <String>[],
        null,
      );
    }
    if (error.response != null) {
      return _fromResponse(error.response);
    }
    log('ApiErrorHandler unmapped: ${error.error}, response: ${error.response}');
    return (
      'An unexpected error occurred.',
      ErrorType.unknown,
      null,
      null,
      const <String>[],
      null,
    );
  }

  static List<String> _parseErrors(Object? raw) {
    if (raw == null) return const [];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is Map) {
      return raw.values
          .expand((v) => v is List ? v : [v])
          .map((e) => e.toString())
          .toList();
    }
    return [raw.toString()];
  }

  static Duration? _parseRetryAfter(Response<dynamic>? response) {
    final raw = response?.headers['Retry-After']?.firstOrNull;
    if (raw == null) return null;
    final seconds = int.tryParse(raw.trim());
    if (seconds == null) return null;
    return Duration(seconds: seconds);
  }

  static ErrorType _errorTypeFromStatus(int? statusCode) {
    if (statusCode == null) return ErrorType.unknown;
    return switch (statusCode) {
      >= 400 && < 500 => ErrorType.clientError,
      >= 500 => ErrorType.serverError,
      _ => ErrorType.unknown,
    };
  }

  static String _httpStatusMessage(int? statusCode) => switch (statusCode) {
    400 => 'Bad request. Please check your input.',
    401 => 'Session expired. Please log in again.',
    403 => 'You do not have permission for this action.',
    404 => 'Requested resource was not found.',
    408 => 'Request timed out. Please try again.',
    409 => 'Conflict. This record already exists.',
    422 => 'Validation failed. Please check your input.',
    429 => 'Too many requests. Please wait a moment and retry.',
    500 => 'Server error. Please try again later.',
    502 => 'Bad gateway. Please try again later.',
    503 => 'Service unavailable. Please try again later.',
    504 => 'Gateway timeout. Please try again later.',
    _ => 'An unexpected error occurred.',
  };
}
