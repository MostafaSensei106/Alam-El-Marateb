import 'package:json_annotation/json_annotation.dart';

part 'sales_dto.g.dart';

/// Backend `PromotionView` (`type` serializes as enum name).
@JsonSerializable()
final class PromotionDto {
  const PromotionDto({
    this.id,
    this.code = '',
    this.name = '',
    this.type = '',
    this.isActive = false,
    this.exclusive = false,
  });

  factory PromotionDto.fromJson(Map<String, dynamic> json) =>
      _$PromotionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionDtoToJson(this);

  final String? id;
  final String code;
  final String name;
  final String type;
  final bool isActive;
  final bool exclusive;
}

/// Backend `LineResultResponse`.
@JsonSerializable()
final class LineResultDto {
  const LineResultDto({
    this.productId = '',
    this.variantId,
    this.qty = 0,
    this.unitPrice = 0.0,
    this.gross = 0.0,
    this.discount = 0.0,
    this.net = 0.0,
    this.appliedCodes = const [],
    this.isGift = false,
  });

  factory LineResultDto.fromJson(Map<String, dynamic> json) =>
      _$LineResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LineResultDtoToJson(this);

  final String productId;
  final String? variantId;
  final int qty;
  final double unitPrice;
  final double gross;
  final double discount;
  final double net;
  final List<String> appliedCodes;
  final bool isGift;
}

/// Backend `PricePreviewResponse`.
@JsonSerializable()
final class PricePreviewDto {
  const PricePreviewDto({
    this.lines = const [],
    this.subtotal = 0.0,
    this.totalDiscount = 0.0,
    this.total = 0.0,
    this.appliedCodes = const [],
  });

  factory PricePreviewDto.fromJson(Map<String, dynamic> json) =>
      _$PricePreviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PricePreviewDtoToJson(this);

  final List<LineResultDto> lines;
  final double subtotal;
  final double totalDiscount;
  final double total;
  final List<String> appliedCodes;
}
