import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../../../shared/enums.dart';
import '../models/pricing_models.dart';

/// Admin pricing API layer: sheets, channel prices, meter prices, brackets.
class PricingApi {
  PricingApi(this._dio);

  final Dio _dio;

  static const String sheetsPath = '/api/v1/catalog/price-sheets';
  static const String sellingPricesPath = '/api/v1/catalog/selling-prices';

  static String sheetPath(String id) => '$sheetsPath/$id';
  static String applyPath(String id) => '$sheetsPath/$id/apply';

  Future<List<PriceSheet>> sheets({required String supplierId}) =>
      ApiExecutor.call(
        () => _dio.get<dynamic>(
          sheetsPath,
          queryParameters: <String, dynamic>{'supplierId': supplierId},
        ),
        (json) => (json as List)
            .map((e) => PriceSheet.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Future<PriceSheet> sheet(String id) => ApiExecutor.call(
    () => _dio.get<dynamic>(sheetPath(id)),
    (json) => PriceSheet.fromJson(json as Map<String, dynamic>),
  );

  Future<PriceSheet> createSheet({
    required String supplierId,
    required String sheetNo,
    required String validFrom,
    String? validUntil,
    required List<SheetLineInput> lines,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(sheetsPath, data: <String, dynamic>{
      'supplierId': supplierId,
      'sheetNo': sheetNo,
      'validFrom': validFrom,
      'validUntil': ?validUntil,
      'lines': lines
          .map(
            (l) => <String, dynamic>{
              'variantId': l.variantId,
              'listCost': l.listCost,
              'suggestedSelling': l.suggestedSelling,
            },
          )
          .toList(),
    }),
    (json) => PriceSheet.fromJson(json as Map<String, dynamic>),
  );

  Future<int> applySheet({
    required String sheetId,
    List<PriceChannel> channels = const <PriceChannel>[
      PriceChannel.staff,
      PriceChannel.platform,
      PriceChannel.dealer,
    ],
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(applyPath(sheetId), data: <String, dynamic>{
      'channels': channels.map((c) => c.value).toList(),
    }),
    (json) => (json as Map<String, dynamic>)['rows'] as int? ?? 0,
  );

  Future<void> setPrice({
    required String variantId,
    required PriceChannel channel,
    required double price,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(sellingPricesPath, data: <String, dynamic>{
      'variantId': variantId,
      'channel': channel.value,
      'price': price,
    }),
    (_) {},
  );

  Future<List<PriceHistoryPoint>> history({
    required String variantId,
    PriceChannel? channel,
  }) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      sellingPricesPath,
      queryParameters: <String, dynamic>{
        'variantId': variantId,
        if (channel != null) 'channel': channel.value,
      },
    ),
    (json) => (json as List)
        .map((e) => PriceHistoryPoint.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
