import 'dart:async';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Provides the current auth token (`null` when signed out).
/// Implemented by the app (usually reads `UserSessionService.getToken()`)
/// so the network package never depends on session services directly.
typedef TokenProvider = Future<String?> Function();

/// Handles a 401 that passed the token gate (session expired server-side).
/// Implemented by the app — typically clears the session and shows a
/// session-expired dialog via its own router. Kept nullable so headless
/// consumers (tests, background isolates) can skip UI entirely.
typedef UnauthorizedHandler = Future<void> Function(DioException err);

final class DioTokenInterceptor extends Interceptor {
  DioTokenInterceptor({
    required this.getToken,
    this.onUnauthorized,
    this.loginPath,
  });

  final TokenProvider getToken;
  final UnauthorizedHandler? onUnauthorized;

  /// Request path substring that identifies the login endpoint.
  /// 401s from this path never trigger [onUnauthorized] (they ARE the
  /// auth failure, e.g. wrong credentials — not an expired session).
  final String? loginPath;

  static bool _isHandling401 = false;

  @visibleForTesting
  static void resetHandlingForTesting() {
    _isHandling401 = false;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isHandling401) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          message: 'Request blocked pre-flight. Session is expiring.',
        ),
      );
    }

    if (options.extra[SecurityConfigs.requireToken] == false) {
      return handler.next(options);
    }

    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiHeader.authorization] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestPath = err.requestOptions.path;
    final requiresToken =
        err.requestOptions.extra[SecurityConfigs.requireToken] != false;

    final isLoginCall =
        loginPath != null &&
        loginPath!.isNotEmpty &&
        requestPath.contains(loginPath!);

    // Check 401 ONLY if the endpoint actually required authentication
    // and is not the login call itself.
    if (err.response?.statusCode == 401 && requiresToken && !isLoginCall) {
      if (_isHandling401) {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            type: DioExceptionType.cancel,
            message: 'Session Expired. Aborting remaining requests silently.',
          ),
        );
      }

      _isHandling401 = true;

      try {
        await onUnauthorized?.call(err);
      } finally {
        _isHandling401 = false;
      }

      return handler.reject(err);
    }

    handler.next(err);
  }
}
