import 'package:alam_el_marateb_di/di.dart';
import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Full service-locator boot proof: runs the exact production boot sequence
/// (core DI → authenticated Dio → attachment → auth module) and resolves
/// EVERY registered type. A missing provider fails here — not on device.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'test',
      packageName: 'com.test',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: 'test',
    );
    await resetCoreDependencies();
  });

  tearDown(() async {
    await resetCoreDependencies();
  });

  test('production boot registers the whole graph', () async {
    await configureCoreDependencies();
    final dio = await buildAuthenticatedDio(clientName: 'customer-app');
    registerAttachmentService(dio);
    await registerAuthModule(dio: dio, allowedRoles: AppRoles.customerApp);

    // ── services (codegen) ──
    expect(getIt<SharedPrefsService>(), isA<SharedPrefsService>());
    expect(getIt<SecureStorageService>(), isA<SecureStorageService>());
    expect(getIt<PrefStorageServiceBase>(), isA<StorageFacade>());
    expect(getIt<BasePackageInfoAdapter>(), isA<PackageInfoPlusAdapter>());
    expect(getIt<BaseAppInfoService>(), isA<AppInfoService>());
    expect(getIt<BaseAuditLogger>(), isA<AppAuditLogger>());
    expect(getIt<BaseSecureVaultService>(), isA<SecureVaultService>());
    expect(getIt<BaseClipboardGuardService>(), isA<ClipboardGuardService>());
    expect(getIt<PermissionServiceBase>(), isA<PermissionHandlerService>());
    expect(getIt<BaseUrlLauncherServices>(), isA<UrlLauncherService>());
    expect(getIt<BaseFileOpenerService>(), isA<UrlFileOpenerService>());
    expect(getIt<BaseShareService>(), isA<SharePlusService>());
    expect(getIt<ThemeService>(), isA<ThemeService>());
    expect(getIt<ToastServiceBase>(), isA<ToastificationService>());
    // ── services (manual: optional callbacks) ──
    expect(
      getIt<BaseLocalNotificationService>(),
      isA<LocalNotificationService>(),
    );
    expect(
      getIt<BaseNotificationService>(),
      isA<FirebaseNotificationService>(),
    );
    // ── services (manual: app Dio) ──
    expect(
      getIt<BaseAttachmentHandlerService>(),
      isA<AttachmentHandlerService>(),
    );

    // ── network (codegen) ──
    expect(getIt<BaseNetworkInfo>(), isA<NetworkInfo>());
    expect(getIt<NetworkCubit>(), isA<NetworkCubit>());

    // ── utils (codegen) ──
    expect(getIt<BaseThemeRepository>(), isA<ThemeRepository>());
    expect(getIt<ThemeCubit>(), isA<ThemeCubit>());
    expect(getIt<LocalizationRepositoryBase>(), isA<LocalizationRepository>());
    expect(getIt<LocalizationCubit>(), isA<LocalizationCubit>());
    expect(getIt<CacheManager>(), isA<CacheManager>());

    // ── auth (manual api+repo, codegen usecases+cubit) ──
    expect(getIt<AuthApiService>(), isA<AuthApiService>());
    expect(getIt<AuthRepository>(), isA<AuthRepositoryImpl>());
    expect(getIt<LoginUseCase>(), isA<LoginUseCase>());
    expect(getIt<LogoutUseCase>(), isA<LogoutUseCase>());
    expect(getIt<AuthCubit>(), isA<AuthCubit>());

    // ── Dio stack assembled once ──
    expect(dio.interceptors.whereType<DioClientKeyInterceptor>().length, 1);
    expect(dio.interceptors.whereType<DioTokenInterceptor>().length, 1);

    // ── session round-trip through the real graph ──
    final session = getIt<UserSessionServiceBase>();
    expect(await session.isAuthenticated(), isFalse);
    await session.saveUserSession(token: 't', rememberMe: true);
    expect(await session.isAuthenticated(), isTrue);
    expect(await session.getToken(), 't');
  });
}
