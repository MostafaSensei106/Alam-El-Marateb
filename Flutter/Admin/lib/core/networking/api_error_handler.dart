import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../error/failures.dart';
import 'api_error_model/api_error_model.dart';
import 'error_type.dart';
import 'platform_connectivity.dart';

/// Pure failure mapper that classifies raw exceptions and HTTP responses
/// into structured domain [ApiFailure] instances.
///
/// Decouples network/Dio exceptions from application business logic.
///
/// The [ApiErrorModel.message] is always the raw error text as it occurred
/// (Dio's message, the exception's `toString()`, the backend message or the
/// HTTP status line). Failures are classified for internal decisions, but the
/// displayed text is never translated or rewritten.
abstract final class ApiFailureMapper {
  /// Placeholder produced by [ApiErrorModel.fromJson] when the payload has no
  /// `message`, so it must not be shown to the user.
  static const _defaultModelMessage = 'An unexpected error occurred.';

  /// Used only when no raw text exists at all.
  static const _noDetailsMessage = 'Unknown error';

  /// Maps any [error] into an [ApiFailure].
  static ApiFailure map(Object error, {StackTrace? stackTrace}) {
    final (model, errorType, statusCode) = switch (error) {
      DioException() => _fromDio(error),
      SocketException() => _fromTransport(error),
      HandshakeException() => _certificateFailure(error.toString()),
      TlsException() => _certificateFailure(error.toString()),
      FormatException() => (
        _buildModel(error.toString()),
        ErrorType.serialization,
        null,
      ),
      TypeError() => (
        _buildModel(error.toString()),
        ErrorType.serialization,
        null,
      ),
      _ => (_buildModel(error.toString()), ErrorType.unknown, null),
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
    // The raw Dio text is the primary display source; only fall back to the
    // underlying error when Dio itself has no message.
    final rawMessage = _rawDioMessage(error);

    // Response-first: if the server returned a response, prioritize its status
    // code and payload. Cancellations carry no useful server information, so
    // they are handled before this check.
    if (error.type == DioExceptionType.cancel) {
      return (
        _buildModel(rawMessage),
        ErrorType.cancelled,
        error.response?.statusCode,
      );
    }

    if (error.response != null) {
      return _fromResponse(error.response, fallbackMessage: rawMessage);
    }

    return switch (error.type) {
      DioExceptionType.connectionError => _fromTransport(
        error.error,
        uri: error.requestOptions.uri,
        dioMessage: rawMessage,
      ),
      DioExceptionType.connectionTimeout => (
        _buildModel(rawMessage),
        ErrorType.connectionTimeout,
        null,
      ),
      DioExceptionType.receiveTimeout => (
        _buildModel(rawMessage),
        ErrorType.receiveTimeout,
        null,
      ),
      DioExceptionType.sendTimeout => (
        _buildModel(rawMessage),
        ErrorType.sendTimeout,
        null,
      ),
      DioExceptionType.cancel => (
        _buildModel(rawMessage),
        ErrorType.cancelled,
        null,
      ),
      DioExceptionType.badCertificate => _certificateFailure(rawMessage),
      DioExceptionType.badResponse => _fromResponse(
        error.response,
        fallbackMessage: rawMessage,
      ),
      DioExceptionType.unknown => _fromUnknown(
        error.error,
        error.response,
        uri: error.requestOptions.uri,
        rawMessage: rawMessage,
      ),
      DioExceptionType.transformTimeout => (
        _buildModel(rawMessage),
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
  /// hosts identically. The `offline` classification is reported only when the
  /// platform can prove it; the displayed message stays the raw one either way.
  @visibleForTesting
  static (ApiErrorModel, ErrorType, int?) classifyTransport(
    Object? cause, {
    required bool deviceOnline,
    required bool pageSecure,
    required String? pageOrigin,
    Uri? uri,
    String? dioMessage,
  }) {
    final message = _rawMessage(dioMessage, cause);

    if (!deviceOnline) {
      return (_buildModel(message), ErrorType.offline, null);
    }

    // An HTTPS page calling a plain HTTP endpoint is rejected by the browser
    // before any packet is sent, so this is a deterministic diagnosis. Loopback
    // hosts are exempt: browsers treat `http://localhost` as a trustworthy
    // origin and do not block it as mixed content.
    if (pageSecure && uri != null && uri.scheme == 'http' && !_isLoopback(uri)) {
      return (_buildModel(message), ErrorType.mixedContentBlocked, null);
    }

    // On web, a cross-origin XHR that fails gives the browser no detail beyond
    // "onError". Dio's web adapter enriches the message with CORS guidance when
    // the request would have required a preflight. Even then the request may
    // simply have failed to connect, so classification stays a hedge.
    if (_looksLikeCors(dioMessage, uri, pageOrigin)) {
      return (_buildModel(message), ErrorType.corsBlocked, null);
    }

    if (cause is SocketException) return _fromSocketException(cause, message);

    if (cause is HandshakeException || cause is TlsException) {
      return _certificateFailure(message);
    }

    // There is a network adapter and nothing more specific to blame: the
    // server is down, unreachable, or dropped the connection.
    return (_buildModel(message), ErrorType.serverUnreachable, null);
  }

  /// Native-only: classifies a [SocketException] using the OS error code
  /// (POSIX `errno` or Windows `WSA*`) and message.
  static (ApiErrorModel, ErrorType, int?) _fromSocketException(
    SocketException exception,
    String message,
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
      return (_buildModel(message), ErrorType.dnsFailure, null);
    }

    // ECONNREFUSED: Linux 111, macOS/BSD 61, Windows WSAECONNREFUSED 10061.
    if (code == 111 || code == 61 || code == 10061) {
      return (_buildModel(message), ErrorType.connectionRefused, null);
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
      return (_buildModel(message), ErrorType.serverUnreachable, null);
    }

    if (text.contains('timed out') || text.contains('timeout')) {
      return (_buildModel(message), ErrorType.connectionTimeout, null);
    }

    if (text.contains('connection refused')) {
      return (_buildModel(message), ErrorType.connectionRefused, null);
    }

    if (text.contains('unreachable') || text.contains('network is down')) {
      return (_buildModel(message), ErrorType.serverUnreachable, null);
    }

    return (_buildModel(message), ErrorType.network, null);
  }

  /// True when a failed web request was cross-origin *and* the adapter reported
  /// the CORS preflight guidance it only adds when the request was not a
  /// "simple request". Both conditions must hold to avoid blaming CORS for
  /// ordinary same-origin failures.
  static bool _looksLikeCors(
    String? message,
    Uri? uri,
    String? pageOrigin,
  ) {
    if (message == null || uri == null) return false;

    final lower = message.toLowerCase();
    final mentionsCors = lower.contains('cors') || lower.contains('preflight');
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
    Response<dynamic>? response, {
    required String fallbackMessage,
  }) {
    final statusCode = response?.statusCode;
    final errorType = _errorTypeFromStatus(statusCode);
    final fallback = _responseFallback(response, fallbackMessage);
    final data = response?.data;

    // 1. Try to parse a structured JSON error body.
    if (data is Map) {
      try {
        final map = Map<String, dynamic>.from(data);
        final model = ApiErrorModel.fromJson(map);

        final message = model.message.trim();
        final isPlaceholder =
            message.isEmpty || message == _defaultModelMessage;

        // Keep the backend's specific message (e.g. "Invalid credentials")
        // and its field errors. Only replace a placeholder with the raw status.
        if (!isPlaceholder) {
          return (model, errorType, statusCode);
        }

        return (
          ApiErrorModel(
            success: false,
            message: fallback,
            errors: model.errors,
          ),
          errorType,
          statusCode,
        );
      } catch (_) {
        // Not the expected shape — fall through to the status line.
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
    return (_buildModel(fallback), errorType, statusCode);
  }

  static (ApiErrorModel, ErrorType, int?) _fromUnknown(
    Object? cause,
    Response<dynamic>? response, {
    required String rawMessage,
    Uri? uri,
  }) {
    // 1. Response check first: retain status code and payload if available
    if (response != null) {
      return _fromResponse(response, fallbackMessage: rawMessage);
    }

    // 2. Classify the cause when no response is available
    if (cause is SocketException) {
      return _fromTransport(cause, uri: uri, dioMessage: rawMessage);
    }

    // A web adapter failure sometimes arrives as `unknown` when the request
    // never reached Dio's own connection-error branch, so the browser-side
    // signals still have to be considered here. Native requests have no page
    // origin and keep the honest `unknown` classification.
    if (browserPageOrigin != null && uri != null) {
      return _fromTransport(null, uri: uri, dioMessage: rawMessage);
    }

    if (cause is HandshakeException || cause is TlsException) {
      return _certificateFailure(rawMessage);
    }

    return (_buildModel(rawMessage), ErrorType.unknown, null);
  }

  // ── raw message extraction ─────────────────────────────────────────────────

  /// Prefers Dio's own message, then the underlying error's text, and finally
  /// Dio's own `toString()` — never an invented sentence.
  static String _rawDioMessage(DioException error) {
    final message = error.message;
    if (message != null && message.trim().isNotEmpty) return message;
    final cause = error.error;
    if (cause != null) return cause.toString();
    return error.toString();
  }

  static String _rawMessage(String? dioMessage, Object? cause) {
    if (dioMessage != null && dioMessage.trim().isNotEmpty) return dioMessage;
    if (cause != null) return cause.toString();
    return _noDetailsMessage;
  }

  /// The raw fallback for an HTTP response: the server's status line, then the
  /// status code, then the original transport text when no response exists.
  static String _responseFallback(
    Response<dynamic>? response,
    String fallbackMessage,
  ) {
    final statusMessage = response?.statusMessage;
    if (statusMessage != null && statusMessage.trim().isNotEmpty) {
      return statusMessage;
    }

    final statusCode = response?.statusCode;
    if (statusCode != null) return 'HTTP $statusCode';

    return fallbackMessage;
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

  static (ApiErrorModel, ErrorType, int?) _certificateFailure(String message) =>
      (_buildModel(message), ErrorType.certificate, null);

  static ApiErrorModel _buildModel(String message) =>
      ApiErrorModel(success: false, message: message, errors: []);
}

/// Facade maintaining backward compatibility with the existing codebase.
abstract final class APIErrorHandler {
  APIErrorHandler._();

  /// Converts any [error] into an [ApiFailure] by delegating to [ApiFailureMapper].
  static ApiFailure handle(Object error, {StackTrace? stackTrace}) =>
      ApiFailureMapper.map(error, stackTrace: stackTrace);
}
