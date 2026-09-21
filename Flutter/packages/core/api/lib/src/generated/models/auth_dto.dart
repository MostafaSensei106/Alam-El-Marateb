import 'package:json_annotation/json_annotation.dart';

part 'auth_dto.g.dart';

/// Backend `TokenPair(accessToken, refreshToken, userId)`.
@JsonSerializable()
final class TokenPairDto {
  const TokenPairDto({
    this.accessToken = '',
    this.refreshToken = '',
    this.userId = '',
  });

  factory TokenPairDto.fromJson(Map<String, dynamic> json) =>
      _$TokenPairDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenPairDtoToJson(this);

  final String accessToken;
  final String refreshToken;
  final String userId;
}

/// Backend `AuthUserView(id, fullName, phoneNumber, email, branchId,
/// roles, isActive)`.
@JsonSerializable()
final class AuthUserDto {
  const AuthUserDto({
    this.id = '',
    this.fullName = '',
    this.phoneNumber = '',
    this.email,
    this.branchId,
    this.roles = const [],
    this.isActive = true,
  });

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserDtoToJson(this);

  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? branchId;
  final List<String> roles;
  final bool isActive;

  bool hasRole(String role) => roles.contains(role);
  bool get isStaff =>
      roles.any((r) => r != 'ROLE_CUSTOMER' && r.startsWith('ROLE_'));
}
