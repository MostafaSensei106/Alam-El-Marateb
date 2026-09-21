// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crm_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
      userId: json['userId'] as String? ?? '',
      governorate: json['governorate'] as String?,
      city: json['city'] as String?,
      segment: json['segment'] as String? ?? '',
      referralSource: json['referralSource'] as String?,
      birthDate: json['birthDate'] as String?,
    );

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'governorate': instance.governorate,
      'city': instance.city,
      'segment': instance.segment,
      'referralSource': instance.referralSource,
      'birthDate': instance.birthDate,
    };

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) => AddressDto(
      id: json['id'] as String?,
      label: json['label'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      addressText: json['addressText'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$AddressDtoToJson(AddressDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'phone': instance.phone,
      'governorate': instance.governorate,
      'addressText': instance.addressText,
      'isDefault': instance.isDefault,
    };

WarrantyDto _$WarrantyDtoFromJson(Map<String, dynamic> json) => WarrantyDto(
      id: json['id'] as String?,
      invoiceId: json['invoiceId'] as String?,
      coversUntil: json['coversUntil'] as String?,
      status: json['status'] as String? ?? '',
      valid: json['valid'] as bool? ?? false,
    );

Map<String, dynamic> _$WarrantyDtoToJson(WarrantyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceId': instance.invoiceId,
      'coversUntil': instance.coversUntil,
      'status': instance.status,
      'valid': instance.valid,
    };

ClaimDto _$ClaimDtoFromJson(Map<String, dynamic> json) => ClaimDto(
      id: json['id'] as String?,
      warrantyId: json['warrantyId'] as String?,
      status: json['status'] as String? ?? '',
      description: json['description'] as String? ?? '',
      inspectionAt: json['inspectionAt'] as String?,
      resolution: json['resolution'] as String?,
    );

Map<String, dynamic> _$ClaimDtoToJson(ClaimDto instance) => <String, dynamic>{
      'id': instance.id,
      'warrantyId': instance.warrantyId,
      'status': instance.status,
      'description': instance.description,
      'inspectionAt': instance.inspectionAt,
      'resolution': instance.resolution,
    };

LoyaltyBalanceDto _$LoyaltyBalanceDtoFromJson(Map<String, dynamic> json) =>
    LoyaltyBalanceDto(
      points: (json['points'] as num?)?.toInt() ?? 0,
      lifetimeEarned: (json['lifetimeEarned'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LoyaltyBalanceDtoToJson(LoyaltyBalanceDto instance) =>
    <String, dynamic>{
      'points': instance.points,
      'lifetimeEarned': instance.lifetimeEarned,
    };

LoyaltyEntryDto _$LoyaltyEntryDtoFromJson(Map<String, dynamic> json) =>
    LoyaltyEntryDto(
      orderId: json['orderId'] as String?,
      delta: (json['delta'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String? ?? '',
      balanceAfter: (json['balanceAfter'] as num?)?.toInt() ?? 0,
      at: json['at'] as String?,
    );

Map<String, dynamic> _$LoyaltyEntryDtoToJson(LoyaltyEntryDto instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'delta': instance.delta,
      'reason': instance.reason,
      'balanceAfter': instance.balanceAfter,
      'at': instance.at,
    };

LoyaltyQuoteDto _$LoyaltyQuoteDtoFromJson(Map<String, dynamic> json) =>
    LoyaltyQuoteDto(
      points: (json['points'] as num?)?.toInt() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$LoyaltyQuoteDtoToJson(LoyaltyQuoteDto instance) =>
    <String, dynamic>{
      'points': instance.points,
      'discount': instance.discount,
    };
