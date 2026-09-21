import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_routes.dart';
import 'models/auth_dto.dart';

part 'auth_api.g.dart';

/// Identity & authentication (`/api/v1/auth`) — Retrofit interface.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST(AuthRoutes.register)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<TokenPairDto>> register(
    @Body() Map<String, dynamic> body,
  );

  @POST(AuthRoutes.login)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<TokenPairDto>> login(@Body() Map<String, dynamic> body);

  @POST(AuthRoutes.refresh)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<TokenPairDto>> refresh(
    @Body() Map<String, dynamic> body,
  );

  @POST(AuthRoutes.forgotPassword)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<EmptyDto>> forgotPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(AuthRoutes.resetPassword)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<EmptyDto>> resetPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(AuthRoutes.changePassword)
  Future<ApiResponse<EmptyDto>> changePassword(
    @Body() Map<String, dynamic> body,
  );

  @GET(AuthRoutes.me)
  Future<ApiResponse<AuthUserDto>> me();
}
