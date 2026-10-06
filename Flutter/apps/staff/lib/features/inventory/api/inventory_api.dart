import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../models/inventory_models.dart';

/// Staff inventory API layer: warehouses, stocks, batches, transfers, audits.
class InventoryApi {
  InventoryApi(this._dio);

  final Dio _dio;

  static const String warehousesPath = '/api/v1/inventory/warehouses';
  static const String stocksPath = '/api/v1/inventory/stocks';
  static const String lowAlertsPath = '/api/v1/inventory/stocks/low-alerts';
  static const String transfersPath = '/api/v1/inventory/transfers';
  static const String auditsPath = '/api/v1/inventory/audits';
  static const String batchesPath = '/api/v1/inventory/batches';
  static const String valuationPath = '/api/v1/inventory/batches/valuation';
  static const String lookupPath = '/api/v1/warehouse/stocks/lookup';
  static const String adjustmentPath = '/api/v1/warehouse/stocks/adjustment';
  static const String pendingPath = '/api/v1/warehouse/transfers/pending';

  static String transferPath(String id) => '$transfersPath/$id';
  static String dispatchPath(String id) => '$transfersPath/$id/dispatch';
  static String approvePath(String id) => '$transfersPath/$id/approve';
  static String confirmReceiptPath(String id) =>
      '/api/v1/warehouse/transfers/$id/confirm-receipt';
  static String auditReconcilePath(String id) => '$auditsPath/$id/reconcile';
  static String auditCountPath(String id) =>
      '/api/v1/warehouse/audits/$id/count';

  Future<List<Warehouse>> warehouses() => ApiExecutor.call(
    () => _dio.get<dynamic>(warehousesPath),
    (json) => (json as List)
        .map((e) => Warehouse.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<List<StockLevel>> stocks(String warehouseId) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      stocksPath,
      queryParameters: <String, dynamic>{'warehouseId': warehouseId},
    ),
    (json) => (json as List)
        .map((e) => StockLevel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<List<StockLevel>> lowAlerts() => ApiExecutor.call(
    () => _dio.get<dynamic>(lowAlertsPath),
    (json) => (json as List)
        .map((e) => StockLevel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<StockTransfer> createTransfer({
    required String fromWarehouseId,
    required String toWarehouseId,
    required List<TransferLine> lines,
    String? note,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      transfersPath,
      data: <String, dynamic>{
        'fromWarehouseId': fromWarehouseId,
        'toWarehouseId': toWarehouseId,
        'note': ?note,
        'items': lines
            .map(
              (l) => <String, dynamic>{'variantId': l.variantId, 'qty': l.qty},
            )
            .toList(),
      },
    ),
    (json) => StockTransfer.fromJson(json as Map<String, dynamic>),
  );

  Future<StockTransfer> dispatch(String transferId) => ApiExecutor.call(
    () => _dio.post<dynamic>(dispatchPath(transferId)),
    (json) => StockTransfer.fromJson(json as Map<String, dynamic>),
  );

  Future<StockTransfer> approve(String transferId) => ApiExecutor.call(
    () => _dio.post<dynamic>(approvePath(transferId)),
    (json) => StockTransfer.fromJson(json as Map<String, dynamic>),
  );

  Future<StockTransfer> confirmReceipt({
    required String transferId,
    required List<TransferLine> lines,
    Map<String, int> damaged = const <String, int>{},
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      confirmReceiptPath(transferId),
      data: <String, dynamic>{
        'lines': lines
            .map(
              (l) => <String, dynamic>{'variantId': l.variantId, 'qty': l.qty},
            )
            .toList(),
        'damaged': damaged,
      },
    ),
    (json) => StockTransfer.fromJson(json as Map<String, dynamic>),
  );

  Future<List<StockTransfer>> pending(String warehouseId) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      pendingPath,
      queryParameters: <String, dynamic>{'warehouseId': warehouseId},
    ),
    (json) => (json as List)
        .map((e) => StockTransfer.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<List<InventoryBatch>> batches({
    String? warehouseId,
    String? variantId,
  }) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      batchesPath,
      queryParameters: <String, dynamic>{
        'warehouseId': ?warehouseId,
        'variantId': ?variantId,
      },
    ),
    (json) => (json as List)
        .map((e) => InventoryBatch.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Future<BatchValuation> valuation({String? warehouseId}) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      valuationPath,
      queryParameters: <String, dynamic>{'warehouseId': ?warehouseId},
    ),
    (json) => BatchValuation.fromJson(json as Map<String, dynamic>),
  );

  Future<StockLevel> lookup({
    required String warehouseId,
    required String barcodeOrSku,
  }) => ApiExecutor.call(
    () => _dio.get<dynamic>(
      '$lookupPath/$barcodeOrSku',
      queryParameters: <String, dynamic>{'warehouseId': warehouseId},
    ),
    (json) => StockLevel.fromJson(json as Map<String, dynamic>),
  );

  Future<StockLevel> adjust({
    required String warehouseId,
    required String variantId,
    required int qtyDelta,
    required String note,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      adjustmentPath,
      data: <String, dynamic>{
        'warehouseId': warehouseId,
        'variantId': variantId,
        'qtyDelta': qtyDelta,
        'note': note,
      },
    ),
    (json) => StockLevel.fromJson(json as Map<String, dynamic>),
  );
}
