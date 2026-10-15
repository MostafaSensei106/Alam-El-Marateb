// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:alam_el_marateb_services/src/app_info/app_info_service.dart'
    as _i30;
import 'package:alam_el_marateb_services/src/app_info/interface/base_app_info_service.dart'
    as _i906;
import 'package:alam_el_marateb_services/src/app_info/interface/base_package_info_adapter.dart'
    as _i329;
import 'package:alam_el_marateb_services/src/app_info/package_info_plus_adapter.dart'
    as _i532;
import 'package:alam_el_marateb_services/src/di/service_module.dart' as _i518;
import 'package:alam_el_marateb_services/src/file_opener/base_file_opener_service.dart'
    as _i156;
import 'package:alam_el_marateb_services/src/file_opener/url_file_opener_service.dart'
    as _i17;
import 'package:alam_el_marateb_services/src/permissions/permission_handler_service.dart'
    as _i527;
import 'package:alam_el_marateb_services/src/permissions/permission_service_base.dart'
    as _i379;
import 'package:alam_el_marateb_services/src/security/audit/app_audit_logger.dart'
    as _i96;
import 'package:alam_el_marateb_services/src/security/audit/base_audit_logger.dart'
    as _i219;
import 'package:alam_el_marateb_services/src/security/clipboard_guard_service.dart'
    as _i205;
import 'package:alam_el_marateb_services/src/security/secure_vault_service.dart'
    as _i554;
import 'package:alam_el_marateb_services/src/session/user_session_service.dart'
    as _i868;
import 'package:alam_el_marateb_services/src/session/user_session_service_base.dart'
    as _i134;
import 'package:alam_el_marateb_services/src/share/base_share_service.dart'
    as _i720;
import 'package:alam_el_marateb_services/src/share/share_plus_service.dart'
    as _i383;
import 'package:alam_el_marateb_services/src/shared_prefs/pref_storage_service_base.dart'
    as _i638;
import 'package:alam_el_marateb_services/src/shared_prefs/secure_storage_service.dart'
    as _i932;
import 'package:alam_el_marateb_services/src/shared_prefs/shared_prefs_service.dart'
    as _i415;
import 'package:alam_el_marateb_services/src/shared_prefs/storage_facade.dart'
    as _i656;
import 'package:alam_el_marateb_services/src/theme/theme_service.dart' as _i831;
import 'package:alam_el_marateb_services/src/toast/toast_service_base.dart'
    as _i664;
import 'package:alam_el_marateb_services/src/toast/toastification_service.dart'
    as _i618;
import 'package:alam_el_marateb_services/src/url_launcher/base_url_launcher_services.dart'
    as _i878;
import 'package:alam_el_marateb_services/src/url_launcher/url_launcher_service.dart'
    as _i846;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:share_plus/share_plus.dart' as _i998;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initServices({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final serviceModule = _$ServiceModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => serviceModule.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => serviceModule.packageInfo,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => serviceModule.secureStorage,
    );
    gh.lazySingleton<_i998.SharePlus>(() => serviceModule.sharePlus);
    gh.lazySingleton<_i892.FirebaseMessaging>(() => serviceModule.messaging);
    gh.lazySingleton<_i831.ThemeService>(() => _i831.ThemeService());
    gh.lazySingleton<_i219.BaseAuditLogger>(() => const _i96.AppAuditLogger());
    gh.lazySingleton<_i329.BasePackageInfoAdapter>(
      () => _i532.PackageInfoPlusAdapter(gh<_i655.PackageInfo>()),
    );
    gh.lazySingleton<_i554.BaseSecureVaultService>(
      () => _i554.SecureVaultService(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i219.BaseAuditLogger>(),
      ),
    );
    gh.lazySingleton<_i878.BaseUrlLauncherServices>(
      () => _i846.UrlLauncherService(gh<_i219.BaseAuditLogger>()),
    );
    gh.lazySingleton<_i720.BaseShareService>(
      () => _i383.SharePlusService(gh<_i998.SharePlus>()),
    );
    gh.lazySingleton<_i205.BaseClipboardGuardService>(
      () => _i205.ClipboardGuardService(gh<_i219.BaseAuditLogger>()),
    );
    gh.lazySingleton<_i379.PermissionServiceBase>(
      () => const _i527.PermissionHandlerService(),
    );
    gh.factory<_i156.BaseFileOpenerService>(
      () => _i17.UrlFileOpenerService(
        gh<_i878.BaseUrlLauncherServices>(),
        gh<_i219.BaseAuditLogger>(),
      ),
    );
    gh.lazySingleton<_i664.ToastServiceBase>(
      () => _i618.ToastificationService(gh<_i831.ThemeService>()),
    );
    gh.lazySingleton<_i932.SecureStorageService>(
      () => _i932.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i134.UserSessionServiceBase>(
      () => _i868.UserSessionService(gh<_i656.StorageFacade>()),
    );
    gh.lazySingleton<_i906.BaseAppInfoService>(
      () => _i30.AppInfoService(gh<_i329.BasePackageInfoAdapter>()),
    );
    gh.lazySingleton<_i638.PrefStorageServiceBase>(
      () => _i656.StorageFacade(
        gh<_i415.SharedPrefsService>(),
        gh<_i932.SecureStorageService>(),
      ),
    );
    return this;
  }
}

class _$ServiceModule extends _i518.ServiceModule {}
