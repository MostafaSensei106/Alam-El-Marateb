import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'auth_api_client.dart';
import 'models/auth_user.dart';
import 'models/login_request_body.dart';
import 'models/refresh_request_body.dart';
import 'models/register_request_body.dart';
import 'models/token_pair.dart';

/// Typed auth endpoints. Auth-free calls carry extra authRequired=false
/// so [AuthTokenInterceptor] skips the (missing) bearer token.
///
/// NOTE: implemented by [AuthApiClient] until retrofit_generator runs
/// inside the workspace (tracked) — then this becomes a redirecting
/// factory to the generated _$AuthApi again.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) => AuthApiClient(dio);

  @POST('/api/v1/auth/login')
  @Extra(<String, Object>{'authRequired': false})
  Future<ApiResponse<TokenPair>> login(@Body() LoginRequestBody body);

  @POST('/api/v1/auth/register')
  @Extra(<String, Object>{'authRequired': false})
  Future<ApiResponse<TokenPair>> register(@Body() RegisterRequestBody body);

  @POST('/api/v1/auth/refresh')
  @Extra(<String, Object>{'authRequired': false})
  Future<ApiResponse<TokenPair>> refresh(
    @Body() RefreshRequestBody body,
  );

  @GET('/api/v1/auth/me')
  Future<ApiResponse<AuthUser>> me();
}
