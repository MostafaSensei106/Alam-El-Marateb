import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

/// Mirrors the backend's global envelope `ApiResponse{success,message,data,errors}`
/// where `errors` is a flat `List<String>` (validation / domain failures).
@JsonSerializable()
class ApiErrorModel {
  const ApiErrorModel({
    required this.success,
    required this.message,
    this.errors,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  final bool? success;
  @JsonKey(defaultValue: 'An unexpected error occurred.')
  final String message;
  final List<String>? errors;
}
