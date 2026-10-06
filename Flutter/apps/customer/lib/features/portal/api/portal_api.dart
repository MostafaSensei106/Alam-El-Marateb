import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../models/portal_models.dart';

/// Customer portal API layer: profile, addresses, favorites,
/// warranties + claims, loyalty.
class PortalApi {
  PortalApi(this._dio);

  final Dio _dio;

  static const String addressesPath = '/api/v1/portal/addresses';
  static const String favoritesPath = '/api/v1/portal/favorites';
  static const String warrantiesPath = '/api/v1/portal/warranties';
  static const String claimsPath = '/api/v1/portal/warranties/claims';
  static const String loyaltyPath = '/api/v1/portal/loyalty';
  static const String loyaltyLedgerPath = '/api/v1/portal/loyalty/ledger';
  static const String reviewsPath = '/api/v1/portal/reviews';

  Future<List<ShipAddress>> addresses() => ApiExecutor.call(
    () => _dio.get<dynamic>(addressesPath),
    (json) => (json as List)
        .map((e) => ShipAddress.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<ShipAddress> addAddress({
    required String phone,
    required String governorate,
    required String addressText,
    bool isDefault = false,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      addressesPath,
      data: <String, dynamic>{
        'phone': phone,
        'governorate': governorate,
        'addressText': addressText,
        'isDefault': isDefault,
      },
    ),
    (json) => ShipAddress.fromJson(json as Map<String, dynamic>),
  );

  Future<List<CustomerWarranty>> warranties() => ApiExecutor.call(
    () => _dio.get<dynamic>(warrantiesPath),
    (json) => (json as List)
        .map((e) => CustomerWarranty.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<void> fileClaim({
    required String warrantyId,
    required String description,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      claimsPath,
      data: <String, dynamic>{
        'warrantyId': warrantyId,
        'description': description,
      },
    ),
    (_) {},
  );

  Future<LoyaltyBalance> loyalty() => ApiExecutor.call(
    () => _dio.get<dynamic>(loyaltyPath),
    (json) => LoyaltyBalance.fromJson(json as Map<String, dynamic>),
  );

  Future<List<LoyaltyEntry>> loyaltyLedger() => ApiExecutor.call(
    () => _dio.get<dynamic>(loyaltyLedgerPath),
    (json) => (json as List)
        .map((e) => LoyaltyEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<void> submitReview({
    required String productId,
    required int rating,
    String? title,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      reviewsPath,
      data: <String, dynamic>{
        'productId': productId,
        'rating': rating,
        'title': ?title,
      },
    ),
    (_) {},
  );
}
