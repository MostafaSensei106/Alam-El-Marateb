import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_routes.dart';
import 'models/estimator_dto.dart';

part 'estimator_api.g.dart';

/// Estimator: public geometric quotes + gamified spin.
@RestApi()
abstract class EstimatorApi {
  factory EstimatorApi(Dio dio) = _EstimatorApi;

  @GET(EstimatorRoutes.catalog)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<List<EstimatorModelDto>>> catalog(
    @Query('categoryId') String? categoryId,
  );

  @POST(EstimatorRoutes.quote)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<EstimateBreakdownDto>> quote(
    @Body() Map<String, dynamic> spec,
  );

  @POST(EstimatorRoutes.spin)
  Future<ApiResponse<SpinResultDto>> spin();

  @GET(EstimatorRoutes.spinCampaigns)
  Future<ApiResponse<List<CampaignDto>>> spinCampaigns();

  @POST(EstimatorRoutes.spinCampaigns)
  Future<ApiResponse<CampaignDto>> createSpinCampaign(
    @Body() Map<String, dynamic> campaign,
  );

  @POST(EstimatorRoutes.spinToggle)
  Future<ApiResponse<CampaignDto>> toggleCampaign(
    @Path('id') String id,
  );

  @POST(EstimatorRoutes.spinPrize)
  Future<ApiResponse<PrizeDto>> addPrize(
    @Path('campaignId') String campaignId,
    @Body() Map<String, dynamic> prize,
  );

  @DELETE(EstimatorRoutes.spinPrizeById)
  Future<ApiResponse<EmptyDto>> deletePrize(
    @Path('id') String id,
  );
}
