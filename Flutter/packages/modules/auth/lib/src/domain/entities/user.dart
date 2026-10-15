/// Authenticated user (domain entity — no json, no framework).
final class User {
  const User({required this.id, required this.name, this.email, this.phone});

  final String id;
  final String name;
  final String? email;
  final String? phone;
}
