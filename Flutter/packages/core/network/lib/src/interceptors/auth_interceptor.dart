import 'dart:async';

import 'package:dio/dio.dart';

/// Provides the current access token, or `null` when logged out.
typedef TokenProvider = Future<String?> Function();

/// Attempts a token refresh. Returns `true` when new tokens were stored
/// (caller should retry the failed request), `false` when the session
/// is dead (caller should log out — e.g. `token_version` was bumped).
typedef RefreshCallback = Future<bool> Function();

/// Called when the session is definitively expired (refresh failed or
/// no refresh configured). The app clears storage and routes to login.
typedef SessionExpiredCallback = Future<void> Function();

/// Extra key: set to `false` to skip bearer injection (public endpoints).
/// Mirrors Hadidi-Win `SecurityConfigs.requireToken`.
const requireTokenKey = 'requireToken';

/// Injects `Authorization: Bearer <token>` and handles 401.
///
/// 401 policy (backend uses `token_version`: password reset/change bumps
/// the version and instantly invalidates all tokens):
/// 1. Requests already marked `requireToken=false` or targeting auth
///    endpoints (`/auth/login`, `/auth/refresh`, `/auth/register`) pass
///    through untouched.
/// 2. Otherwise a single-flight refresh is attempted once; on success the
///    original request is retried with the new token.
/// 3. On refresh failure [onSessionExpired] fires once (guarded) and the
///    401 is forwarded.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required this.tokenProvider,
    this.shouldRefresh,
    this.onSessionExpired,
    this.isAuthEndpoint,
  }) : _dio = dio;

  final Dio _dio;
  final TokenProvider tokenProvider;
  final RefreshCallback? shouldRefresh;
  final SessionExpiredCallback? onSessionExpired;

  /// Returns `true` for paths that must never trigger a refresh
  /// (login / refresh / register themselves).
  final bool Function(String path)? isAuthEndpoint;

  static bool _isHandling401 = false;
  Future<bool>? _refreshFuture;

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
    if (options.extra[requireTokenKey] == false) {
      return handler.next(options);
    }
    final token = await tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        (isAuthEndpoint?.call(err.requestOptions.path) ?? false)) {
      return handler.next(err);
    }
    if (_isHandling401) {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          type: DioExceptionType.cancel,
          message: 'Session expired. Aborting remaining requests.',
        ),
      );
    }

    final refresh = shouldRefresh;
    if (refresh == null) {
      await _expireSession();
      return handler.next(err);
    }

    try {
      _refreshFuture ??= refresh();
      final refreshed = await _refreshFuture!;
      _refreshFuture = null;
      if (!refreshed) {
        await _expireSession();
        return handler.next(err);
      }
      // Retry original request with the fresh token.
      final token = await tokenProvider();
      final request = err.requestOptions;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      final response = await _dio.fetch<dynamic>(request);
      return handler.resolve(response);
    } catch (_) {
      _refreshFuture = null;
      await _expireSession();
      return handler.next(err);
    }
  }

  Future<void> _expireSession() async {
    if (_isHandling401) return;
    _isHandling401 = true;
    try {
      await onSessionExpired?.call();
    } finally {
      _isHandling401 = false;
    }
  }
}
