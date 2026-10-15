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
final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApiService api,
    required UserSessionServiceBase session,
    required Future<void> Function(bool isAuthenticated) onAuthChanged,
  }) : _api = api,
       _session = session,
       _onAuthChanged = onAuthChanged;

  final AuthApiService _api;
  final UserSessionServiceBase _session;
  final Future<void> Function(bool isAuthenticated) _onAuthChanged;

  @override
  Future<Result<User, Failure>> login({
    required String identifier,
    required String password,
  }) async {
    final result = await ApiExecutor.execute(
      action: () => _api.login(
        LoginRequest(identifier: identifier, password: password).toJson(),
      ),
    );
    if (result is FailureResult<Map<String, dynamic>, Failure>) {
      return Result.failure(error: result.error);
    }

    final json = (result as Success<Map<String, dynamic>, Failure>).data;
    final model = UserModel.fromJson(json);
    final token = model.token;
    if (token == null || token.isEmpty) {
      return const Result.failure(
        error: BadResponseParsingFailure('Login response carried no token.'),
      );
    }

    await _session.saveUserSession(token: token, rememberMe: true);
    await _onAuthChanged(true);
    return Result.success(data: model.toEntity());
  }

  @override
  Future<Result<void, Failure>> logout() async {
    final result = await ApiExecutor.execute(action: _api.logout);
    // Local session clears even if the backend call fails — the device
    // must never stay signed in on a logout intent.
    await _session.clearUserSession();
    await _onAuthChanged(false);
    if (result is FailureResult<void, Failure>) {
      return Result.failure(error: result.error);
    }
    return const Result.success(data: null);
  }

  @override
  Future<bool> isAuthenticated() => _session.isAuthenticated();
}
