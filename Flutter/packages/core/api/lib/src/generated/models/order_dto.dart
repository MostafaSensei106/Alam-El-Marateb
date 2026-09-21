import 'package:json_annotation/json_annotation.dart';

part 'order_dto.g.dart';

/// Backend `OrderLineResponse`.
@JsonSerializable()
final class OrderLineDto {
  const OrderLineDto({
    this.variantId = '',
    this.qty = 0,
    this.unitPrice = 0.0,
    this.discount = 0.0,
    this.net = 0.0,
    this.appliedPromoCodes = const [],
    this.isGift = false,
    this.isCustom = false,
    this.customSpec,
  });

  factory OrderLineDto.fromJson(Map<String, dynamic> json) =>
      _$OrderLineDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderLineDtoToJson(this);

  final String variantId;
  final int qty;
  final double unitPrice;
  final double discount;
  final double net;
  final List<String> appliedPromoCodes;
  final bool isGift;
  final bool isCustom;
  final String? customSpec;
}

/// Backend `OrderResponse`.
@JsonSerializable()
final class OrderDto {
  const OrderDto({
    this.id = '',
    this.status = '',
    this.channel = '',
    this.paymentMethod,
    this.paymentStatus = '',
    this.subtotal = 0.0,
    this.discountTotal = 0.0,
    this.deliveryFee = 0.0,
    this.carryUpFee = 0.0,
    this.grandTotal = 0.0,
    this.paidAmount = 0.0,
    this.trackingNumber,
    this.lines = const [],
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);

  final String id;
  final String status;
  final String channel;
  final String? paymentMethod;
  final String paymentStatus;
  final double subtotal;
  final double discountTotal;
  final double deliveryFee;
  final double carryUpFee;
  final double grandTotal;
  final double paidAmount;
  final String? trackingNumber;
  final List<OrderLineDto> lines;

  double get remaining => grandTotal - paidAmount;
}

/// Backend `CartLineView` + `CartView`.
@JsonSerializable()
final class CartLineDto {
  const CartLineDto({
    this.variantId = '',
    this.qty = 0,
    this.unitPrice = 0.0,
    this.lineTotal = 0.0,
  });

  factory CartLineDto.fromJson(Map<String, dynamic> json) =>
      _$CartLineDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartLineDtoToJson(this);

  final String variantId;
  final int qty;
  final double unitPrice;
  final double lineTotal;
}

@JsonSerializable()
final class CartDto {
  const CartDto({this.id, this.lines = const [], this.subtotal = 0.0});

  factory CartDto.fromJson(Map<String, dynamic> json) =>
      _$CartDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartDtoToJson(this);

  final String? id;
  final List<CartLineDto> lines;
  final double subtotal;
}

/// Backend `ShiftView`.
@JsonSerializable()
final class ShiftDto {
  const ShiftDto({
    this.id,
    this.branchId,
    this.cashierId,
    this.openedAt,
    this.openingBalance = 0.0,
    this.closedAt,
    this.expectedCash,
    this.actualCash,
    this.variance,
    this.dropsTotal = 0.0,
    this.status = '',
  });

  factory ShiftDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftDtoToJson(this);

  final String? id;
  final String? branchId;
  final String? cashierId;
  final String? openedAt;
  final double openingBalance;
  final String? closedAt;
  final double? expectedCash;
  final double? actualCash;
  final double? variance;
  final double dropsTotal;
  final String status;

  bool get isOpen => status.toUpperCase() == 'ACTIVE';
}

/// Backend `EstimateResponse(deliveryFee, carryUpFee)`.
@JsonSerializable()
final class ShippingEstimateDto {
  const ShippingEstimateDto({this.deliveryFee = 0.0, this.carryUpFee = 0.0});

  factory ShippingEstimateDto.fromJson(Map<String, dynamic> json) =>
      _$ShippingEstimateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingEstimateDtoToJson(this);

  final double deliveryFee;
  final double carryUpFee;

  double get total => deliveryFee + carryUpFee;
}
