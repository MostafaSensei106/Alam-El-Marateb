import 'dart:async';

import 'package:dio/dio.dart';

/// De-duplicates identical in-flight GETs: concurrent callers share one
/// network round-trip instead of firing N identical requests.
class RequestDeduplicator {
  RequestDeduplicator(this._dio);

  final Dio _dio;
  final Map<String, Future<Response<dynamic>>> _inFlight =
      <String, Future<Response<dynamic>>>{};

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    final key = _key(path, queryParameters);
    final existing = _inFlight[key];
    if (existing != null) {
      return existing;
    }
    final future = _dio
        .get<dynamic>(path, queryParameters: queryParameters, options: options)
        .whenComplete(() => _inFlight.remove(key));
    _inFlight[key] = future;
    return future;
  }

  String _key(String path, Map<String, dynamic>? query) {
    if (query == null || query.isEmpty) {
      return 'GET $path';
    }
    final sorted = query.keys.toList()..sort();
    final params = sorted.map((k) => '$k=${query[k]}').join('&');
    return 'GET $path?$params';
  }
}
