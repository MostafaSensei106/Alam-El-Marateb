import 'package:dio/dio.dart';

/// Conditional-GET caching via stable ETags.
///
/// The backend emits ETags **only on allowlisted endpoints** (public
/// catalog, branches, roles…) and computes them over the stable payload
/// (excluding `traceId`/`timestamp`). Flow:
/// - GET to an allowlisted path with a stored ETag → send `If-None-Match`.
/// - `304 Not Modified` → resolve from the in-memory body cache (zero
///   transfer, sub-millisecond).
/// - `200 + ETag header` → store tag + body.
///
/// Paginated endpoints (`?page=` / `?cursor=`) are excluded: pages change
/// independently and must never be served stale.
final class EtagInterceptor extends Interceptor {
  EtagInterceptor({this.allowlistedPaths = defaultAllowlistedPaths});

  /// Substring match (lowercase) against the request path.
  final List<String> allowlistedPaths;

  static const defaultAllowlistedPaths = [
    '/catalog/public/',
    '/identity/branches',
    '/identity/access/roles',
    '/catalog/categories',
    '/catalog/brands',
  ];

  final Map<String, String> _etags = {};
  final Map<String, dynamic> _bodies = {};

  bool _eligible(RequestOptions options) {
    if (options.method.toUpperCase() != 'GET') return false;
    if (options.queryParameters.containsKey('page') ||
        options.queryParameters.containsKey('cursor')) {
      return false;
    }
    final path = options.path.toLowerCase();
    return allowlistedPaths.any(path.contains);
  }

  String _key(RequestOptions options) {
    final query = options.queryParameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '${options.path}?$query';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_eligible(options)) {
      final etag = _etags[_key(options)];
      if (etag != null) {
        options.headers['If-None-Match'] = etag;
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_eligible(response.requestOptions)) {
      final etag = response.headers['ETag']?.firstOrNull ??
          response.headers['Etag']?.firstOrNull;
      if (etag != null) {
        final key = _key(response.requestOptions);
        _etags[key] = etag;
        _bodies[key] = response.data;
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Dio treats 304 as an error (outside 200-299): serve from cache.
    if (err.response?.statusCode == 304) {
      final key = _key(err.requestOptions);
      final cached = _bodies[key];
      if (cached != null) {
        return handler.resolve(
          Response<dynamic>(
            requestOptions: err.requestOptions,
            statusCode: 200,
            data: cached,
          ),
        );
      }
    }
    handler.next(err);
  }

  void invalidate([String? pathContains]) {
    if (pathContains == null) {
      _etags.clear();
      _bodies.clear();
      return;
    }
    final needle = pathContains.toLowerCase();
    _etags.removeWhere((k, _) => k.toLowerCase().contains(needle));
    _bodies.removeWhere((k, _) => k.toLowerCase().contains(needle));
  }
}
