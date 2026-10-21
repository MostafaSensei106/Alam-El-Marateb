import 'dart:convert';

import 'package:dio/dio.dart';

import '../../constants/api_routes.dart';
import '../../constants/types/type_def.dart';
import '../api_cache_interceptor_setup.dart';
import '../api_executor/api_executor.dart';

/// One page of rows returned by an admin list endpoint.
final class AdminPage {
  const AdminPage({
    required this.rows,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  final List<Map<String, Object?>> rows;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  bool get isEmpty => rows.isEmpty;

  static const empty = AdminPage(
    rows: <Map<String, Object?>>[],
    page: 0,
    size: 0,
    totalElements: 0,
    totalPages: 0,
  );
}

/// Thin, schema-agnostic client for the admin `/api/v1` surface.
///
/// The backend wraps every payload in `{success, message, data}` and paginates
/// with `{items, page, size, totalElements, totalPages}`. Rather than mirroring
/// hundreds of DTOs that the docs never fully describe, this client unwraps the
/// envelope once and hands the workspace generic maps that the section registry
/// knows how to label.
final class AdminApi {
  AdminApi(this._dio, {String? baseUrl})
    : _baseUrl = baseUrl ?? ApiRoutes.adminBaseURL;

  final Dio _dio;
  final String _baseUrl;

  /// Absolute admin API base used for every request.
  String get baseUrl => _baseUrl;

  /// Fetches one page for [path] (for example `/catalog/products`).
  Future<ApiResult<AdminPage>> fetchPage({
    required String path,
    Map<String, Object?> query = const <String, Object?>{},
    int page = 0,
    int size = 20,
  }) {
    return ApiExecutor.execute(
      action: () async {
        final response = await _dio.getUri<Object?>(
          _resolve(path),
          queryParameters: <String, Object?>{...query, 'page': page, 'size': size},
          options: Options(
            responseType: ResponseType.json,
            extra: CacheConfig.noCacheExtra(),
          ),
        );

        return _parsePage(
          response.data,
          requestedPage: page,
          requestedSize: size,
        );
      },
    );
  }

  Uri _resolve(String path) {
    final trimmed = path.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return Uri.parse(trimmed);
    }
    final base = _baseUrl.endsWith('/') ? _baseUrl : '$_baseUrl/';
    final relative = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return Uri.parse('$base$relative');
  }

  AdminPage _parsePage(
    Object? raw, {
    required int requestedPage,
    required int requestedSize,
  }) {
    final decoded = raw is String ? jsonDecode(raw) : raw;
    final root = _asMap(decoded);
    if (root == null) {
      throw const FormatException('Unexpected admin response shape.');
    }

    // `{success, message, data}` envelope, with a tolerant fallback for
    // endpoints that return the payload directly.
    final envelope = _asMap(root['data']);
    final payload = envelope ?? root;

    final rows = _extractRows(payload) ?? _extractRows(root) ?? const [];
    final pagination = <String, Object?>{...root, ...?envelope, ...payload};

    final size =
        _asInt(pagination['size']) ??
        _asInt(pagination['pageSize']) ??
        _asInt(pagination['numberOfElements']) ??
        (requestedSize > 0 ? requestedSize : rows.length);

    final totalElements =
        _asInt(pagination['totalElements']) ??
        _asInt(pagination['total']) ??
        _asInt(pagination['totalCount']) ??
        _asInt(pagination['count']) ??
        rows.length;

    final declaredTotalPages =
        _asInt(pagination['totalPages']) ??
        _asInt(pagination['pages']) ??
        _asInt(pagination['total_pages']);

    final totalPages =
        declaredTotalPages ??
        (size <= 0 ? 0 : (totalElements + size - 1) ~/ size);

    final page =
        _asInt(pagination['page']) ??
        _asInt(pagination['number']) ??
        _asInt(pagination['currentPage']) ??
        requestedPage;

    return AdminPage(
      rows: rows,
      page: page,
      size: size,
      totalElements: totalElements,
      totalPages: totalPages,
    );
  }

  static const _listKeys = <String>[
    'items',
    'content',
    'records',
    'results',
    'rows',
    'elements',
    'list',
    'data',
  ];

  Map<String, Object?>? _asMap(Object? value) {
    if (value is! Map) return null;
    return value.map(
      (key, entry) => MapEntry(key.toString(), entry as Object?),
    );
  }

  List<Map<String, Object?>>? _extractRows(Object? value) {
    if (value is List) {
      final rows = <Map<String, Object?>>[];
      for (final entry in value) {
        final map = _asMap(entry);
        if (map != null) rows.add(map);
      }
      return rows;
    }

    final map = _asMap(value);
    if (map == null) return null;

    for (final key in _listKeys) {
      final nested = map[key];
      if (nested is List) return _extractRows(nested);
    }

    // A single-resource payload (trip, shift, invoice, ...) still renders as
    // a one-row table instead of pretending the request failed.
    final looksLikeEntity = map.keys.any(
      (key) => key == 'id' || key == 'name' || key == 'code',
    );
    return looksLikeEntity ? [map] : null;
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
