import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_body.g.dart';

@JsonSerializable()
final class RefreshTokenRequestBody {
  const RefreshTokenRequestBody({required this.token});

  factory RefreshTokenRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestBodyFromJson(json);

  final String token;

  Map<String, dynamic> toJson() => _$RefreshTokenRequestBodyToJson(this);
}
