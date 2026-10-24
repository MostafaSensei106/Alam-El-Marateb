import 'package:json_annotation/json_annotation.dart';

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
}
