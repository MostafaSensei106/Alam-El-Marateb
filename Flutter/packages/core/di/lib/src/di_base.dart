import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service locator for core packages.
///
/// Each app calls [configureCoreDependencies] during boot, then registers
/// its own feature dependencies. Domain-specific resets (cart, wishlist,
/// …) live in `packages/modules/*`, never here — this package stays
/// domain-free so a bug fix propagates to all apps from one place.
final GetIt getIt = GetIt.instance;

/// Registers every core singleton.
///
/// Order matters: storage → security → connectivity → state.
/// Idempotent — safe to call once per app boot (asserts in debug if
/// called twice without [resetCoreDependencies]).
///
/// NOTE: Firebase itself (`Firebase.initializeApp`) is app-owned and must
/// run BEFORE this when the app uses notifications/crashlytics — the
/// caller passes nothing; this function never touches Firebase.
Future<void> configureCoreDependencies() async {
  // ── Platform primitives (async factories) ──────────────────────────
  final prefs = await SharedPreferences.getInstance();
  final packageInfo = await PackageInfo.fromPlatform();
  const secureStorage = FlutterSecureStorage();
  final connectivity = Connectivity();

  // ── Storage ────────────────────────────────────────────────────────
  getIt
    ..registerLazySingleton<SharedPrefsService>(
      () => SharedPrefsService(prefs),
    )
    ..registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(secureStorage),
    )
    ..registerLazySingleton<PrefStorageServiceBase>(
      () => StorageFacade(getIt(), getIt()),
    )
    ..registerLazySingleton<UserSessionServiceBase>(
      () => UserSessionService(getIt()),
    )
    ..registerLazySingleton<BasePackageInfoAdapter>(
      () => PackageInfoPlusAdapter(packageInfo),
    )
    ..registerLazySingleton<BaseAppInfoService>(
      () => AppInfoService(getIt()),
    );

  // ── Security ───────────────────────────────────────────────────────
  getIt
    ..registerLazySingleton<BaseAuditLogger>(() => const AppAuditLogger())
    ..registerLazySingleton<BaseSecureVaultService>(
      () => SecureVaultService(secureStorage, getIt()),
    )
    ..registerLazySingleton<BaseClipboardGuardService>(
      () => ClipboardGuardService(getIt()),
    );

  // ── Connectivity ───────────────────────────────────────────────────
  getIt
    ..registerLazySingleton<BaseNetworkInfo>(
      () => NetworkInfo(connectivity),
    )
    ..registerLazySingleton<NetworkCubit>(
      () => NetworkCubit(getIt()),
    )
    ..registerLazySingleton<CacheManager>(() => CacheManager());

  // ── Theme & localization ───────────────────────────────────────────
  getIt
    ..registerLazySingleton<BaseThemeRepository>(
      () => ThemeRepository(getIt()),
    )
    ..registerLazySingleton<ThemeCubit>(() => ThemeCubit(getIt()))
    ..registerLazySingleton<LocalizationRepositoryBase>(
      () => LocalizationRepository(getIt()),
    )
    ..registerLazySingleton<LocalizationCubit>(
      () => LocalizationCubit(getIt()),
    );
}

/// Clears all core registrations (tests, logout-driving restarts).
Future<void> resetCoreDependencies() async => getIt.reset();
