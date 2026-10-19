import 'package:bloc_signals_hydrate/bloc_signals_hydrate.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../networking/dio_cache_interceptor_setup.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(generateAccessors: true)
Future<void> configureDependencies({String? cacheStoragePath}) async {
  if (cacheStoragePath != null &&
      !getIt.isRegistered<String>(instanceName: CacheConfig.diInstanceName)) {
    getIt.registerSingleton<String>(
      cacheStoragePath,
      instanceName: CacheConfig.diInstanceName,
    );
  }
  await getIt.init();
}

Future<void> resetUserSession() async {
  // Clear hydrated bloc states for session-specific cubits from disk
  try {
    final storage = HydratedBlocSignal.storage;
    await Future.wait([]);
  } catch (_) {
    // Catch when storage is not initialized (e.g. in unit tests)
  }
}
