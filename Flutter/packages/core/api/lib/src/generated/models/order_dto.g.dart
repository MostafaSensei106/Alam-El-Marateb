// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLineDto _$OrderLineDtoFromJson(Map<String, dynamic> json) => OrderLineDto(
      variantId: json['variantId'] as String? ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      net: (json['net'] as num?)?.toDouble() ?? 0.0,
      appliedPromoCodes: (json['appliedPromoCodes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isGift: json['isGift'] as bool? ?? false,
      isCustom: json['isCustom'] as bool? ?? false,
      customSpec: json['customSpec'] as String?,
    );

Map<String, dynamic> _$OrderLineDtoToJson(OrderLineDto instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'qty': instance.qty,
      'unitPrice': instance.unitPrice,
      'discount': instance.discount,
      'net': instance.net,
      'appliedPromoCodes': instance.appliedPromoCodes,
      'isGift': instance.isGift,
      'isCustom': instance.isCustom,
      'customSpec': instance.customSpec,
    };

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      channel: json['channel'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String? ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountTotal: (json['discountTotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      carryUpFee: (json['carryUpFee'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      trackingNumber: json['trackingNumber'] as String?,
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => OrderLineDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'channel': instance.channel,
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
      'subtotal': instance.subtotal,
      'discountTotal': instance.discountTotal,
      'deliveryFee': instance.deliveryFee,
      'carryUpFee': instance.carryUpFee,
      'grandTotal': instance.grandTotal,
      'paidAmount': instance.paidAmount,
      'trackingNumber': instance.trackingNumber,
      'lines': instance.lines,
    };

CartLineDto _$CartLineDtoFromJson(Map<String, dynamic> json) => CartLineDto(
      variantId: json['variantId'] as String? ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      lineTotal: (json['lineTotal'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$CartLineDtoToJson(CartLineDto instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'qty': instance.qty,
      'unitPrice': instance.unitPrice,
      'lineTotal': instance.lineTotal,
    };

CartDto _$CartDtoFromJson(Map<String, dynamic> json) => CartDto(
      id: json['id'] as String?,
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => CartLineDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$CartDtoToJson(CartDto instance) => <String, dynamic>{
      'id': instance.id,
      'lines': instance.lines,
      'subtotal': instance.subtotal,
    };

ShiftDto _$ShiftDtoFromJson(Map<String, dynamic> json) => ShiftDto(
      id: json['id'] as String?,
      branchId: json['branchId'] as String?,
      cashierId: json['cashierId'] as String?,
      openedAt: json['openedAt'] as String?,
      openingBalance: (json['openingBalance'] as num?)?.toDouble() ?? 0.0,
      closedAt: json['closedAt'] as String?,
      expectedCash: (json['expectedCash'] as num?)?.toDouble(),
      actualCash: (json['actualCash'] as num?)?.toDouble(),
      variance: (json['variance'] as num?)?.toDouble(),
      dropsTotal: (json['dropsTotal'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$ShiftDtoToJson(ShiftDto instance) => <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'cashierId': instance.cashierId,
      'openedAt': instance.openedAt,
      'openingBalance': instance.openingBalance,
      'closedAt': instance.closedAt,
      'expectedCash': instance.expectedCash,
      'actualCash': instance.actualCash,
      'variance': instance.variance,
      'dropsTotal': instance.dropsTotal,
      'status': instance.status,
    };

ShippingEstimateDto _$ShippingEstimateDtoFromJson(Map<String, dynamic> json) =>
    ShippingEstimateDto(
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      carryUpFee: (json['carryUpFee'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ShippingEstimateDtoToJson(
        ShippingEstimateDto instance) =>
    <String, dynamic>{
      'deliveryFee': instance.deliveryFee,
      'carryUpFee': instance.carryUpFee,
    };

TrackingLocationDto _$TrackingLocationDtoFromJson(Map<String, dynamic> json) =>
    TrackingLocationDto(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      recordedAt: json['recordedAt'] as String?,
    );

Map<String, dynamic> _$TrackingLocationDtoToJson(
        TrackingLocationDto instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'recordedAt': instance.recordedAt,
    };
