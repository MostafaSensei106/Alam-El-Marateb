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

  final bool? success;
  @JsonKey(defaultValue: 'An unexpected error occurred.')
  final String message;
  final List<String> errors;
}
