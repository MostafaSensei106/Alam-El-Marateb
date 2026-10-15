import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:get_it/get_it.dart';

/// Global service locator for core packages.
///
/// Each app calls [configureCoreDependencies] during boot, then registers
/// its own feature dependencies. Domain-specific resets (cart, wishlist,
/// …) live in `packages/modules/*`, never here — this package stays
/// domain-free so a bug fix propagates to all apps from one place.
final GetIt getIt = GetIt.instance;

/// Registers every core singleton via generated injectable configs.
///
/// Order: services → network → utils (each config only resolves types the
/// previous configs registered). The two notification services take
/// optional app callbacks, so codegen skips them — they are registered
/// manually right after, with defaults.
///
/// Idempotent per process (hot restart safe).
Future<void> configureCoreDependencies() async {
  if (getIt.isRegistered<PrefStorageServiceBase>()) return;

  await initServices(getIt);
  initNetwork(getIt);
  initUtils(getIt);

  // ── Manual (codegen-excluded: optional app callbacks) ──────────────
  if (!getIt.isRegistered<BaseLocalNotificationService>()) {
    getIt.registerLazySingleton<BaseLocalNotificationService>(
      () => LocalNotificationService(),
    );
  }
  if (!getIt.isRegistered<BaseNotificationService>()) {
    getIt.registerLazySingleton<BaseNotificationService>(
      () => FirebaseNotificationService(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    );
  }
}

/// Clears all core registrations (tests, logout-driving restarts).
Future<void> resetCoreDependencies() async => getIt.reset();
