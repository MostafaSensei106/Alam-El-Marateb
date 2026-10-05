import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../models/warranty_models.dart';

/// Staff warranty API layer: lookup + registration + claims handling.
class WarrantyApi {
  WarrantyApi(this._dio);

  final Dio _dio;

  static const String warrantiesPath = '/api/v1/crm/warranties';
  static const String registerPath = '/api/v1/crm/warranties/register';

  static String warrantyPath(String serial) => '$warrantiesPath/$serial';
  static String claimsPath(String serial) => '$warrantiesPath/$serial/claims';

  Future<StaffWarranty> lookup(String serial) => ApiExecutor.call(
    () => _dio.get<dynamic>(warrantyPath(serial)),
    (json) => StaffWarranty.fromJson(json as Map<String, dynamic>),
  );

  Future<void> register({required String invoiceId}) => ApiExecutor.call(
    () => _dio.post<dynamic>(registerPath, data: <String, dynamic>{
      'invoiceId': invoiceId,
    }),
    (_) {},
  );

  Future<List<WarrantyClaim>> claims(String serial) => ApiExecutor.call(
    () => _dio.get<dynamic>(claimsPath(serial)),
    (json) => (json as List)
        .map((e) => WarrantyClaim.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
