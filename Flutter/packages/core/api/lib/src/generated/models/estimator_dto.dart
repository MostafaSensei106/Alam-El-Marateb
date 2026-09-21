import 'package:json_annotation/json_annotation.dart';

part 'estimator_dto.g.dart';

/// Backend `EstimatorModel` — models eligible for custom manufacture.
@JsonSerializable()
final class EstimatorModelDto {
  const EstimatorModelDto({
    this.productId,
    this.name = '',
    this.slug = '',
    this.brand = '',
    this.categoryId = '',
    this.pricePerMeter,
    this.hasMeterPrice = false,
    this.heightsCm = const [],
  });

  factory EstimatorModelDto.fromJson(Map<String, dynamic> json) =>
      _$EstimatorModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EstimatorModelDtoToJson(this);

  final String? productId;
  final String name;
  final String slug;
  final String brand;
  final String categoryId;
  final double? pricePerMeter;
  final bool hasMeterPrice;
  final List<int> heightsCm;
}

/// Backend `EstimateBreakdown`.
@JsonSerializable()
final class EstimateBreakdownDto {
  const EstimateBreakdownDto({
    this.mattressTotal = 0.0,
    this.areaM2 = 0.0,
    this.operatingPct = 0,
    this.shape = '',
    this.widthCm = 0,
    this.lengthCm = 0,
    this.deliveryFee = 0.0,
    this.carryUpFee = 0.0,
    this.grandTotal = 0.0,
    this.skuSuggestion = '',
  });

  factory EstimateBreakdownDto.fromJson(Map<String, dynamic> json) =>
      _$EstimateBreakdownDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EstimateBreakdownDtoToJson(this);

  final double mattressTotal;
  final double areaM2;
  final int operatingPct;
  final String shape;
  final int widthCm;
  final int lengthCm;
  final double deliveryFee;
  final double carryUpFee;
  final double grandTotal;
  final String skuSuggestion;
}

/// Backend `PrizeView`.
@JsonSerializable()
final class PrizeDto {
  const PrizeDto({
    this.id,
    this.label = '',
    this.kind = '',
    this.value = 0.0,
    this.giftVariantId,
    this.weight = 0,
    this.maxWins,
    this.winsLeft,
    this.sortOrder = 0,
  });

  factory PrizeDto.fromJson(Map<String, dynamic> json) =>
      _$PrizeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PrizeDtoToJson(this);

  final String? id;
  final String label;
  final String kind;
  final double value;
  final String? giftVariantId;
  final int weight;
  final int? maxWins;
  final int? winsLeft;
  final int sortOrder;
}

/// Backend `CampaignView`.
@JsonSerializable()
final class CampaignDto {
  const CampaignDto({
    this.id,
    this.name = '',
    this.startsAt,
    this.endsAt,
    this.isActive = false,
    this.spinsPerCustomer = 0,
    this.prizes = const [],
  });

  factory CampaignDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignDtoToJson(this);

  final String? id;
  final String name;
  final String? startsAt;
  final String? endsAt;
  final bool isActive;
  final int spinsPerCustomer;
  final List<PrizeDto> prizes;
}

/// Backend `SpinResult(campaignId, label, won, promoCode, kind)`.
@JsonSerializable()
final class SpinResultDto {
  const SpinResultDto({
    this.campaignId,
    this.label = '',
    this.won = false,
    this.promoCode,
    this.kind = '',
  });

  factory SpinResultDto.fromJson(Map<String, dynamic> json) =>
      _$SpinResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SpinResultDtoToJson(this);

  final String? campaignId;
  final String label;
  final bool won;
  final String? promoCode;
  final String kind;
}
