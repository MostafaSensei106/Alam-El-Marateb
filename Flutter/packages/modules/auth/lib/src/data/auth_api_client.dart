import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import 'auth_api.dart';
import 'models/auth_user.dart';
import 'models/login_request_body.dart';
import 'models/refresh_request_body.dart';
import 'models/register_request_body.dart';
import 'models/token_pair.dart';

/// Hand-written retrofit-style client (same request/response semantics the
/// generator would emit). Temporary until retrofit_generator runs inside
/// the Dart workspace — then delete this file and restore the redirecting
/// factory in [AuthApi].
class AuthApiClient implements AuthApi {
  AuthApiClient(this._dio, {String? baseUrl}) : _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static const Map<String, Object> _noAuth = <String, Object>{
    'authRequired': false,
  };

  @override
  Future<ApiResponse<TokenPair>> login(LoginRequestBody body) =>
      _postToken('/api/v1/auth/login', body.toJson());

  @override
  Future<ApiResponse<TokenPair>> register(RegisterRequestBody body) =>
      _postToken('/api/v1/auth/register', body.toJson());

  @override
  Future<ApiResponse<TokenPair>> refresh(RefreshRequestBody body) =>
      _postToken('/api/v1/auth/refresh', body.toJson());

  @override
  Future<ApiResponse<AuthUser>> me() async {
    final res = await _dio.fetch<Map<String, dynamic>>(
      _options('GET', '/api/v1/auth/me', null, <String, dynamic>{}),
    );
    return ApiResponse<AuthUser>.fromJson(
      res.data!,
      (json) => AuthUser.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<TokenPair>> _postToken(
    String path,
    Map<String, dynamic> json,
  ) async {
    final res = await _dio.fetch<Map<String, dynamic>>(
      _options('POST', path, _noAuth, json),
    );
    return ApiResponse<TokenPair>.fromJson(
      res.data!,
      (json) => TokenPair.fromJson(json as Map<String, dynamic>),
    );
  }

  RequestOptions _options(
    String method,
    String path,
    Map<String, Object>? extra,
    Map<String, dynamic> data,
  ) =>
      Options(method: method, extra: extra)
          .compose(_dio.options, path, data: data)
          .copyWith(baseUrl: _combine(_dio.options.baseUrl, _baseUrl));

  String _combine(String dioBase, String? base) {
    if (base == null || base.trim().isEmpty) {
      return dioBase;
    }
    final url = Uri.parse(base);
    if (url.isAbsolute) {
      return url.toString();
    }
    return Uri.parse(dioBase).resolveUri(url).toString();
  }
}
