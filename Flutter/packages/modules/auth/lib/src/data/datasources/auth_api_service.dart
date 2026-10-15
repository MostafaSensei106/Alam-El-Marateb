import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

/// Auth endpoints owned by this module (NOT core — see the Phase-1 decision:
/// each module owns its retrofit interface, core only shares [ApiExecutor]).
///
/// Mirrors the Kotlin backend (`IdentityControllers`, base `/api/v1/auth`):
/// - `POST /auth/login {phone, password}` → `{data: {accessToken, refreshToken, userId}}`
/// - `GET /auth/me` → `{data: {id, fullName, phoneNumber, email, branchId, roles, isActive}}`
/// - `POST /auth/refresh {refreshToken}` → fresh `TokenPair`
///
/// Envelope responses return `dynamic` (retrofit codegen can't parse the
/// generic `ApiResponse<T>`); parsing lives in the models. Error bodies are
/// still mapped by [APIErrorHandler] into typed [ApiFailure]s.
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST('/auth/login')
  @Extra({SecurityConfigs.requireToken: false})
  Future<dynamic> login(@Body() Map<String, dynamic> body);

  @GET('/auth/me')
  Future<dynamic> me();

  @POST('/auth/refresh')
  @Extra({SecurityConfigs.requireToken: false})
  Future<dynamic> refresh(@Body() Map<String, dynamic> body);
}
