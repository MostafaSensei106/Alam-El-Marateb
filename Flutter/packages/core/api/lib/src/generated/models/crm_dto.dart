import 'package:json_annotation/json_annotation.dart';

part 'crm_dto.g.dart';

/// Backend `ProfileView(userId, governorate, city, segment,
/// referralSource, birthDate)`.
@JsonSerializable()
final class ProfileDto {
  const ProfileDto({
    this.userId = '',
    this.governorate,
    this.city,
    this.segment = '',
    this.referralSource,
    this.birthDate,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);

  final String userId;
  final String? governorate;
  final String? city;
  final String segment;
  final String? referralSource;
  final String? birthDate;
}

/// Backend `AddressView`.
@JsonSerializable()
final class AddressDto {
  const AddressDto({
    this.id,
    this.label = '',
    this.phone = '',
    this.governorate = '',
    this.addressText = '',
    this.isDefault = false,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);

  final String? id;
  final String label;
  final String phone;
  final String governorate;
  final String addressText;
  final bool isDefault;
}

/// Backend `WarrantyView(id, invoiceId, coversUntil, status, valid)`.
@JsonSerializable()
final class WarrantyDto {
  const WarrantyDto({
    this.id,
    this.invoiceId,
    this.coversUntil,
    this.status = '',
    this.valid = false,
  });

  factory WarrantyDto.fromJson(Map<String, dynamic> json) =>
      _$WarrantyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WarrantyDtoToJson(this);

  final String? id;
  final String? invoiceId;
  final String? coversUntil;
  final String status;
  final bool valid;
}

/// Backend `ClaimView`.
@JsonSerializable()
final class ClaimDto {
  const ClaimDto({
    this.id,
    this.warrantyId,
    this.status = '',
    this.description = '',
    this.inspectionAt,
    this.resolution,
  });

  factory ClaimDto.fromJson(Map<String, dynamic> json) =>
      _$ClaimDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ClaimDtoToJson(this);

  final String? id;
  final String? warrantyId;
  final String status;
  final String description;
  final String? inspectionAt;
  final String? resolution;
}

/// Backend `LoyaltyBalance(points, lifetimeEarned)`.
@JsonSerializable()
final class LoyaltyBalanceDto {
  const LoyaltyBalanceDto({this.points = 0, this.lifetimeEarned = 0});

  factory LoyaltyBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyBalanceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyBalanceDtoToJson(this);

  final int points;
  final int lifetimeEarned;
}

/// Backend `LoyaltyEntry(orderId, delta, reason, balanceAfter, at)`.
@JsonSerializable()
final class LoyaltyEntryDto {
  const LoyaltyEntryDto({
    this.orderId,
    this.delta = 0,
    this.reason = '',
    this.balanceAfter = 0,
    this.at,
  });

  factory LoyaltyEntryDto.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyEntryDtoToJson(this);

  final String? orderId;
  final int delta;
  final String reason;
  final int balanceAfter;
  final String? at;
}

/// Backend `LoyaltyQuoteResponse(points, discount)`.
@JsonSerializable()
final class LoyaltyQuoteDto {
  const LoyaltyQuoteDto({this.points = 0, this.discount = 0.0});

  factory LoyaltyQuoteDto.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyQuoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyQuoteDtoToJson(this);

  final int points;
  final double discount;
}
