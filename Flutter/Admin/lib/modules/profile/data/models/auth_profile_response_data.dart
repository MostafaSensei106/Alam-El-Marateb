import 'package:json_annotation/json_annotation.dart';

import '../../logic/entity/profile_entity.dart';

part 'auth_profile_response_data.g.dart';

@JsonSerializable()
final class AuthProfileResponseData {
  const AuthProfileResponseData({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.branchId,
    required this.roles,
    required this.active,
  });

  /// From json
  factory AuthProfileResponseData.fromJson(Map<String, dynamic> json) =>
      _$AuthProfileResponseDataFromJson(json);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'fullName')
  final String fullName;
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'branchId')
  final String branchId;
  @JsonKey(name: 'roles')
  final List<String> roles;
  @JsonKey(name: 'active')
  final bool active;

  /// To Json
  Map<String, dynamic> toJson() => _$AuthProfileResponseDataToJson(this);
}

extension AuthProfileX on AuthProfileResponseData {
  ProfileEntity toEntity() {
    return ProfileEntity(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      roles: roles,
    );
  }
}
