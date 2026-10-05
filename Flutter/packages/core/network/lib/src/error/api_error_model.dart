/// Server error envelope mirror: {success, message, errors[]}.
/// Backend `errors` is a list of machine codes
/// (TOKEN_MISSING / TOKEN_EXPIRED / TOKEN_INVALID / CLIENT_REJECTED / ...).
class ApiErrorModel {
  const ApiErrorModel({
    required this.success,
    required this.message,
    this.errors = const <String>[],
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    final errors = json['errors'];
    return ApiErrorModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'An unexpected error occurred.',
      errors: errors is List
          ? errors.map((e) => e.toString()).toList()
          : const <String>[],
    );
  }

  final bool success;
  final String message;
  final List<String> errors;

  /// First machine code, if the backend sent any.
  String? get code => errors.isEmpty ? null : errors.first;
}
