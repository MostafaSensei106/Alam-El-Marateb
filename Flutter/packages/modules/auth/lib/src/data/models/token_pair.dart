import 'package:json_annotation/json_annotation.dart';

part 'token_pair.g.dart';

/// Backend TokenPair: {accessToken, refreshToken, userId}.
@JsonSerializable()
class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);

  Map<String, dynamic> toJson() => _$TokenPairToJson(this);

  final String accessToken;
  final String refreshToken;
  final String userId;
}
