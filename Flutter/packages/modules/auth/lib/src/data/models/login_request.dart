/// Login request body (serializes to the backend's expected shape).
final class LoginRequest {
  const LoginRequest({required this.identifier, required this.password});

  final String identifier;
  final String password;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'password': password,
  };
}
