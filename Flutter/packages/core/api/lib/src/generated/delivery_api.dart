import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_routes.dart';
import 'models/delivery_dto.dart';

part 'delivery_api.g.dart';

/// Fleet delivery: driver trips/stops/POD + dispatcher dispatch.
@RestApi()
abstract class DeliveryApi {
  factory DeliveryApi(Dio dio) = _DeliveryApi;

  @GET(DeliveryRoutes.myTrips)
  Future<ApiResponse<List<TripDto>>> myTrips();

  @GET(DeliveryRoutes.tripStops)
  Future<ApiResponse<List<StopDto>>> tripStops(
    @Path('tripId') String tripId,
  );

  @POST(DeliveryRoutes.pushLocation)
  Future<ApiResponse<EmptyDto>> pushLocation(
    @Path('tripId') String tripId,
    @Body() Map<String, dynamic> body,
  );

  @POST(DeliveryRoutes.pinStop)
  Future<ApiResponse<EmptyDto>> pinStop(
    @Path('stopId') String stopId,
    @Body() Map<String, dynamic> body,
  );

  @POST(DeliveryRoutes.stopStatus)
  Future<ApiResponse<EmptyDto>> updateStopStatus(
    @Path('stopId') String stopId,
    @Body() Map<String, dynamic> body,
  );

  @POST(DeliveryRoutes.confirmDeliver)
  Future<ApiResponse<EmptyDto>> confirmDelivery(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );

  @POST(DeliveryRoutes.reportFailed)
  Future<ApiResponse<EmptyDto>> reportFailed(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );

  @POST(DeliveryRoutes.trips)
  Future<ApiResponse<TripDto>> dispatchTrip(
    @Body() Map<String, dynamic> trip,
  );

  @POST(DeliveryRoutes.optimizeTrip)
  Future<ApiResponse<List<StopDto>>> optimizeTrip(
    @Path('tripId') String tripId,
  );

  @POST(DeliveryRoutes.tripDispatch)
  Future<ApiResponse<EmptyDto>> dispatch(
    @Path('tripId') String tripId,
  );

  @POST(DeliveryRoutes.tripComplete)
  Future<ApiResponse<EmptyDto>> completeTrip(
    @Path('tripId') String tripId,
  );

  @POST(DeliveryRoutes.tripCancel)
  Future<ApiResponse<EmptyDto>> cancelTrip(
    @Path('tripId') String tripId,
  );

  @POST(DeliveryRoutes.rateDriver)
  Future<ApiResponse<DriverRatingDto>> rateDriver(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );
}
