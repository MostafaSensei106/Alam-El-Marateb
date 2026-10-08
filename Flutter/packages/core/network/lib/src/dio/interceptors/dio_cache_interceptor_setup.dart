import 'dart:io';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:path_provider/path_provider.dart';

Future<List<Interceptor>> createCacheInterceptors() async {
  final appCacheDirectory = await getApplicationCacheDirectory();
  final dioCacheDirectory = Directory('${appCacheDirectory.path}/dio_cache');

  if (!await dioCacheDirectory.exists()) {
    await dioCacheDirectory.create();
  }

  final cacheStore = HiveCacheStore(dioCacheDirectory.path);

  final cacheOptions = CacheOptions(
    store: cacheStore,
    policy: CachePolicy.refreshForceCache,
    maxStale: ApplicationDuration.
  );
}
