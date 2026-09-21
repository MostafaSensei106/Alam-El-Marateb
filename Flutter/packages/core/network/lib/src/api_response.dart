/// Typed envelope matching the backend `ApiResponse<T>`.
///
/// Backend shape (Kotlin `ApiResponse`):
/// ```json
/// {
///   "success": true,
///   "message": "...",
///   "data": {...},
///   "errors": ["..."],
///   "traceId": "abc123",
///   "timestamp": "2026-09-20T14:32:00Z"
/// }
/// ```
///
/// Notes:
/// - `timestamp` and `traceId` are metadata only: never use them for ETag
///   hashing or business logic (backend computes stable ETags without them).
/// - `errors` is `List<String>` on this backend. For forward-compat with
///   Hadidi-style `Map<String, List<String>>` bodies, both are accepted and
///   normalized to a flat list.
final class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors = const [],
    this.traceId,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? data) fromData,
  ) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json.containsKey('data') && json['data'] != null
          ? fromData(json['data'])
          : null,
      errors: _parseErrors(json['errors']),
      traceId: json['traceId'] as String?,
      timestamp: json['timestamp'] as String?,
    );
  }

  final bool success;
  final String message;
  final T? data;
  final List<String> errors;
  final String? traceId;
  final String? timestamp;

  static List<String> _parseErrors(Object? raw) {
    if (raw == null) return const [];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is Map) {
      return raw.values
          .expand((v) => v is List ? v : [v])
          .map((e) => e.toString())
          .toList();
    }
    return [raw.toString()];
  }
}

/// Paginated wrapper matching backend `PagedResponse<T>`.
final class PagedResponse<T> {
  const PagedResponse({
    required this.items,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> item) fromItem,
  ) {
    final rawItems = json['items'] as List? ?? const [];
    return PagedResponse(
      items: rawItems
          .map((e) => fromItem(Map<String, dynamic>.from(e as Map)))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? rawItems.length,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? rawItems.length,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  final List<T> items;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  bool get hasMore => page + 1 < totalPages;
}
