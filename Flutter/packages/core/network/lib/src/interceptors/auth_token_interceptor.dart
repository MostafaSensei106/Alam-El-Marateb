import 'package:dio/dio.dart';

import '../headers.dart';
import '../token_storage.dart';

/// Result of a refresh attempt: new access token, or null when the
/// session is dead (refresh expired/invalid → caller must log out).
typedef RefreshTokens = Future<String?> Function(String refreshToken);

/// Attaches `Authorization: Bearer` and refreshes once on TOKEN_EXPIRED.
///
/// Contract with the backend entry point:
/// - errors contain TOKEN_EXPIRED → try refresh once, then retry.
/// - TOKEN_INVALID / TOKEN_MISSING → session is dead, clear + propagate.
/// - CLIENT_REJECTED → client-gate issue, never retry here.
/// - extra['authRequired'] == false skips auth (login/refresh/register).
class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor({
    required this._storage,
    required this._onRefresh,
    required this._onSessionExpired,
    required this._retryClient,
  });

  final TokenStorage _storage;
  final RefreshTokens _onRefresh;
  final Future<void> Function() _onSessionExpired;
  final Dio Function() _retryClient;

  static const String authRequiredKey = 'authRequired';
  static const String retriedKey = 'authRetried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[authRequiredKey] == false) {
      handler.next(options);
      return;
    }
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiHeaders.authorization] =
          '${ApiHeaders.bearerPrefix}$token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra[authRequiredKey] == false) {
      // Not ours: non-401s and the auth endpoints themselves, which manage
      // their own failures (a bad login must not nuke the session flow).
      handler.next(err);
      return;
    }
    final errors = _errorCodes(err);
    if (errors.contains('CLIENT_REJECTED')) {
      // Client-gate issue, not a session issue — never retry here.
      handler.next(err);
      return;
    }
    final alreadyRetried = err.requestOptions.extra[retriedKey] == true;
    if (errors.contains('TOKEN_EXPIRED') && !alreadyRetried) {
      if (await _tryRefreshAndRetry(err, handler)) {
        return;
      }
    }
    await _storage.clear();
    await _onSessionExpired();
    handler.next(err);
  }

  /// Returns true when the retried request succeeded and was resolved.
  Future<bool> _tryRefreshAndRetry(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final refresh = await _storage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return false;
    }
    final renewed = await _onRefresh(refresh);
    if (renewed == null || renewed.isEmpty) {
      return false;
    }
    final retry = err.requestOptions..extra[retriedKey] = true;
    retry.headers[ApiHeaders.authorization] =
        '${ApiHeaders.bearerPrefix}$renewed';
    try {
      final response = await _retryClient().fetch<dynamic>(retry);
      handler.resolve(response);
      return true;
    } catch (_) {
      return false;
    }
  }

  static List<String> _errorCodes(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic> && data['errors'] is List) {
      return (data['errors'] as List).map((e) => e.toString()).toList();
    }
    return const <String>[];
  }
}
