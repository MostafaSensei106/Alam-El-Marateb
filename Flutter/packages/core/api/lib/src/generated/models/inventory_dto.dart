import 'package:json_annotation/json_annotation.dart';

part 'inventory_dto.g.dart';

/// Backend `Warehouse(id, branchId, name, code, isActive)`.
@JsonSerializable()
final class WarehouseDto {
  const WarehouseDto({
    this.id,
    this.branchId,
    this.name = '',
    this.code = '',
    this.isActive = true,
  });

  factory WarehouseDto.fromJson(Map<String, dynamic> json) =>
      _$WarehouseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseDtoToJson(this);

  final String? id;
  final String? branchId;
  final String name;
  final String code;
  final bool isActive;
}

/// Backend `StockLevel(warehouseId, variantId, qty, reservedQty, minQty)`.
@JsonSerializable()
final class StockLevelDto {
  const StockLevelDto({
    this.warehouseId = '',
    this.variantId = '',
    this.qty = 0,
    this.reservedQty = 0,
    this.minQty,
  });

  factory StockLevelDto.fromJson(Map<String, dynamic> json) =>
      _$StockLevelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StockLevelDtoToJson(this);

  final String warehouseId;
  final String variantId;
  final int qty;
  final int reservedQty;
  final int? minQty;

  int get available => qty - reservedQty;
}

/// Backend `TransferStatus` values.
abstract final class TransferStatus {
  static const draft = 'draft';
  static const inTransit = 'in_transit';
  static const partiallyReceived = 'partially_received';
  static const received = 'received';
  static const confirmed = 'confirmed';
  static const cancelled = 'cancelled';
}

/// Backend `TransferItem(variantId, sentQty, receivedQty, damagedQty)`.
@JsonSerializable()
final class TransferItemDto {
  const TransferItemDto({
    this.variantId = '',
    this.sentQty = 0,
    this.receivedQty = 0,
    this.damagedQty = 0,
  });

  factory TransferItemDto.fromJson(Map<String, dynamic> json) =>
      _$TransferItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TransferItemDtoToJson(this);

  final String variantId;
  final int sentQty;
  final int receivedQty;
  final int damagedQty;

  int get remaining => sentQty - receivedQty;
}

/// Backend `Transfer`.
@JsonSerializable()
final class TransferDto {
  const TransferDto({
    this.id,
    this.fromWarehouseId = '',
    this.toWarehouseId = '',
    this.status = TransferStatus.draft,
    this.note,
    this.items = const [],
  });

  factory TransferDto.fromJson(Map<String, dynamic> json) =>
      _$TransferDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TransferDtoToJson(this);

  final String? id;
  final String fromWarehouseId;
  final String toWarehouseId;
  final String status;
  final String? note;
  final List<TransferItemDto> items;
}

/// Backend `AuditVariance(variantId, systemQty, countedQty, variance)`.
@JsonSerializable()
final class AuditVarianceDto {
  const AuditVarianceDto({
    this.variantId = '',
    this.systemQty = 0,
    this.countedQty = 0,
    this.variance = 0,
  });

  factory AuditVarianceDto.fromJson(Map<String, dynamic> json) =>
      _$AuditVarianceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuditVarianceDtoToJson(this);

  final String variantId;
  final int systemQty;
  final int countedQty;
  final int variance;
}

/// Backend `AuditResult(id, warehouseId, status, variances)`.
@JsonSerializable()
final class AuditResultDto {
  const AuditResultDto({
    this.id,
    this.warehouseId = '',
    this.status = '',
    this.variances = const [],
  });

  factory AuditResultDto.fromJson(Map<String, dynamic> json) =>
      _$AuditResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuditResultDtoToJson(this);

  final String? id;
  final String warehouseId;
  final String status;
  final List<AuditVarianceDto> variances;
}

/// Backend `SupplierView`.
@JsonSerializable()
final class SupplierDto {
  const SupplierDto({
    this.id,
    this.name = '',
    this.phone,
    this.address,
    this.taxId,
    this.balance = 0.0,
    this.isActive = true,
  });

  factory SupplierDto.fromJson(Map<String, dynamic> json) =>
      _$SupplierDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierDtoToJson(this);

  final String? id;
  final String name;
  final String? phone;
  final String? address;
  final String? taxId;
  final double balance;
  final bool isActive;
}

/// Backend `PoItemView`.
@JsonSerializable()
final class PoItemDto {
  const PoItemDto({
    this.variantId = '',
    this.qty = 0,
    this.unitCost = 0.0,
  });

  factory PoItemDto.fromJson(Map<String, dynamic> json) =>
      _$PoItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PoItemDtoToJson(this);

  final String variantId;
  final int qty;
  final double unitCost;
}

/// Backend `PurchaseOrderView`.
@JsonSerializable()
final class PurchaseOrderDto {
  const PurchaseOrderDto({
    this.id,
    this.supplierId,
    this.branchId,
    this.status = '',
    this.total = 0.0,
    this.items = const [],
  });

  factory PurchaseOrderDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseOrderDtoToJson(this);

  final String? id;
  final String? supplierId;
  final String? branchId;
  final String status;
  final double total;
  final List<PoItemDto> items;
}

/// Backend `ReceiptItemView` + `ReceiptView` (goods receipt).
@JsonSerializable()
final class ReceiptItemDto {
  const ReceiptItemDto({
    this.variantId = '',
    this.expectedQty = 0,
    this.actualQty = 0,
    this.damagedQty = 0,
  });

  factory ReceiptItemDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptItemDtoToJson(this);

  final String variantId;
  final int expectedQty;
  final int actualQty;
  final int damagedQty;
}

@JsonSerializable()
final class GoodsReceiptDto {
  const GoodsReceiptDto({
    this.id,
    this.poId,
    this.warehouseId,
    this.receivedBy,
    this.items = const [],
  });

  factory GoodsReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$GoodsReceiptDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GoodsReceiptDtoToJson(this);

  final String? id;
  final String? poId;
  final String? warehouseId;
  final String? receivedBy;
  final List<ReceiptItemDto> items;
}
