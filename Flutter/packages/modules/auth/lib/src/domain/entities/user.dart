/// Authenticated user (domain entity — no json, no framework).
final class User {
  const User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.roles = const [],
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;

  /// Backend `roles` from `/me` (e.g. `ROLE_CUSTOMER`). Used for per-app
  /// gating — see [AppRoles].
  final List<String> roles;
}
