/// Login request body — matches the backend `LoginRequest{phone, password}`.
final class LoginRequest {
  const LoginRequest({required this.phone, required this.password});

  final String phone;
  final String password;

  Map<String, dynamic> toJson() => {'phone': phone, 'password': password};
}
