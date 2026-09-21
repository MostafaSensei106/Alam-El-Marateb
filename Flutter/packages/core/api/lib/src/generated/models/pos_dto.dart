import 'package:json_annotation/json_annotation.dart';

part 'pos_dto.g.dart';

/// Backend `scanVariant` map
/// (variantId, productId, sku, barcode, dimensions, sellingPrice, isActive).
@JsonSerializable()
final class ScanResultDto {
  const ScanResultDto({
    this.variantId,
    this.productId,
    this.sku = '',
    this.barcode,
    this.dimensions = '',
    this.sellingPrice = 0.0,
    this.isActive = true,
  });

  factory ScanResultDto.fromJson(Map<String, dynamic> json) =>
      _$ScanResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResultDtoToJson(this);

  final String? variantId;
  final String? productId;
  final String sku;
  final String? barcode;
  final String dimensions;
  final double sellingPrice;
  final bool isActive;
}

/// Backend `ReservationPaymentView(amount, method, paidAt, receivedBy)`.
@JsonSerializable()
final class ReservationPaymentDto {
  const ReservationPaymentDto({
    this.amount = 0.0,
    this.method = '',
    this.paidAt,
    this.receivedBy,
  });

  factory ReservationPaymentDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationPaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationPaymentDtoToJson(this);

  final double amount;
  final String method;
  final String? paidAt;
  final String? receivedBy;
}

/// Backend `ReservationView`.
@JsonSerializable()
final class ReservationDto {
  const ReservationDto({
    this.id,
    this.branchId,
    this.customerId,
    this.guestPhone,
    this.variantId,
    this.qty = 0,
    this.total = 0.0,
    this.paidAmount = 0.0,
    this.remaining = 0.0,
    this.deliverAt,
    this.status = '',
    this.payments = const [],
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationDtoToJson(this);

  final String? id;
  final String? branchId;
  final String? customerId;
  final String? guestPhone;
  final String? variantId;
  final int qty;
  final double total;
  final double paidAmount;
  final double remaining;
  final String? deliverAt;
  final String status;
  final List<ReservationPaymentDto> payments;
}

/// Backend `ReceiptLine` + `ReceiptView` (thermal receipt envelope).
@JsonSerializable()
final class ReceiptLineDto {
  const ReceiptLineDto({
    this.variantId,
    this.qty = 0,
    this.unitPrice = 0.0,
    this.discount = 0.0,
    this.net = 0.0,
    this.isGift = false,
  });

  factory ReceiptLineDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptLineDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptLineDtoToJson(this);

  final String? variantId;
  final int qty;
  final double unitPrice;
  final double discount;
  final double net;
  final bool isGift;
}

@JsonSerializable()
final class ReceiptDto {
  const ReceiptDto({
    this.orderId,
    this.serial,
    this.trackingNumber,
    this.status = '',
    this.paymentMethod,
    this.paymentStatus = '',
    this.lines = const [],
    this.subtotal = 0.0,
    this.discountTotal = 0.0,
    this.deliveryFee = 0.0,
    this.carryUpFee = 0.0,
    this.grandTotal = 0.0,
    this.issuedAt,
  });

  factory ReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptDtoToJson(this);

  final String? orderId;
  final String? serial;
  final String? trackingNumber;
  final String status;
  final String? paymentMethod;
  final String paymentStatus;
  final List<ReceiptLineDto> lines;
  final double subtotal;
  final double discountTotal;
  final double deliveryFee;
  final double carryUpFee;
  final double grandTotal;
  final String? issuedAt;
}
