import 'package:auth/src/domain/entities/user.dart';

/// Backend user payload.
///
/// Written with a manual `fromJson` (instead of codegen) to tolerate the
/// two common shapes: a bare user object, or `{data: {...}}` envelopes, and
/// `token` vs `access_token` naming. Tighten once the backend contract is
/// frozen.
final class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.token,
    this.email,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final userJson = root['user'] is Map<String, dynamic>
        ? root['user'] as Map<String, dynamic>
        : root;
    return UserModel(
      id: '${userJson['id'] ?? ''}',
      name: '${userJson['name'] ?? ''}',
      email: userJson['email'] as String?,
      phone: userJson['phone'] as String?,
      token:
          (root['token'] ?? root['access_token'] ?? userJson['token']) as String?,
    );
  }

  final String id;
  final String name;
  final String? email;
  final String? phone;

  /// Null when the backend nests the token elsewhere — the repository
  /// surfaces a parsing failure in that case.
  final String? token;

  User toEntity() =>
      User(id: id, name: name, email: email, phone: phone);
}
