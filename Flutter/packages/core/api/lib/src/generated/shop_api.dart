import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_routes.dart';
import 'models/order_dto.dart';
import 'models/sales_dto.dart';

part 'shop_api.g.dart';

/// Customer storefront: cart, checkout, orders.
/// Guests pass `guestKey`; it merges into the customer cart on login.
@RestApi()
abstract class ShopApi {
  factory ShopApi(Dio dio) = _ShopApi;

  @GET(ShopRoutes.cart)
  Future<ApiResponse<CartDto>> getCart(
    @Query('guestKey') String? guestKey,
  );

  @POST(ShopRoutes.cartItems)
  Future<ApiResponse<CartDto>> addToCart(
    @Query('guestKey') String? guestKey,
    @Body() Map<String, dynamic> body,
  );

  @PUT(ShopRoutes.cartItems)
  Future<ApiResponse<CartDto>> setCartQty(
    @Query('guestKey') String? guestKey,
    @Body() Map<String, dynamic> body,
  );

  @POST(ShopRoutes.cartClear)
  Future<ApiResponse<CartDto>> clearCart(
    @Query('guestKey') String? guestKey,
  );

  @POST(ShopRoutes.cartMerge)
  Future<ApiResponse<CartDto>> mergeCart(
    @Body() Map<String, dynamic> body,
  );

  @POST(ShopRoutes.estimateShipping)
  Future<ApiResponse<ShippingEstimateDto>> estimateShipping(
    @Body() Map<String, dynamic> body,
  );

  @POST(ShopRoutes.pricePreview)
  Future<ApiResponse<PricePreviewDto>> pricePreview(
    @Body() Map<String, dynamic> body,
  );

  @POST(ShopRoutes.placeOrder)
  Future<ApiResponse<OrderDto>> placeOrder(
    @Body() Map<String, dynamic> order,
    @Header('Idempotency-Key') String idempotencyKey,
  );

  @GET(ShopRoutes.orders)
  Future<ApiResponse<List<OrderDto>>> myOrders();

  @GET(ShopRoutes.orderById)
  Future<ApiResponse<OrderDto>> myOrderById(
    @Path('orderId') String orderId,
  );

  @GET(ShopRoutes.trackOrder)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<OrderDto>> trackOrder(
    @Path('trackingNumber') String trackingNumber,
  );

  @GET(ShopRoutes.trackLocation)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<TrackingLocationDto>> trackLocation(
    @Path('trackingNumber') String trackingNumber,
  );
}
