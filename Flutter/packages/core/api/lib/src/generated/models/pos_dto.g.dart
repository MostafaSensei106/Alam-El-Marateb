// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResultDto _$ScanResultDtoFromJson(Map<String, dynamic> json) =>
    ScanResultDto(
      variantId: json['variantId'] as String?,
      productId: json['productId'] as String?,
      sku: json['sku'] as String? ?? '',
      barcode: json['barcode'] as String?,
      dimensions: json['dimensions'] as String? ?? '',
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ScanResultDtoToJson(ScanResultDto instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'productId': instance.productId,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'dimensions': instance.dimensions,
      'sellingPrice': instance.sellingPrice,
      'isActive': instance.isActive,
    };

ReservationPaymentDto _$ReservationPaymentDtoFromJson(
        Map<String, dynamic> json) =>
    ReservationPaymentDto(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      method: json['method'] as String? ?? '',
      paidAt: json['paidAt'] as String?,
      receivedBy: json['receivedBy'] as String?,
    );

Map<String, dynamic> _$ReservationPaymentDtoToJson(
        ReservationPaymentDto instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'method': instance.method,
      'paidAt': instance.paidAt,
      'receivedBy': instance.receivedBy,
    };

ReservationDto _$ReservationDtoFromJson(Map<String, dynamic> json) =>
    ReservationDto(
      id: json['id'] as String?,
      branchId: json['branchId'] as String?,
      customerId: json['customerId'] as String?,
      guestPhone: json['guestPhone'] as String?,
      variantId: json['variantId'] as String?,
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      remaining: (json['remaining'] as num?)?.toDouble() ?? 0.0,
      deliverAt: json['deliverAt'] as String?,
      status: json['status'] as String? ?? '',
      payments: (json['payments'] as List<dynamic>?)
              ?.map((e) =>
                  ReservationPaymentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ReservationDtoToJson(ReservationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'customerId': instance.customerId,
      'guestPhone': instance.guestPhone,
      'variantId': instance.variantId,
      'qty': instance.qty,
      'total': instance.total,
      'paidAmount': instance.paidAmount,
      'remaining': instance.remaining,
      'deliverAt': instance.deliverAt,
      'status': instance.status,
      'payments': instance.payments,
    };

ReceiptLineDto _$ReceiptLineDtoFromJson(Map<String, dynamic> json) =>
    ReceiptLineDto(
      variantId: json['variantId'] as String?,
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      net: (json['net'] as num?)?.toDouble() ?? 0.0,
      isGift: json['isGift'] as bool? ?? false,
    );

Map<String, dynamic> _$ReceiptLineDtoToJson(ReceiptLineDto instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'qty': instance.qty,
      'unitPrice': instance.unitPrice,
      'discount': instance.discount,
      'net': instance.net,
      'isGift': instance.isGift,
    };

ReceiptDto _$ReceiptDtoFromJson(Map<String, dynamic> json) => ReceiptDto(
      orderId: json['orderId'] as String?,
      serial: json['serial'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
      status: json['status'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String? ?? '',
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => ReceiptLineDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountTotal: (json['discountTotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      carryUpFee: (json['carryUpFee'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0.0,
      issuedAt: json['issuedAt'] as String?,
    );

Map<String, dynamic> _$ReceiptDtoToJson(ReceiptDto instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'serial': instance.serial,
      'trackingNumber': instance.trackingNumber,
      'status': instance.status,
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
      'lines': instance.lines,
      'subtotal': instance.subtotal,
      'discountTotal': instance.discountTotal,
      'deliveryFee': instance.deliveryFee,
      'carryUpFee': instance.carryUpFee,
      'grandTotal': instance.grandTotal,
      'issuedAt': instance.issuedAt,
    };
