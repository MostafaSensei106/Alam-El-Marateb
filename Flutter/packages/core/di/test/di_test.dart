import 'package:alam_el_marateb_di/di.dart';
import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  group('Core DI', () {
    test('getIt is a singleton', () {
      expect(identical(getIt, getIt), isTrue);
    });

    test('configureCoreDependencies registers the core graph', () async {
      await configureCoreDependencies();

      expect(getIt.isRegistered<PrefStorageServiceBase>(), isTrue);
      expect(getIt.isRegistered<UserSessionServiceBase>(), isTrue);
      expect(getIt.isRegistered<BaseAppInfoService>(), isTrue);
      expect(getIt.isRegistered<BaseAuditLogger>(), isTrue);
      expect(getIt.isRegistered<BaseSecureVaultService>(), isTrue);
      expect(getIt.isRegistered<BaseClipboardGuardService>(), isTrue);
      expect(getIt.isRegistered<BaseNetworkInfo>(), isTrue);
      expect(getIt.isRegistered<NetworkCubit>(), isTrue);
      expect(getIt.isRegistered<CacheManager>(), isTrue);
      expect(getIt.isRegistered<BaseThemeRepository>(), isTrue);
      expect(getIt.isRegistered<ThemeCubit>(), isTrue);
      expect(getIt.isRegistered<LocalizationRepositoryBase>(), isTrue);
      expect(getIt.isRegistered<LocalizationCubit>(), isTrue);

      // Cubits resolve with their repositories wired
      expect(getIt<ThemeCubit>().stateValue.themeMode, isNotNull);
    });
  });
}
