/// Backend response envelope: {success, message, data?, errors?}.
///
/// Nothing else ever arrives in the body (no timestamps, no trace ids —
/// correlation travels in the `X-Trace-Id` response header).
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors = const <String>[],
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromData,
  ) {
    final errors = json['errors'];
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json.containsKey('data') && json['data'] != null
          ? fromData(json['data'])
          : null,
      errors: errors is List
          ? errors.map((e) => e.toString()).toList()
          : const <String>[],
    );
  }

  final bool success;
  final String message;
  final T? data;
  final List<String> errors;

  bool get isOk => success && data != null;
}
