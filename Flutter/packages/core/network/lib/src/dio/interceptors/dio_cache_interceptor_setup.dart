import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';

/// Single source of truth for Dio HTTP caching.
///
/// Contract:
/// - Online  -> network (`refreshForceCache`: always fetch, always store).
/// - Offline / network failure -> last cached response, if any
///   (`hitCacheOnNetworkFailure: true`).
/// - HTTP errors (401/403/500, ...) -> real server answer, never stale
///   (`hitCacheOnErrorCodes` intentionally stays empty).
/// - Only GET responses are cached (enforced by [DioCacheInterceptor]
///   itself, so no method checks are needed here).
/// - Per-request opt-out (e.g. pagination) lives in the repository layer
///   via [noCacheExtra] passed as Retrofit `@Extras()` — never as
///   hardcoded query-param sniffing inside an interceptor.
abstract class CacheConfig {
  /// GetIt instance name under which [SysInit] registers the pre-resolved
  /// cache directory path before DI boots.
  static const diInstanceName = 'dioCachePath';

  /// Synchronous interceptor factory: no I/O, no connectivity checks,
  /// no business-logic coupling. The [storagePath] is resolved once at
  /// startup (see `SysInit.initializeCriticalServices`), so the Hive box
  static DioCacheInterceptor createInterceptor({required String storagePath}) {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(storagePath),
      // Online default: always hit network, persist every successful GET.
      // Offline/network failure falls back to cache via
      // [CacheOptions.hitCacheOnNetworkFailure].
      policy: CachePolicy.refreshForceCache,
      hitCacheOnNetworkFailure: true,
      maxStale: ApplicationDuration.maxCacheStaleExtraShort,
    );

    return DioCacheInterceptor(options: cacheOptions);
  }

  /// Opt-out helper for repositories: pass the result as Retrofit
  /// `@Extras()` when a request must bypass the cache entirely.
  ///
  /// ```dart
  /// @GET('/posts')
  /// Future<List<PostModel>> getPosts(
  ///   @Query('page') int page, {
  ///   @Extras() Map<String, dynamic>? extras,
  /// });
  ///
  /// // repository:
  /// final extras = page > 1 ? CacheConfig.noCacheExtra() : null;
  /// await api.getPosts(page, extras: extras);
  /// ```
  static Map<String, dynamic> noCacheExtra() =>
      const CacheOptions(policy: CachePolicy.noCache, store: null).toExtra();
}
