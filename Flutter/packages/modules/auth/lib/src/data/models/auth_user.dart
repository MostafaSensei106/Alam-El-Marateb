import 'package:json_annotation/json_annotation.dart';

part 'auth_user.g.dart';

/// Backend AuthUserView: GET /api/v1/auth/me.
@JsonSerializable()
class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.branchId,
    this.roles = const <String>[],
    this.isActive = true,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  /// Never null for an authenticated session: /auth/me always resolves
  /// a real user. Non-nullable by design — no null-checks downstream.
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? branchId;
  final List<String> roles;
  final bool isActive;

  bool hasRole(String role) => roles.contains(role);
  bool get isSuperAdmin => hasRole('ROLE_SUPER_ADMIN');
}
