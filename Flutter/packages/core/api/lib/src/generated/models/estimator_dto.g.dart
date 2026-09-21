// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimator_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EstimatorModelDto _$EstimatorModelDtoFromJson(Map<String, dynamic> json) =>
    EstimatorModelDto(
      productId: json['productId'] as String?,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      pricePerMeter: (json['pricePerMeter'] as num?)?.toDouble(),
      hasMeterPrice: json['hasMeterPrice'] as bool? ?? false,
      heightsCm: (json['heightsCm'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$EstimatorModelDtoToJson(EstimatorModelDto instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'slug': instance.slug,
      'brand': instance.brand,
      'categoryId': instance.categoryId,
      'pricePerMeter': instance.pricePerMeter,
      'hasMeterPrice': instance.hasMeterPrice,
      'heightsCm': instance.heightsCm,
    };

EstimateBreakdownDto _$EstimateBreakdownDtoFromJson(
        Map<String, dynamic> json) =>
    EstimateBreakdownDto(
      mattressTotal: (json['mattressTotal'] as num?)?.toDouble() ?? 0.0,
      areaM2: (json['areaM2'] as num?)?.toDouble() ?? 0.0,
      operatingPct: (json['operatingPct'] as num?)?.toInt() ?? 0,
      shape: json['shape'] as String? ?? '',
      widthCm: (json['widthCm'] as num?)?.toInt() ?? 0,
      lengthCm: (json['lengthCm'] as num?)?.toInt() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      carryUpFee: (json['carryUpFee'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0.0,
      skuSuggestion: json['skuSuggestion'] as String? ?? '',
    );

Map<String, dynamic> _$EstimateBreakdownDtoToJson(
        EstimateBreakdownDto instance) =>
    <String, dynamic>{
      'mattressTotal': instance.mattressTotal,
      'areaM2': instance.areaM2,
      'operatingPct': instance.operatingPct,
      'shape': instance.shape,
      'widthCm': instance.widthCm,
      'lengthCm': instance.lengthCm,
      'deliveryFee': instance.deliveryFee,
      'carryUpFee': instance.carryUpFee,
      'grandTotal': instance.grandTotal,
      'skuSuggestion': instance.skuSuggestion,
    };

PrizeDto _$PrizeDtoFromJson(Map<String, dynamic> json) => PrizeDto(
      id: json['id'] as String?,
      label: json['label'] as String? ?? '',
      kind: json['kind'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      giftVariantId: json['giftVariantId'] as String?,
      weight: (json['weight'] as num?)?.toInt() ?? 0,
      maxWins: (json['maxWins'] as num?)?.toInt(),
      winsLeft: (json['winsLeft'] as num?)?.toInt(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PrizeDtoToJson(PrizeDto instance) => <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'kind': instance.kind,
      'value': instance.value,
      'giftVariantId': instance.giftVariantId,
      'weight': instance.weight,
      'maxWins': instance.maxWins,
      'winsLeft': instance.winsLeft,
      'sortOrder': instance.sortOrder,
    };

CampaignDto _$CampaignDtoFromJson(Map<String, dynamic> json) => CampaignDto(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      startsAt: json['startsAt'] as String?,
      endsAt: json['endsAt'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      spinsPerCustomer: (json['spinsPerCustomer'] as num?)?.toInt() ?? 0,
      prizes: (json['prizes'] as List<dynamic>?)
              ?.map((e) => PrizeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CampaignDtoToJson(CampaignDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startsAt': instance.startsAt,
      'endsAt': instance.endsAt,
      'isActive': instance.isActive,
      'spinsPerCustomer': instance.spinsPerCustomer,
      'prizes': instance.prizes,
    };

SpinResultDto _$SpinResultDtoFromJson(Map<String, dynamic> json) =>
    SpinResultDto(
      campaignId: json['campaignId'] as String?,
      label: json['label'] as String? ?? '',
      won: json['won'] as bool? ?? false,
      promoCode: json['promoCode'] as String?,
      kind: json['kind'] as String? ?? '',
    );

Map<String, dynamic> _$SpinResultDtoToJson(SpinResultDto instance) =>
    <String, dynamic>{
      'campaignId': instance.campaignId,
      'label': instance.label,
      'won': instance.won,
      'promoCode': instance.promoCode,
      'kind': instance.kind,
    };
