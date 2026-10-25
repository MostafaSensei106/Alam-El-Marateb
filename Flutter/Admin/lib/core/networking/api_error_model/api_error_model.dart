import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  const ApiErrorModel({
    required this.success,
    required this.message,
    required this.errors,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  @JsonKey(defaultValue: false)
  final bool success;
  @JsonKey(defaultValue: 'An unexpected error occurred.')
  final String message;

  /// Field-level validation errors, when the backend provides them.
  ///
  /// Absent from some error payloads, so it defaults to an empty list instead
  /// of failing the whole decode.
  @JsonKey(defaultValue: <String>[])
  final List<String> errors;
}
