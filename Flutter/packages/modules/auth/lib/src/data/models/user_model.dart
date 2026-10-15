import 'package:alam_el_marateb_auth/alam_el_marateb_auth.dart';

/// Backend `TokenPair` from `/auth/login` and `/auth/refresh`.
final class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) {
    final root = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return TokenPair(
      accessToken: '${root['accessToken'] ?? ''}',
      refreshToken: '${root['refreshToken'] ?? ''}',
      userId: '${root['userId'] ?? ''}',
    );
  }

  final String accessToken;
  final String refreshToken;
  final String userId;

  bool get isComplete => accessToken.isNotEmpty && userId.isNotEmpty;
}

/// Backend `AuthUserView` from `GET /auth/me`.
final class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.roles,
    this.email,
    this.branchId,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return UserModel(
      id: '${root['id'] ?? ''}',
      fullName: '${root['fullName'] ?? ''}',
      phoneNumber: '${root['phoneNumber'] ?? ''}',
      email: root['email'] as String?,
      branchId: root['branchId'] as String?,
      roles: [for (final r in (root['roles'] as List? ?? const [])) '$r'],
      isActive: (root['isActive'] as bool?) ?? true,
    );
  }

  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? branchId;
  final List<String> roles;
  final bool isActive;

  User toEntity() => User(
    id: id,
    name: fullName,
    email: email,
    phone: phoneNumber,
    roles: roles,
  );
}
