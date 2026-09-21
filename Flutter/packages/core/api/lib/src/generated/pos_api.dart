import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_routes.dart';
import 'models/order_dto.dart';
import 'models/pos_dto.dart';

part 'pos_api.g.dart';

/// In-store POS: scan, draft/complete sale, shifts, reservations, orders.
@RestApi()
abstract class PosApi {
  factory PosApi(Dio dio) = _PosApi;

  @GET(SalesPosRoutes.scan)
  Future<ApiResponse<ScanResultDto>> scan(
    @Path('barcode') String barcode,
  );

  @POST(SalesPosRoutes.draftOrder)
  Future<ApiResponse<OrderDto>> createDraft(
    @Body() Map<String, dynamic> order,
  );

  @POST(SalesPosRoutes.completeDraft)
  Future<ApiResponse<OrderDto>> completeDraft(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  @POST(SalesPosRoutes.completeSale)
  Future<ApiResponse<OrderDto>> completeSale(
    @Body() Map<String, dynamic> sale,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  @POST(SalesPosRoutes.placeOrder)
  Future<ApiResponse<OrderDto>> placeOrder(
    @Body() Map<String, dynamic> order,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  @POST(SalesPosRoutes.customOrder)
  Future<ApiResponse<OrderDto>> customOrder(
    @Body() Map<String, dynamic> order,
  );

  @GET(SalesPosRoutes.receipt)
  Future<ApiResponse<ReceiptDto>> receipt(
    @Path('orderId') String orderId,
  );

  @GET(SalesPosRoutes.invoicePdf)
  @DioResponseType(ResponseType.plain)
  Future<String> invoiceHtml(@Path('orderId') String orderId);

  @POST(SalesPosRoutes.requestReturn)
  Future<ApiResponse<OrderDto>> requestReturn(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );

  @GET(SalesPosRoutes.shiftCurrent)
  Future<ApiResponse<ShiftDto>> currentShift();

  @POST(SalesPosRoutes.shiftOpen)
  Future<ApiResponse<ShiftDto>> openShift(
    @Body() Map<String, dynamic> body,
  );

  @POST(SalesPosRoutes.shiftDrop)
  Future<ApiResponse<EmptyDto>> dropCash(
    @Body() Map<String, dynamic> body,
  );

  @POST(SalesPosRoutes.shiftClose)
  Future<ApiResponse<ShiftDto>> closeShift(
    @Body() Map<String, dynamic> body,
  );

  @POST(SalesPosRoutes.reservations)
  Future<ApiResponse<ReservationDto>> reserve(
    @Body() Map<String, dynamic> reservation,
  );

  @GET(SalesPosRoutes.reservationById)
  Future<ApiResponse<ReservationDto>> reservationById(
    @Path('id') String id,
  );

  @POST(SalesPosRoutes.reservationPay)
  Future<ApiResponse<EmptyDto>> payReservation(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(SalesPosRoutes.reservationFulfill)
  Future<ApiResponse<OrderDto>> fulfillReservation(
    @Path('id') String id,
  );

  @POST(SalesPosRoutes.reservationCancel)
  Future<ApiResponse<EmptyDto>> cancelReservation(
    @Path('id') String id,
  );

  @GET(SalesPosRoutes.orderList)
  Future<ApiResponse<PagedResponse<OrderDto>>> listOrders(
    @Query('page') int page,
    @Query('size') int size,
  );

  @GET(SalesPosRoutes.orderById)
  Future<ApiResponse<OrderDto>> orderById(
    @Path('orderId') String orderId,
  );

  @POST(SalesPosRoutes.payBalance)
  Future<ApiResponse<EmptyDto>> payBalance(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );
}
