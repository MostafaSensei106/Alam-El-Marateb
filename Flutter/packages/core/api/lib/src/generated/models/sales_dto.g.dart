// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionDto _$PromotionDtoFromJson(Map<String, dynamic> json) => PromotionDto(
      id: json['id'] as String?,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      exclusive: json['exclusive'] as bool? ?? false,
    );

Map<String, dynamic> _$PromotionDtoToJson(PromotionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'type': instance.type,
      'isActive': instance.isActive,
      'exclusive': instance.exclusive,
    };

LineResultDto _$LineResultDtoFromJson(Map<String, dynamic> json) =>
    LineResultDto(
      productId: json['productId'] as String? ?? '',
      variantId: json['variantId'] as String?,
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      gross: (json['gross'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      net: (json['net'] as num?)?.toDouble() ?? 0.0,
      appliedCodes: (json['appliedCodes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isGift: json['isGift'] as bool? ?? false,
    );

Map<String, dynamic> _$LineResultDtoToJson(LineResultDto instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'variantId': instance.variantId,
      'qty': instance.qty,
      'unitPrice': instance.unitPrice,
      'gross': instance.gross,
      'discount': instance.discount,
      'net': instance.net,
      'appliedCodes': instance.appliedCodes,
      'isGift': instance.isGift,
    };

PricePreviewDto _$PricePreviewDtoFromJson(Map<String, dynamic> json) =>
    PricePreviewDto(
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => LineResultDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      appliedCodes: (json['appliedCodes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PricePreviewDtoToJson(PricePreviewDto instance) =>
    <String, dynamic>{
      'lines': instance.lines,
      'subtotal': instance.subtotal,
      'totalDiscount': instance.totalDiscount,
      'total': instance.total,
      'appliedCodes': instance.appliedCodes,
    };
