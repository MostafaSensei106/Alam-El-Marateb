import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Normalizes the backend `errors` field: `List<String>` on this backend,
/// tolerating legacy `Map<String, List<String>>` bodies.
List<String> parseApiErrors(Object? raw) {
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

/// Typed envelope matching the backend `ApiResponse<T>`.
///
/// `timestamp` / `traceId` are metadata only (backend excludes them from
/// stable ETag hashes).
@JsonSerializable(genericArgumentFactories: true, createToJson: false)
final class ApiResponse<T> {
  const ApiResponse({
    this.success = false,
    this.message = '',
    this.data,
    this.errors = const [],
    this.traceId,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? data) fromData,
  ) => _$ApiResponseFromJson(json, fromData);

  final bool success;
  final String message;
  final T? data;

  @JsonKey(fromJson: parseApiErrors)
  final List<String> errors;

  final String? traceId;
  final String? timestamp;
}

/// Paginated wrapper matching backend `PagedResponse<T>`
/// (`items`, `page`, `size`, `totalElements`, `totalPages`).
@JsonSerializable(genericArgumentFactories: true, createToJson: false)
final class PagedResponse<T> {
  const PagedResponse({
    this.items = const [],
    this.page = 0,
    this.size = 0,
    this.totalElements = 0,
    this.totalPages = 0,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> item) fromItem,
  ) => _$PagedResponseFromJson(json, fromItem);

  final List<T> items;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  bool get hasMore => page + 1 < totalPages;
}
