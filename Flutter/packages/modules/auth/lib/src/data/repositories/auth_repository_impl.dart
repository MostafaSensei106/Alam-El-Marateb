import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_result/result.dart';
import 'package:alam_el_marateb_services/services.dart';

import 'package:auth/src/data/datasources/auth_api_service.dart';
import 'package:auth/src/data/models/login_request.dart';
import 'package:auth/src/data/models/user_model.dart';
import 'package:auth/src/domain/entities/user.dart';
import 'package:auth/src/domain/repositories/auth_repository.dart';

/// Single place where login side-effects happen: token persistence +
/// router auth-state broadcast. Apps and cubits never touch storage or
/// the auth notifier directly for auth flows.
///
/// Flow mirrors the backend (`IdentityControllers`):
/// login → persist `TokenPair` → `GET /me` → role gate → notify.
/// Logout is local-only (the backend exposes no logout endpoint —
/// server sessions die via token expiry / change-password).
final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._api,
    this._session, {
    this.allowedRoles = const [],
    Future<void> Function(bool isAuthenticated)? onAuthChanged,
  }) : _onAuthChanged = onAuthChanged ?? _noopAuthChanged;

  final AuthApiService _api;
  final UserSessionServiceBase _session;

  /// Empty = any authenticated role accepted. Otherwise the `/me` roles
  /// must intersect, or login fails WITHOUT persisting a session (so a
  /// customer account can never open the staff app).
  final List<String> allowedRoles;
  final Future<void> Function(bool isAuthenticated) _onAuthChanged;

  static Future<void> _noopAuthChanged(bool _) async {}

  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<Result<User, Failure>> login({
    required String phone,
    required String password,
  }) async {
    final pairResult = await ApiExecutor.execute(
      action: () async {
        final raw = await _api.login(
          LoginRequest(phone: phone, password: password).toJson(),
        );
        return _asMap(raw);
      },
    );
    if (pairResult is FailureResult<Map<String, dynamic>, Failure>) {
      return Result.failure(error: pairResult.error);
    }
    final pair = TokenPair.fromJson(
      (pairResult as Success<Map<String, dynamic>, Failure>).data,
    );
    if (!pair.isComplete) {
      return const Result.failure(
        error: BadResponseParsingFailure('Login response carried no token.'),
      );
    }

    await _session.saveUserSession(
      token: pair.accessToken,
      rememberMe: true,
      refreshToken: pair.refreshToken.isEmpty ? null : pair.refreshToken,
    );
    return _loadUser();
  }

  @override
  Future<Result<User, Failure>> getCurrentUser() => _loadUser();

  Future<Result<User, Failure>> _loadUser() async {
    final meResult = await ApiExecutor.execute(
      action: () async => _asMap(await _api.me()),
    );
    if (meResult is FailureResult<Map<String, dynamic>, Failure>) {
      final error = meResult.error;
      // Single transparent retry: expired access + valid refresh.
      if (error is ApiFailure && error.statusCode == 401) {
        final refreshed = await refreshSession();
        if (refreshed is Success<void, Failure>) return _loadUserOnce();
      }
      await _session.clearUserSession();
      await _onAuthChanged(false);
      return Result.failure(error: error);
    }
    return _acceptUser(
      (meResult as Success<Map<String, dynamic>, Failure>).data,
    );
  }

  /// One-shot `/me` without refresh recursion (used after a refresh).
  Future<Result<User, Failure>> _loadUserOnce() async {
    final meResult = await ApiExecutor.execute(
      action: () async => _asMap(await _api.me()),
    );
    if (meResult is FailureResult<Map<String, dynamic>, Failure>) {
      await _session.clearUserSession();
      await _onAuthChanged(false);
      return Result.failure(error: meResult.error);
    }
    return _acceptUser(
      (meResult as Success<Map<String, dynamic>, Failure>).data,
    );
  }

  Result<User, Failure> _acceptUser(Map<String, dynamic> json) {
    final model = UserModel.fromJson(json);
    if (allowedRoles.isNotEmpty && !model.roles.any(allowedRoles.contains)) {
      // Wrong app for this account: never persist, never notify.
      _session.clearUserSession();
      return const Result.failure(
        error: UnknownFailure('This account is not authorized for this app.'),
      );
    }
    _currentUser = model.toEntity();
    _onAuthChanged(true);
    return Result.success(data: _currentUser!);
  }

  @override
  Future<Result<void, Failure>> refreshSession() async {
    final refreshToken = await _session.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return const Result.failure(
        error: UnknownFailure('No refresh token stored.'),
      );
    }
    final result = await ApiExecutor.execute(
      action: () async {
        final raw = await _api.refresh({'refreshToken': refreshToken});
        return _asMap(raw);
      },
    );
    if (result is FailureResult<Map<String, dynamic>, Failure>) {
      return Result.failure(error: result.error);
    }
    final pair = TokenPair.fromJson(
      (result as Success<Map<String, dynamic>, Failure>).data,
    );
    if (!pair.isComplete) {
      return const Result.failure(
        error: BadResponseParsingFailure('Refresh response carried no token.'),
      );
    }
    await _session.saveUserSession(
      token: pair.accessToken,
      rememberMe: true,
      refreshToken: pair.refreshToken.isEmpty ? null : pair.refreshToken,
    );
    return const Result.success(data: null);
  }

  @override
  Future<Result<void, Failure>> logout() async {
    // Local-only: the backend has no logout endpoint.
    _currentUser = null;
    await _session.clearUserSession();
    await _onAuthChanged(false);
    return const Result.success(data: null);
  }

  @override
  Future<bool> isAuthenticated() => _session.isAuthenticated();

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    throw const BadResponseParsingFailure('Response was not a JSON object.');
  }
}
