import 'package:json_annotation/json_annotation.dart';

part 'payloads.g.dart';

/// Stands in for `T` when an endpoint only returns a message
/// (backend `ApiResponse<Nothing>` serializes with absent `data`).
@JsonSerializable(createToJson: false)
final class EmptyDto {
  const EmptyDto();

  factory EmptyDto.fromJson(Map<String, dynamic> json) =>
      _$EmptyDtoFromJson(json);
}
