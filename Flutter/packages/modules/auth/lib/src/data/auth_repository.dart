import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import 'auth_api.dart';
import 'models/login_request_body.dart';
import 'models/register_request_body.dart';
import 'models/token_pair.dart';

/// Auth data contract (implemented here, consumed by logic layer).
abstract class BaseAuthRepository {
  Future<TokenPair> login({required String phone, required String password});
  Future<TokenPair> register({
    required String fullName,
    required String phone,
    required String password,
    String? email,
  });
  Future<TokenPair> refresh(String refreshToken);
  Future<void> logout();
}

/// Retrofit-backed repository. Persists tokens on every successful
/// issue/rotation so interceptors pick them up immediately.
class AuthRepository implements BaseAuthRepository {
  AuthRepository({required AuthApi api, required TokenStorage storage})
      : _api = api,
        _storage = storage;

  final AuthApi _api;
  final TokenStorage _storage;

  @override
  Future<TokenPair> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _api.login(
        LoginRequestBody(phone: phone, password: password),
      );
      return _saveOrThrow(res);
    } on DioException catch (e, st) {
      throw ApiErrorHandler.handle(e, stackTrace: st);
    }
  }

  @override
  Future<TokenPair> register({
    required String fullName,
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      final res = await _api.register(
        RegisterRequestBody(
          fullName: fullName,
          phone: phone,
          password: password,
          email: email,
        ),
      );
      return _saveOrThrow(res);
    } on DioException catch (e, st) {
      throw ApiErrorHandler.handle(e, stackTrace: st);
    }
  }

  @override
  Future<TokenPair> refresh(String refreshToken) async {
    try {
      final res = await _api.refresh(<String, dynamic>{
        'refreshToken': refreshToken,
      });
      return _saveOrThrow(res);
    } on DioException catch (e, st) {
      throw ApiErrorHandler.handle(e, stackTrace: st);
    }
  }

  @override
  Future<void> logout() => _storage.clear();

  Future<TokenPair> _saveOrThrow(ApiResponse<TokenPair> res) async {
    final pair = res.data;
    if (!res.success || pair == null) {
      throw ApiErrorHandler.handle(
        DioException(
          requestOptions: RequestOptions(path: '/auth'),
          type: DioExceptionType.badResponse,
        ),
      );
    }
    await _storage.saveTokens(
      accessToken: pair.accessToken,
      refreshToken: pair.refreshToken,
    );
    return pair;
  }
}
