import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_header.dart';
import '../constants/api_routes.dart';
import '../constants/security_configs.dart';
import '../extensions/extensions.dart';
import '../router/app_router.dart';
import '../services/session/user_session_service.dart';
import '../widgets/feedback/dialog/dialog_component.dart';

final class DioTokenInterceptor extends Interceptor {
  DioTokenInterceptor(this._sessionService);

  final BaseUserSessionService _sessionService;

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

    final token = await _sessionService.getToken();
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

    // Check 401 ONLY if the endpoint actually required authentication
    if (err.response?.statusCode == 401 &&
        requiresToken &&
        !requestPath.contains(ApiRoutes.authLoginPath)) {
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
        await _sessionService.clearUserSession();

        final context = AppRouter.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          final title = context.localeKeys.sessionExpired;
          final body = context.localeKeys.sessionExpiredDescription;

          await DialogComponent.showInfo(
            context: context,
            title: title,
            body: body,
          );
        }
      } finally {
        _isHandling401 = false;
      }

      return handler.reject(err);
    }

    handler.next(err);
  }
}
