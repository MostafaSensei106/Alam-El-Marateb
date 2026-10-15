import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

/// Auth endpoints owned by this module (NOT core — see the Phase-1 decision:
/// each module owns its retrofit interface, core only shares [ApiExecutor]).
///
/// ASSUMED contract (verify against the backend, then freeze):
/// - `POST {baseUrl}/auth/login` with `{identifier, password}`
/// - `POST {baseUrl}/auth/logout` (requires token)
/// - responses: user object or `{data: {...}}` with `token`/`access_token`.
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST('/auth/login')
  @Extra({SecurityConfigs.requireToken: false})
  Future<dynamic> login(@Body() Map<String, dynamic> body);

  @POST('/auth/logout')
  Future<void> logout();
}
