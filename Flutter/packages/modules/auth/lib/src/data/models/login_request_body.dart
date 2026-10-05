import 'package:json_annotation/json_annotation.dart';

part 'login_request_body.g.dart';

/// POST /api/v1/auth/login — no auth header (extra authRequired=false).
@JsonSerializable(createFactory: false)
class LoginRequestBody {
  const LoginRequestBody({required this.phone, required this.password});

  final String phone;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestBodyToJson(this);
}
