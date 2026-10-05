import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../models/admin_models.dart';

/// Admin dashboard API layer: analytics summary + velocity.
class DashboardApi {
  DashboardApi(this._dio);

  final Dio _dio;

  static const String summaryPath = '/api/v1/analytics/summary';
  static const String velocityPath = '/api/v1/analytics/product-velocity';

  Future<ExecutiveSummary> summary() => ApiExecutor.call(
    () => _dio.get<dynamic>(summaryPath),
    (json) => ExecutiveSummary.fromJson(json as Map<String, dynamic>),
  );

  Future<List<VelocityRow>> velocity({required String warehouseId}) =>
      ApiExecutor.call(
        () => _dio.get<dynamic>(
          velocityPath,
          queryParameters: <String, dynamic>{'warehouseId': warehouseId},
        ),
        (json) => (json as List)
            .map((e) => VelocityRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
