import 'package:json_annotation/json_annotation.dart';

part 'register_request_body.g.dart';

/// POST /api/v1/auth/register — customer self-registration.
@JsonSerializable(createFactory: false)
class RegisterRequestBody {
  const RegisterRequestBody({
    required this.fullName,
    required this.phone,
    required this.password,
    this.email,
  });

  final String fullName;
  final String phone;
  final String password;
  final String? email;

  Map<String, dynamic> toJson() => _$RegisterRequestBodyToJson(this);
}
