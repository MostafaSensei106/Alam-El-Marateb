import 'package:json_annotation/json_annotation.dart';

part 'login_response_data.g.dart';

@JsonSerializable()
final class LoginResponseData {
  const LoginResponseData({
    required this.refreshToken,
    required this.userId,
    required this.accessToken,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);

  final String accessToken;
  final String refreshToken;
  final String userId;
}
