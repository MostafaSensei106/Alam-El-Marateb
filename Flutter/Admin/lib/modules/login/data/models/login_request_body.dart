import 'package:json_annotation/json_annotation.dart';

part 'login_request_body.g.dart';

@JsonSerializable()
final class LoginRequestBody {
  const LoginRequestBody({required this.phone, required this.password});
  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'password')
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestBodyToJson(this);
}
