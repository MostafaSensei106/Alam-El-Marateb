import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../models/cart_models.dart';

/// Customer cart + checkout API layer.
class CartApi {
  CartApi(this._dio);

  final Dio _dio;

  static const String cartItemsPath = '/api/v1/shop/cart/items';
  static const String cartPath = '/api/v1/shop/cart';
  static const String previewPath = '/api/v1/shop/checkout/price-preview';
  static const String estimatePath =
      '/api/v1/shop/checkout/estimate-shipping';
  static const String placeOrderPath = '/api/v1/shop/checkout/place-order';
  static const String myOrdersPath = '/api/v1/shop/orders';

  static String cartItemPath(String itemId) => '$cartItemsPath/$itemId';
  static String trackPath(String trackingNumber) =>
      '/api/v1/shop/orders/track/$trackingNumber';

  Future<CartView> cart({String? guestKey}) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      cartPath,
      queryParameters: <String, dynamic>{
        'guestKey': ?guestKey,
      },
    ),
    (json) => CartView.fromJson(json as Map<String, dynamic>),
  );

  Future<CartView> addItem({
    String? guestKey,
    required String variantId,
    required int qty,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      cartItemsPath,
      queryParameters: <String, dynamic>{
        'guestKey': ?guestKey,
      },
      data: <String, dynamic>{'variantId': variantId, 'qty': qty},
    ),
    (json) => CartView.fromJson(json as Map<String, dynamic>),
  );

  Future<PricePreview> preview(List<PreviewLine> lines) => ApiExecutor.call(
    () => _dio.post<dynamic>(previewPath, data: <String, dynamic>{
      'lines': lines
          .map(
            (l) => <String, dynamic>{
              'variantId': l.variantId,
              'qty': l.qty,
            },
          )
          .toList(),
    }),
    (json) => PricePreview.fromJson(json as Map<String, dynamic>),
  );

  Future<PlacedShopOrder> placeOrder({
    String? branchId,
    String? guestPhone,
    String? guestKey,
    required List<PreviewLine> items,
    required String paymentMethod,
    int? redeemPoints,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      placeOrderPath,
      queryParameters: <String, dynamic>{
        'guestKey': ?guestKey,
      },
      data: <String, dynamic>{
        'branchId': ?branchId,
        'guestPhone': ?guestPhone,
        'items': items
            .map(
              (l) => <String, dynamic>{
                'variantId': l.variantId,
                'qty': l.qty,
              },
            )
            .toList(),
        'paymentMethod': paymentMethod,
        'redeemPoints': ?redeemPoints,
      },
    ),
    (json) => PlacedShopOrder.fromJson(json as Map<String, dynamic>),
  );

  Future<List<ShopOrder>> myOrders() => ApiExecutor.call(
    () => _dio.get<dynamic>(myOrdersPath),
    (json) => (json as List)
        .map((e) => ShopOrder.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<TrackingInfo> track(String trackingNumber) => ApiExecutor.call(
    () => _dio.get<dynamic>(trackPath(trackingNumber)),
    (json) => TrackingInfo.fromJson(json as Map<String, dynamic>),
  );
}
