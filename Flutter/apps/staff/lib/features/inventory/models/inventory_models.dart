import '../../../shared/enums.dart';

int _int(Object? value) => switch (value) {
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? 0,
  _ => 0,
};

double _money(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};

class Warehouse {
  const Warehouse({
    this.id,
    this.branchId,
    required this.name,
    required this.code,
    this.isActive = true,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
    id: json['id']?.toString(),
    branchId: json['branchId']?.toString(),
    name: json['name']?.toString() ?? '',
    code: json['code']?.toString() ?? '',
    isActive: json['isActive'] as bool? ?? true,
  );

  final String? id;
  final String? branchId;
  final String name;
  final String code;
  final bool isActive;
}

class StockLevel {
  const StockLevel({
    required this.warehouseId,
    required this.variantId,
    this.qty = 0,
    this.reservedQty = 0,
    this.minQty,
  });

  factory StockLevel.fromJson(Map<String, dynamic> json) => StockLevel(
    warehouseId: json['warehouseId']?.toString() ?? '',
    variantId: json['variantId']?.toString() ?? '',
    qty: _int(json['qty']),
    reservedQty: _int(json['reservedQty']),
    minQty: json['minQty'] is num ? (json['minQty'] as num).toInt() : null,
  );

  final String warehouseId;
  final String variantId;
  final int qty;
  final int reservedQty;
  final int? minQty;

  int get available => qty - reservedQty;
}

class TransferLine {
  const TransferLine({required this.variantId, required this.qty});

  final String variantId;
  final int qty;
}

class StockTransfer {
  const StockTransfer({
    this.id,
    required this.fromWarehouseId,
    required this.toWarehouseId,
    required this.status,
    this.note,
    this.items = const <TransferItem>[],
  });

  factory StockTransfer.fromJson(Map<String, dynamic> json) =>
      StockTransfer(
        id: json['id']?.toString(),
        fromWarehouseId: json['fromWarehouseId']?.toString() ?? '',
        toWarehouseId: json['toWarehouseId']?.toString() ?? '',
        status: TransferStatus.fromValue(json['status']?.toString()),
        note: json['note']?.toString(),
        items: json['items'] is List
            ? (json['items'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map(TransferItem.fromJson)
                  .toList()
            : const <TransferItem>[],
      );

  final String? id;
  final String fromWarehouseId;
  final String toWarehouseId;
  final TransferStatus status;
  final String? note;
  final List<TransferItem> items;
}

class TransferItem {
  const TransferItem({
    required this.variantId,
    this.sentQty = 0,
    this.receivedQty = 0,
    this.damagedQty = 0,
  });

  factory TransferItem.fromJson(Map<String, dynamic> json) => TransferItem(
    variantId: json['variantId']?.toString() ?? '',
    sentQty: _int(json['sentQty']),
    receivedQty: _int(json['receivedQty']),
    damagedQty: _int(json['damagedQty']),
  );

  final String variantId;
  final int sentQty;
  final int receivedQty;
  final int damagedQty;
}

/// One FIFO cost layer: GET /inventory/batches item.
class InventoryBatch {
  const InventoryBatch({
    this.id,
    required this.batchNo,
    this.variantId,
    this.warehouseId,
    this.qtyReceived = 0,
    this.qtyRemaining = 0,
    this.unitCost = 0,
    this.landedUnitCost = 0,
    this.currentSelling,
    this.potentialRevenue,
    this.potentialProfit,
  });

  factory InventoryBatch.fromJson(Map<String, dynamic> json) =>
      InventoryBatch(
        id: json['id']?.toString(),
        batchNo: json['batchNo']?.toString() ?? '',
        variantId: json['variantId']?.toString(),
        warehouseId: json['warehouseId']?.toString(),
        qtyReceived: _int(json['qtyReceived']),
        qtyRemaining: _int(json['qtyRemaining']),
        unitCost: _money(json['unitCost']),
        landedUnitCost: _money(json['landedUnitCost']),
        currentSelling: json['currentSelling'] == null
            ? null
            : _money(json['currentSelling']),
        potentialRevenue: json['potentialRevenue'] == null
            ? null
            : _money(json['potentialRevenue']),
        potentialProfit: json['potentialProfit'] == null
            ? null
            : _money(json['potentialProfit']),
      );

  final String? id;
  final String batchNo;
  final String? variantId;
  final String? warehouseId;
  final int qtyReceived;
  final int qtyRemaining;
  final double unitCost;
  final double landedUnitCost;
  final double? currentSelling;
  final double? potentialRevenue;
  final double? potentialProfit;
}

/// GET /inventory/batches/valuation result.
class BatchValuation {
  const BatchValuation({
    this.inventoryCost = 0,
    this.inventoryNetCost = 0,
    this.landedAdded = 0,
    this.potentialRevenue = 0,
    this.potentialProfit = 0,
    this.potentialProfitNet = 0,
  });

  factory BatchValuation.fromJson(Map<String, dynamic> json) =>
      BatchValuation(
        inventoryCost: _money(json['inventoryCost']),
        inventoryNetCost: _money(json['inventoryNetCost']),
        landedAdded: _money(json['landedAdded']),
        potentialRevenue: _money(json['potentialRevenue']),
        potentialProfit: _money(json['potentialProfit']),
        potentialProfitNet: _money(json['potentialProfitNet']),
      );

  final double inventoryCost;
  final double inventoryNetCost;
  final double landedAdded;
  final double potentialRevenue;
  final double potentialProfit;
  final double potentialProfitNet;
}
