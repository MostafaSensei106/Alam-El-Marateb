import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_routes.dart';
import 'models/inventory_dto.dart';

part 'inventory_api.g.dart';

/// Supply chain: inventory management, warehouse floor ops, purchasing.
@RestApi()
abstract class InventoryApi {
  factory InventoryApi(Dio dio) = _InventoryApi;

  @GET(InventoryAdminRoutes.warehouses)
  Future<ApiResponse<List<WarehouseDto>>> warehouses();

  @POST(InventoryAdminRoutes.warehouses)
  Future<ApiResponse<WarehouseDto>> createWarehouse(
    @Body() Map<String, dynamic> body,
  );

  @GET(InventoryAdminRoutes.warehouseById)
  Future<ApiResponse<WarehouseDto>> warehouseById(
    @Path('warehouseId') String warehouseId,
  );

  @GET(InventoryAdminRoutes.stocks)
  Future<ApiResponse<List<StockLevelDto>>> stocks(
    @Query('warehouseId') String warehouseId,
  );

  @GET(InventoryAdminRoutes.lowStockAlerts)
  Future<ApiResponse<List<StockLevelDto>>> lowStockAlerts();

  @POST(InventoryAdminRoutes.setThreshold)
  Future<ApiResponse<StockLevelDto>> setThreshold(
    @Body() Map<String, dynamic> body,
  );

  @POST(InventoryAdminRoutes.transfers)
  Future<ApiResponse<TransferDto>> createTransfer(
    @Body() Map<String, dynamic> body,
  );

  @GET(InventoryAdminRoutes.transferById)
  Future<ApiResponse<TransferDto>> transferById(
    @Path('transferId') String transferId,
  );

  @POST(InventoryAdminRoutes.transferApprove)
  Future<ApiResponse<TransferDto>> approveTransfer(
    @Path('transferId') String transferId,
  );

  @POST(InventoryAdminRoutes.audits)
  Future<ApiResponse<AuditResultDto>> openAudit(
    @Body() Map<String, dynamic> body,
  );

  @GET(InventoryAdminRoutes.auditById)
  Future<ApiResponse<AuditResultDto>> auditById(
    @Path('auditId') String auditId,
  );

  @POST(InventoryAdminRoutes.auditReconcile)
  Future<ApiResponse<AuditResultDto>> reconcileAudit(
    @Path('auditId') String auditId,
  );

  @GET(WarehouseOpsRoutes.stockLookup)
  Future<ApiResponse<StockLevelDto>> stockLookup(
    @Path('barcodeOrSku') String barcodeOrSku,
    @Query('warehouseId') String? warehouseId,
  );

  @POST(WarehouseOpsRoutes.stockAdjustment)
  Future<ApiResponse<StockLevelDto>> adjustStock(
    @Body() Map<String, dynamic> adjustment,
  );

  @GET(WarehouseOpsRoutes.transfersPending)
  Future<ApiResponse<List<TransferDto>>> pendingTransfers(
    @Query('warehouseId') String warehouseId,
  );

  @POST(WarehouseOpsRoutes.transferConfirm)
  Future<ApiResponse<TransferDto>> confirmReceipt(
    @Path('transferId') String transferId,
    @Body() Map<String, dynamic> receipt,
  );

  @POST(WarehouseOpsRoutes.auditCount)
  Future<ApiResponse<AuditVarianceDto>> submitCount(
    @Path('auditId') String auditId,
    @Body() Map<String, dynamic> count,
  );

  @GET(PurchasingRoutes.suppliers)
  Future<ApiResponse<List<SupplierDto>>> suppliers(
    @Query('activeOnly') bool? activeOnly,
  );

  @POST(PurchasingRoutes.suppliers)
  Future<ApiResponse<SupplierDto>> createSupplier(
    @Body() Map<String, dynamic> body,
  );

  @GET(PurchasingRoutes.supplierById)
  Future<ApiResponse<SupplierDto>> supplierById(
    @Path('id') String id,
  );

  @GET(PurchasingRoutes.purchaseOrders)
  Future<ApiResponse<List<PurchaseOrderDto>>> purchaseOrders();

  @POST(PurchasingRoutes.purchaseOrders)
  Future<ApiResponse<PurchaseOrderDto>> createPurchaseOrder(
    @Body() Map<String, dynamic> body,
  );

  @GET(PurchasingRoutes.purchaseOrderById)
  Future<ApiResponse<PurchaseOrderDto>> purchaseOrderById(
    @Path('id') String id,
  );

  @POST(PurchasingRoutes.receiveGoods)
  Future<ApiResponse<GoodsReceiptDto>> receiveGoods(
    @Path('id') String purchaseOrderId,
    @Body() Map<String, dynamic> receipt,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  @POST(PurchasingRoutes.supplierPayments)
  Future<ApiResponse<EmptyDto>> recordSupplierPayment(
    @Body() Map<String, dynamic> payment,
  );
}
