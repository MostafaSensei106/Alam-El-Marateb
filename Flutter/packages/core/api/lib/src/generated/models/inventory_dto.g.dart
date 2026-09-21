// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarehouseDto _$WarehouseDtoFromJson(Map<String, dynamic> json) => WarehouseDto(
      id: json['id'] as String?,
      branchId: json['branchId'] as String?,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$WarehouseDtoToJson(WarehouseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'name': instance.name,
      'code': instance.code,
      'isActive': instance.isActive,
    };

StockLevelDto _$StockLevelDtoFromJson(Map<String, dynamic> json) =>
    StockLevelDto(
      warehouseId: json['warehouseId'] as String? ?? '',
      variantId: json['variantId'] as String? ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      reservedQty: (json['reservedQty'] as num?)?.toInt() ?? 0,
      minQty: (json['minQty'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StockLevelDtoToJson(StockLevelDto instance) =>
    <String, dynamic>{
      'warehouseId': instance.warehouseId,
      'variantId': instance.variantId,
      'qty': instance.qty,
      'reservedQty': instance.reservedQty,
      'minQty': instance.minQty,
    };

TransferItemDto _$TransferItemDtoFromJson(Map<String, dynamic> json) =>
    TransferItemDto(
      variantId: json['variantId'] as String? ?? '',
      sentQty: (json['sentQty'] as num?)?.toInt() ?? 0,
      receivedQty: (json['receivedQty'] as num?)?.toInt() ?? 0,
      damagedQty: (json['damagedQty'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TransferItemDtoToJson(TransferItemDto instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'sentQty': instance.sentQty,
      'receivedQty': instance.receivedQty,
      'damagedQty': instance.damagedQty,
    };

TransferDto _$TransferDtoFromJson(Map<String, dynamic> json) => TransferDto(
      id: json['id'] as String?,
      fromWarehouseId: json['fromWarehouseId'] as String? ?? '',
      toWarehouseId: json['toWarehouseId'] as String? ?? '',
      status: json['status'] as String? ?? TransferStatus.draft,
      note: json['note'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TransferItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TransferDtoToJson(TransferDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromWarehouseId': instance.fromWarehouseId,
      'toWarehouseId': instance.toWarehouseId,
      'status': instance.status,
      'note': instance.note,
      'items': instance.items,
    };

AuditVarianceDto _$AuditVarianceDtoFromJson(Map<String, dynamic> json) =>
    AuditVarianceDto(
      variantId: json['variantId'] as String? ?? '',
      systemQty: (json['systemQty'] as num?)?.toInt() ?? 0,
      countedQty: (json['countedQty'] as num?)?.toInt() ?? 0,
      variance: (json['variance'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AuditVarianceDtoToJson(AuditVarianceDto instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'systemQty': instance.systemQty,
      'countedQty': instance.countedQty,
      'variance': instance.variance,
    };

AuditResultDto _$AuditResultDtoFromJson(Map<String, dynamic> json) =>
    AuditResultDto(
      id: json['id'] as String?,
      warehouseId: json['warehouseId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      variances: (json['variances'] as List<dynamic>?)
              ?.map((e) => AuditVarianceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AuditResultDtoToJson(AuditResultDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'warehouseId': instance.warehouseId,
      'status': instance.status,
      'variances': instance.variances,
    };

SupplierDto _$SupplierDtoFromJson(Map<String, dynamic> json) => SupplierDto(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      taxId: json['taxId'] as String?,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$SupplierDtoToJson(SupplierDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'taxId': instance.taxId,
      'balance': instance.balance,
      'isActive': instance.isActive,
    };

PoItemDto _$PoItemDtoFromJson(Map<String, dynamic> json) => PoItemDto(
      variantId: json['variantId'] as String? ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PoItemDtoToJson(PoItemDto instance) => <String, dynamic>{
      'variantId': instance.variantId,
      'qty': instance.qty,
      'unitCost': instance.unitCost,
    };

PurchaseOrderDto _$PurchaseOrderDtoFromJson(Map<String, dynamic> json) =>
    PurchaseOrderDto(
      id: json['id'] as String?,
      supplierId: json['supplierId'] as String?,
      branchId: json['branchId'] as String?,
      status: json['status'] as String? ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PoItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PurchaseOrderDtoToJson(PurchaseOrderDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplierId': instance.supplierId,
      'branchId': instance.branchId,
      'status': instance.status,
      'total': instance.total,
      'items': instance.items,
    };

ReceiptItemDto _$ReceiptItemDtoFromJson(Map<String, dynamic> json) =>
    ReceiptItemDto(
      variantId: json['variantId'] as String? ?? '',
      expectedQty: (json['expectedQty'] as num?)?.toInt() ?? 0,
      actualQty: (json['actualQty'] as num?)?.toInt() ?? 0,
      damagedQty: (json['damagedQty'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReceiptItemDtoToJson(ReceiptItemDto instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'expectedQty': instance.expectedQty,
      'actualQty': instance.actualQty,
      'damagedQty': instance.damagedQty,
    };

GoodsReceiptDto _$GoodsReceiptDtoFromJson(Map<String, dynamic> json) =>
    GoodsReceiptDto(
      id: json['id'] as String?,
      poId: json['poId'] as String?,
      warehouseId: json['warehouseId'] as String?,
      receivedBy: json['receivedBy'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ReceiptItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GoodsReceiptDtoToJson(GoodsReceiptDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poId': instance.poId,
      'warehouseId': instance.warehouseId,
      'receivedBy': instance.receivedBy,
      'items': instance.items,
    };
