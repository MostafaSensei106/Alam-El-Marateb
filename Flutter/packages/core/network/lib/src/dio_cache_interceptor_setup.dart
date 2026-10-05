import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:path_provider/path_provider.dart';

import 'network_info/interface/base_network_info.dart';

/// Golden cache contract:
///
/// - Online  -> network only (`refreshForceCache`: always fetch, always store).
///             Never serve stale automatically. Never fallback to cache on error.
/// - Offline -> cache only (`forceCache`: serve cache if present, else error).
///             The error surfaces as offline/empty, never as fake success.
///
/// Error fallback is intentionally disabled:
/// `hitCacheOnErrorCodes = []` and `hitCacheOnNetworkFailure = false`.
/// A 401/403/500 online is a real server answer -> Failure, not Success(cache).
Future<List<Interceptor>> createCacheInterceptors({
  required BaseBaseNetworkInfo networkInfo,
}) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final dioCacheDir = Directory('${appDocDir.path}/dio_cache');
  if (!await dioCacheDir.exists()) {
    await dioCacheDir.create(recursive: true);
  }

  final cacheStore = HiveCacheStore(dioCacheDir.path);

  final cacheOptions = CacheOptions(
    store: cacheStore,
    // Online default: always hit network, persist every successful GET.
    policy: CachePolicy.refreshForceCache,
    // Never fallback to cache on HTTP errors or network failures.
    // Offline is handled explicitly via forceCache policy below.
    maxStale: const Duration(days: 7),
  );

  // Decides per-request cache policy based on connectivity.
  // Runs BEFORE DioCacheInterceptor so the cache layer sees the final policy.
  final cachePolicyInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) async {
      final method = options.method.toUpperCase();
      final isCacheableMethod = method == 'GET';

      if (!isCacheableMethod) {
        options.extra.addAll(
          cacheOptions.copyWith(policy: CachePolicy.noCache).toExtra(),
        );
        return handler.next(options);
      }

      final isPaginated = _isPaginatedBeyondFirstPage(options);
      if (isPaginated) {
        // Pages > 1 are never cached and never served from cache.
        // Page 1 stays cacheable so offline still has a meaningful snapshot.
        options.extra.addAll(
          cacheOptions.copyWith(policy: CachePolicy.noCache).toExtra(),
        );
        return handler.next(options);
      }

      final hasConnection = await networkInfo.isConnected;
      if (!hasConnection) {
        // Offline: serve cache only. On miss DioCache forwards downstream
        // where the connectivity interceptor rejects with connectionError,
        // which the repository maps to Offline Failure / Empty.
        options.extra.addAll(
          cacheOptions.copyWith(policy: CachePolicy.forceCache).toExtra(),
        );
      } else {
        // Online: network only. No stale serve, no error fallback.
        options.extra.addAll(
          cacheOptions
              .copyWith(policy: CachePolicy.refreshForceCache)
              .toExtra(),
        );
      }

      handler.next(options);
    },
  );

  return [cachePolicyInterceptor, DioCacheInterceptor(options: cacheOptions)];
}

bool _isPaginatedBeyondFirstPage(RequestOptions options) {
  final params = options.queryParameters;
  final pageRaw = params['page'];
  if (pageRaw != null) {
    final page = int.tryParse(pageRaw.toString()) ?? 1;
    if (page > 1) return true;
  }
  // Cursor-based: any non-empty cursor means beyond the first page.
  if (params.containsKey('cursor')) {
    final cursor = params['cursor'];
    if (cursor != null && cursor.toString().isNotEmpty) return true;
  }
  return false;
}
