import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/auth_user.dart';
import 'models/login_request_body.dart';
import 'models/register_request_body.dart';
import 'models/token_pair.dart';

part 'auth_api.g.dart';

/// Typed auth endpoints. Auth-free calls carry extra authRequired=false
/// so [AuthTokenInterceptor] skips the (missing) bearer token.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/api/v1/auth/login')
  @Extra(<String, dynamic>{'authRequired': false})
  Future<ApiResponse<TokenPair>> login(@Body() LoginRequestBody body);

  @POST('/api/v1/auth/register')
  @Extra(<String, dynamic>{'authRequired': false})
  Future<ApiResponse<TokenPair>> register(@Body() RegisterRequestBody body);

  @POST('/api/v1/auth/refresh')
  @Extra(<String, dynamic>{'authRequired': false})
  Future<ApiResponse<TokenPair>> refresh(
    @Body() Map<String, dynamic> body,
  );

  @GET('/api/v1/auth/me')
  Future<ApiResponse<AuthUser>> me();
}
