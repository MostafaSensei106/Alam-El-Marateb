import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../constants/http_messages.dart';
import '../constants/http_status_code.dart';
import '../error/failures.dart';
import 'api_error_model/api_error_model.dart';
import 'error_type.dart';
import 'platform_connectivity.dart';

/// Pure failure mapper that classifies raw exceptions and HTTP responses
/// into structured domain [ApiFailure] instances.
///
/// Decouples network/Dio exceptions from application business logic.
abstract final class ApiFailureMapper {
  /// Placeholder produced by [ApiErrorModel.fromJson] when the payload has no
  /// `message`, so it must not be shown to the user.
  static const _defaultModelMessage = 'An unexpected error occurred.';

  /// Maps any [error] into an [ApiFailure].
  static ApiFailure map(Object error, {StackTrace? stackTrace}) {
    final (model, errorType, statusCode) = switch (error) {
      DioException() => _fromDio(error),
      SocketException() => _fromTransport(error),
      HandshakeException() => _certificateFailure(),
      TlsException() => _certificateFailure(),
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
    // Response-first: if the server returned a response, prioritize its status
    // code and payload. Cancellations carry no useful server information, so
    // they are handled before this check.
    if (error.type == DioExceptionType.cancel) {
      return (
        _buildModel(HttpMessages.requestCancelled),
        ErrorType.cancelled,
        error.response?.statusCode,
      );
    }

    if (error.response != null) {
      return _fromResponse(error.response);
    }

    return switch (error.type) {
      DioExceptionType.connectionError => _fromTransport(
        error.error,
        uri: error.requestOptions.uri,
        dioMessage: error.message,
      ),
      DioExceptionType.connectionTimeout => (
        _buildModel(HttpMessages.connectionTimeout),
        ErrorType.connectionTimeout,
        null,
      ),
      DioExceptionType.receiveTimeout => (
        _buildModel(HttpMessages.receiveTimeout),
        ErrorType.receiveTimeout,
        null,
      ),
      DioExceptionType.sendTimeout => (
        _buildModel(HttpMessages.sendTimeout),
        ErrorType.sendTimeout,
        null,
      ),
      DioExceptionType.cancel => (
        _buildModel(HttpMessages.requestCancelled),
        ErrorType.cancelled,
        null,
      ),
      DioExceptionType.badCertificate => _certificateFailure(),
      DioExceptionType.badResponse => _fromResponse(error.response),
      DioExceptionType.unknown => _fromUnknown(
        error.error,
        error.response,
        uri: error.requestOptions.uri,
        dioMessage: error.message,
      ),
      DioExceptionType.transformTimeout => (
        _buildModel(HttpMessages.gatewayTimeout),
        ErrorType.timeout,
        null,
      ),
    };
  }

  /// Classifies a transport-level failure using the live platform probes.
  static (ApiErrorModel, ErrorType, int?) _fromTransport(
    Object? cause, {
    Uri? uri,
    String? dioMessage,
  }) => classifyTransport(
    cause,
    uri: uri,
    dioMessage: dioMessage,
    deviceOnline: isDeviceOnline,
    pageSecure: isBrowserPageSecure,
    pageOrigin: browserPageOrigin,
  );

  /// Pure, testable transport classifier.
  ///
  /// The same exception type covers several very different causes, so the
  /// order below is deliberate: prove the device is offline first, then detect
  /// browser-specific blocks (which never reach the network), then the
  /// cross-origin ambiguity, and only then inspect the socket error.
  ///
  /// A failed request does **not** imply the device is offline: browsers report
  /// blocked CORS preflights, DNS failures, refused connections and unreachable
  /// hosts identically. "No internet" is reported only when the platform can
  /// prove it.
  @visibleForTesting
  static (ApiErrorModel, ErrorType, int?) classifyTransport(
    Object? cause, {
    required bool deviceOnline,
    required bool pageSecure,
    required String? pageOrigin,
    Uri? uri,
    String? dioMessage,
  }) {
    if (!deviceOnline) {
      return (_noInternetModel(), ErrorType.offline, null);
    }

    // An HTTPS page calling a plain HTTP endpoint is rejected by the browser
    // before any packet is sent, so this is a deterministic diagnosis. Loopback
    // hosts are exempt: browsers treat `http://localhost` as a trustworthy
    // origin and do not block it as mixed content.
    if (pageSecure && uri != null && uri.scheme == 'http' && !_isLoopback(uri)) {
      return (
        _buildModel(HttpMessages.mixedContentBlocked),
        ErrorType.mixedContentBlocked,
        null,
      );
    }

    // On web, a cross-origin XHR that fails gives the browser no detail beyond
    // "onError". Dio's web adapter enriches the message with CORS guidance when
    // the request would have required a preflight. Even then the request may
    // simply have failed to connect, so the message stays honest about both.
    if (_looksLikeCors(dioMessage, uri, pageOrigin)) {
      return (
        _buildModel(HttpMessages.corsBlocked),
        ErrorType.corsBlocked,
        null,
      );
    }

    if (cause is SocketException) return _fromSocketException(cause);

    if (cause is HandshakeException || cause is TlsException) {
      return _certificateFailure();
    }

    // There is a network adapter and nothing more specific to blame: the
    // server is down, unreachable, or dropped the connection.
    return (
      _buildModel(HttpMessages.serverUnreachable),
      ErrorType.serverUnreachable,
      null,
    );
  }

  /// Native-only: maps a [SocketException] to a precise transport cause using
  /// the OS error code (POSIX `errno` or Windows `WSA*`) and message.
  static (ApiErrorModel, ErrorType, int?) _fromSocketException(
    SocketException exception,
  ) {
    final osError = exception.osError;
    final code = osError?.errorCode;
    final text = '${exception.message} ${osError?.message ?? ''}'.toLowerCase();

    // DNS: EAI_NONAME (-2), WSAHOST_NOT_FOUND (11001), NXDOMAIN messages.
    if (code == -2 ||
        code == -5 ||
        code == 11001 ||
        text.contains('failed host lookup') ||
        text.contains('name or service not known') ||
        text.contains('nodename nor servname') ||
        text.contains('temporary failure in name resolution') ||
        text.contains('no address associated with hostname')) {
      return (
        _buildModel(HttpMessages.dnsFailure),
        ErrorType.dnsFailure,
        null,
      );
    }

    // ECONNREFUSED: Linux 111, macOS/BSD 61, Windows WSAECONNREFUSED 10061.
    if (code == 111 || code == 61 || code == 10061) {
      return (
        _buildModel(HttpMessages.connectionRefused),
        ErrorType.connectionRefused,
        null,
      );
    }

    // EHOSTUNREACH / ENETUNREACH / ETIMEDOUT equivalents.
    if (code == 113 ||
        code == 51 ||
        code == 10051 ||
        code == 101 ||
        code == 65 ||
        code == 110 ||
        code == 60 ||
        code == 10060) {
      return (
        _buildModel(HttpMessages.serverUnreachable),
        ErrorType.serverUnreachable,
        null,
      );
    }

    if (text.contains('timed out') || text.contains('timeout')) {
      return (
        _buildModel(HttpMessages.connectionTimeout),
        ErrorType.connectionTimeout,
        null,
      );
    }

    if (text.contains('connection refused')) {
      return (
        _buildModel(HttpMessages.connectionRefused),
        ErrorType.connectionRefused,
        null,
      );
    }

    if (text.contains('unreachable') || text.contains('network is down')) {
      return (
        _buildModel(HttpMessages.serverUnreachable),
        ErrorType.serverUnreachable,
        null,
      );
    }

    return (_connectionFailedModel(), ErrorType.network, null);
  }

  /// True when a failed web request was cross-origin *and* the adapter reported
  /// the CORS preflight guidance it only adds when the request was not a
  /// "simple request". Both conditions must hold to avoid blaming CORS for
  /// ordinary same-origin failures.
  ///
  /// This is deliberately a *hedge*, not a verdict: a server that is down or
  /// unreachable produces the exact same browser error, so the caller's message
  /// must mention both possibilities.
  static bool _looksLikeCors(
    String? message,
    Uri? uri,
    String? pageOrigin,
  ) {
    if (message == null || uri == null) return false;

    final lower = message.toLowerCase();
    final mentionsCors =
        lower.contains('cors') || lower.contains('preflight');
    if (!mentionsCors) return false;

    return _isCrossOrigin(uri, pageOrigin);
  }

  static bool _isCrossOrigin(Uri uri, String? pageOrigin) {
    if (pageOrigin == null || uri.host.isEmpty) return false;
    return _originOf(uri) != pageOrigin;
  }

  /// Browsers treat loopback hosts as trustworthy, so they are exempt from the
  /// mixed-content rule even on an HTTPS page.
  static bool _isLoopback(Uri uri) {
    final host = uri.host.toLowerCase();
    return host == 'localhost' ||
        host.endsWith('.localhost') ||
        host == '127.0.0.1' ||
        host == '::1' ||
        host == '0.0.0.0';
  }

  static String _originOf(Uri uri) {
    final scheme = uri.scheme.isEmpty ? 'http' : uri.scheme;
    final isDefaultPort =
        (scheme == 'http' && uri.port == 80) ||
        (scheme == 'https' && uri.port == 443);
    final port = uri.hasPort && !isDefaultPort ? ':${uri.port}' : '';
    return '$scheme://${uri.host}$port';
  }

  static (ApiErrorModel, ErrorType, int?) _fromResponse(
    Response<dynamic>? response,
  ) {
    final statusCode = response?.statusCode;
    final errorType = _errorTypeFromStatus(statusCode);
    final fallbackMessage = _httpStatusMessage(statusCode);
    final data = response?.data;

    // 1. Try to parse a structured JSON error body.
    if (data is Map) {
      try {
        final map = Map<String, dynamic>.from(data);
        final model = ApiErrorModel.fromJson(map);

        final message = model.message.trim();
        final isPlaceholder =
            message.isEmpty ||
            message == _defaultModelMessage ||
            message == HttpMessages.unknownError;

        // Keep the backend's specific message (e.g. "Invalid credentials")
        // and its field errors. Only replace a placeholder with the status.
        if (!isPlaceholder) {
          return (model, errorType, statusCode);
        }

        return (
          ApiErrorModel(
            success: false,
            message: fallbackMessage,
            errors: model.errors,
          ),
          errorType,
          statusCode,
        );
      } catch (_) {
        // Not the expected shape — fall through to the status message.
      }
    }

    // 2. Plain-text body from a gateway/proxy (never surface raw HTML).
    if (data is String) {
      final text = data.trim();
      if (text.isNotEmpty && text.length <= 300 && !text.startsWith('<')) {
        return (_buildModel(text), errorType, statusCode);
      }
    }

    // 3. Empty body or unparseable payload.
    return (_buildModel(fallbackMessage), errorType, statusCode);
  }

  static (ApiErrorModel, ErrorType, int?) _fromUnknown(
    Object? cause,
    Response<dynamic>? response, {
    Uri? uri,
    String? dioMessage,
  }) {
    // 1. Response check first: retain status code and payload if available
    if (response != null) {
      return _fromResponse(response);
    }

    // 2. Classify the cause when no response is available
    if (cause is SocketException) {
      return _fromTransport(cause, uri: uri, dioMessage: dioMessage);
    }

    // A web adapter failure sometimes arrives as `unknown` when the request
    // never reached Dio's own connection-error branch, so the browser-side
    // signals still have to be considered here. Native requests have no page
    // origin and keep the honest `unknown` classification.
    if (browserPageOrigin != null && uri != null && dioMessage != null) {
      return _fromTransport(null, uri: uri, dioMessage: dioMessage);
    }

    if (cause is HandshakeException || cause is TlsException) {
      return _certificateFailure();
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

  static (ApiErrorModel, ErrorType, int?) _certificateFailure() => (
    _buildModel(HttpMessages.badCertificate),
    ErrorType.certificate,
    null,
  );

  static ApiErrorModel _buildModel(String message) =>
      ApiErrorModel(success: false, message: message, errors: []);

  static ApiErrorModel _noInternetModel() =>
      _buildModel(HttpMessages.noInternet);

  static ApiErrorModel _connectionFailedModel() =>
      _buildModel(HttpMessages.connectionFailed);

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
