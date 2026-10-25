import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../modules/accounting/data/models/balance_sheet_response_data.dart';
import '../../../modules/login/data/models/login_request_body.dart';
import '../../../modules/login/data/models/login_response_data.dart';
import '../../../modules/login/data/models/refresh_token_request_body.dart';
import '../../../modules/profile/data/models/auth_profile_response_data.dart';
import '../../constants/api_routes.dart';
import '../../constants/security_configs.dart';
import '../api_response_model/api_response_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiRoutes.apiBaseURL)
abstract class ApiService {
  /// Creates an instance of [ApiService] with the provided [Dio] client and optional [baseUrl].
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  /// Auth
  @POST(ApiRoutes.authLogin)
  @Extra({SecurityConfigs.requireToken: false})
  Future<ApiResponse<LoginResponseData>> login(@Body() LoginRequestBody body);

  @POST(ApiRoutes.authRefresh)
  @Extra({SecurityConfigs.requireToken: false})
  Future<ApiResponse<LoginResponseData>> refreshToken(
    @Body() RefreshTokenRequestBody body,
  );

  /// Profile
  @GET(ApiRoutes.authMe)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<AuthProfileResponseData>> authMe();

  /// Accounting
  @GET(ApiRoutes.accountingBalanceSheet)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<BalanceSheetResponseData>> getBalanceSheet(
    @Query('to') String to,
  );
}
