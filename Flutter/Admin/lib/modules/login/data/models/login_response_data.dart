import 'package:json_annotation/json_annotation.dart';

import '../../logic/entity/user_entity.dart';

part 'login_response_data.g.dart';

@JsonSerializable()
final class LoginResponseData {
  const LoginResponseData({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);

  final String accessToken;
  final String refreshToken;
  final String userId;
}

extension LogenResposeX on LoginResponseData {
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      token: accessToken,
      refreshToken: refreshToken,
    );
  }
}
