import 'package:json_annotation/json_annotation.dart';

part 'refresh_request_body.g.dart';

/// POST /api/v1/auth/refresh.
@JsonSerializable(createFactory: false)
class RefreshRequestBody {
  const RefreshRequestBody({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => _$RefreshRequestBodyToJson(this);
}
