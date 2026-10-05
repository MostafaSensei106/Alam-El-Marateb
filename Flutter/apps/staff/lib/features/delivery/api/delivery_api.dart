import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../models/delivery_models.dart';

/// Driver delivery API layer: trips, stops, POD, GPS.
class DeliveryApi {
  DeliveryApi(this._dio);

  final Dio _dio;

  static const String myTripsPath = '/api/v1/delivery/my-trips';

  static String tripStopsPath(String tripId) =>
      '/api/v1/delivery/trips/$tripId/stops';
  static String confirmPath(String orderId) =>
      '/api/v1/delivery/orders/$orderId';
  static String failedPath(String orderId) =>
      '/api/v1/delivery/orders/$orderId/failed';
  static String locationPath(String tripId) =>
      '/api/v1/delivery/trips/$tripId/location';
  static String pinPath(String stopId) =>
      '/api/v1/delivery/stops/$stopId/pin';

  Future<List<DeliveryTrip>> myTrips() => ApiExecutor.call(
    () => _dio.get<dynamic>(myTripsPath),
    (json) => (json as List)
        .map((e) => DeliveryTrip.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<List<TripStop>> stops(String tripId) => ApiExecutor.call(
    () => _dio.get<dynamic>(tripStopsPath(tripId)),
    (json) => (json as List)
        .map((e) => TripStop.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<void> confirmDelivered({
    required String orderId,
    String? proof,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(confirmPath(orderId), data: <String, dynamic>{
      'proof': ?proof,
    }),
    (_) {},
  );

  Future<void> reportFailed({
    required String orderId,
    required String reason,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(failedPath(orderId), data: <String, dynamic>{
      'reason': reason,
    }),
    (_) {},
  );

  Future<void> pushLocation({
    required String tripId,
    required double lat,
    required double lng,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(locationPath(tripId), data: <String, dynamic>{
      'lat': lat,
      'lng': lng,
    }),
    (_) {},
  );
}
