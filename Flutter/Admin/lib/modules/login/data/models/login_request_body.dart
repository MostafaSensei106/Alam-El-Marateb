import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
final class LoginRequestBody(@JsonKey(name: 'phone') final String phone , @JsonKey(name: 'password') final String password) {
Map<String, String> toJson => _$LoginRequestBodyToJson(this);
}
