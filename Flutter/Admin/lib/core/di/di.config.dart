// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:alam_el_marateb_admin/core/di/injection_module.dart' as _i441;
import 'package:alam_el_marateb_admin/core/networking/api_service/api_service.dart'
    as _i425;
import 'package:alam_el_marateb_admin/core/networking/network_info/interface/base_network_info.dart'
    as _i453;
import 'package:alam_el_marateb_admin/core/networking/network_info/network_info.dart'
    as _i606;
import 'package:alam_el_marateb_admin/core/services/app_info/app_info_service.dart'
    as _i95;
import 'package:alam_el_marateb_admin/core/services/app_info/interface/base_app_info_service.dart'
    as _i810;
import 'package:alam_el_marateb_admin/core/services/app_info/interface/base_package_info_adapter.dart'
    as _i607;
import 'package:alam_el_marateb_admin/core/services/app_info/package_info_plus_adapter.dart'
    as _i595;
import 'package:alam_el_marateb_admin/core/services/attachment_handler/attachment_handler_service.dart'
    as _i230;
import 'package:alam_el_marateb_admin/core/services/attachment_handler/base_attachment_handler_service.dart'
    as _i909;
import 'package:alam_el_marateb_admin/core/services/file_manager_facade/base_file_manager_facade.dart'
    as _i822;
import 'package:alam_el_marateb_admin/core/services/file_manager_facade/file_manager_facade.dart'
    as _i679;
import 'package:alam_el_marateb_admin/core/services/file_opener/base_file_opener_service.dart'
    as _i969;
import 'package:alam_el_marateb_admin/core/services/file_opener/url_file_opener_service.dart'
    as _i624;
import 'package:alam_el_marateb_admin/core/services/l10n/l10n_service.dart'
    as _i823;
import 'package:alam_el_marateb_admin/core/services/permissions/base_permission_service.dart'
    as _i520;
import 'package:alam_el_marateb_admin/core/services/permissions/permission_handler_service.dart'
    as _i621;
import 'package:alam_el_marateb_admin/core/services/security/audit/app_audit_logger.dart'
    as _i203;
import 'package:alam_el_marateb_admin/core/services/security/audit/base_audit_logger.dart'
    as _i79;
import 'package:alam_el_marateb_admin/core/services/security/clipboard_guard_service.dart'
    as _i403;
import 'package:alam_el_marateb_admin/core/services/security/secure_vault_service.dart'
    as _i239;
import 'package:alam_el_marateb_admin/core/services/session/user_session_service.dart'
    as _i173;
import 'package:alam_el_marateb_admin/core/services/share/base_share_service.dart'
    as _i325;
import 'package:alam_el_marateb_admin/core/services/share/share_plus_service.dart'
    as _i149;
import 'package:alam_el_marateb_admin/core/services/shared_prefs/base_pref_storage_service.dart'
    as _i1033;
import 'package:alam_el_marateb_admin/core/services/shared_prefs/secure_storage_service.dart'
    as _i400;
import 'package:alam_el_marateb_admin/core/services/shared_prefs/shared_prefs_service.dart'
    as _i907;
import 'package:alam_el_marateb_admin/core/services/shared_prefs/storage_facade.dart'
    as _i200;
import 'package:alam_el_marateb_admin/core/services/theme/theme_service.dart'
    as _i781;
import 'package:alam_el_marateb_admin/core/services/toast/base_toast_service.dart'
    as _i48;
import 'package:alam_el_marateb_admin/core/services/toast/toastification_service.dart'
    as _i267;
import 'package:alam_el_marateb_admin/core/services/url_launcher/base_url_launcher_services.dart'
    as _i334;
import 'package:alam_el_marateb_admin/core/services/url_launcher/url_launcher_service.dart'
    as _i396;
import 'package:alam_el_marateb_admin/core/utils/cache/cache_manager.dart'
    as _i1068;
import 'package:alam_el_marateb_admin/core/utils/localization/data/base_localization_repository.dart'
    as _i821;
import 'package:alam_el_marateb_admin/core/utils/localization/data/localization_repository.dart'
    as _i386;
import 'package:alam_el_marateb_admin/core/utils/localization/logic/cubit/localization_cubit.dart'
    as _i976;
import 'package:alam_el_marateb_admin/core/utils/network/logic/cubit/network_cubit.dart'
    as _i177;
import 'package:alam_el_marateb_admin/core/utils/theme/data/base_theme_repository.dart'
    as _i957;
import 'package:alam_el_marateb_admin/core/utils/theme/data/theme_repository.dart'
    as _i958;
import 'package:alam_el_marateb_admin/core/utils/theme/logic/cubit/theme_cubit.dart'
    as _i573;
import 'package:alam_el_marateb_admin/modules/accounting/data/interface/accounting_reposiory.dart'
    as _i113;
import 'package:alam_el_marateb_admin/modules/accounting/logic/cubit/accounting_accounts_cubit.dart'
    as _i656;
import 'package:alam_el_marateb_admin/modules/accounting/logic/cubit/accounting_checks_cubit.dart'
    as _i451;
import 'package:alam_el_marateb_admin/modules/accounting/logic/cubit/accounting_expenses_cubit.dart'
    as _i224;
import 'package:alam_el_marateb_admin/modules/accounting/logic/cubit/accounting_journal_cubit.dart'
    as _i391;
import 'package:alam_el_marateb_admin/modules/accounting/logic/cubit/accounting_ledger_cubit.dart'
    as _i990;
import 'package:alam_el_marateb_admin/modules/accounting/logic/cubit/accounting_reports_cubit.dart'
    as _i352;
import 'package:alam_el_marateb_admin/modules/accounting/logic/cubit/accounting_transfers_cubit.dart'
    as _i147;
import 'package:alam_el_marateb_admin/modules/accounting/logic/cubit/accounting_treasuries_cubit.dart'
    as _i949;
import 'package:alam_el_marateb_admin/modules/accounting/logic/repository/accounting_reposiory_impl.dart'
    as _i801;
import 'package:alam_el_marateb_admin/modules/accounting/logic/usecase/account_usecases.dart'
    as _i146;
import 'package:alam_el_marateb_admin/modules/accounting/logic/usecase/check_usecases.dart'
    as _i53;
import 'package:alam_el_marateb_admin/modules/accounting/logic/usecase/expense_usecases.dart'
    as _i749;
import 'package:alam_el_marateb_admin/modules/accounting/logic/usecase/journal_usecases.dart'
    as _i665;
import 'package:alam_el_marateb_admin/modules/accounting/logic/usecase/ledger_usecases.dart'
    as _i276;
import 'package:alam_el_marateb_admin/modules/accounting/logic/usecase/report_usecases.dart'
    as _i942;
import 'package:alam_el_marateb_admin/modules/accounting/logic/usecase/transfer_usecases.dart'
    as _i608;
import 'package:alam_el_marateb_admin/modules/accounting/logic/usecase/treasury_usecases.dart'
    as _i372;
import 'package:alam_el_marateb_admin/modules/login/data/interface/login_repository.dart'
    as _i850;
import 'package:alam_el_marateb_admin/modules/login/logic/cubit/login_cubit.dart'
    as _i826;
import 'package:alam_el_marateb_admin/modules/login/logic/repository/login_repository_impl.dart'
    as _i139;
import 'package:alam_el_marateb_admin/modules/login/logic/usecase/login_usecase.dart'
    as _i172;
import 'package:alam_el_marateb_admin/modules/login/logic/usecase/refresh_token_usecase.dart'
    as _i752;
import 'package:alam_el_marateb_admin/modules/profile/data/interface/auth_profile_repository.dart'
    as _i680;
import 'package:alam_el_marateb_admin/modules/profile/logic/cubit/profile_cubit.dart'
    as _i602;
import 'package:alam_el_marateb_admin/modules/profile/logic/repository/auth_profile_repository_impl.dart'
    as _i84;
import 'package:alam_el_marateb_admin/modules/profile/logic/usecase/get_profile_usecase.dart'
    as _i1028;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:share_plus/share_plus.dart' as _i998;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => injectionModule.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => injectionModule.packageInfo,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => injectionModule.secureStorage,
    );
    gh.lazySingleton<_i998.SharePlus>(() => injectionModule.sharePlus);
    gh.lazySingleton<_i895.Connectivity>(() => injectionModule.connectivity);
    gh.lazySingleton<_i823.L10nService>(() => _i823.L10nService());
    gh.lazySingleton<_i781.ThemeService>(() => _i781.ThemeService());
    gh.lazySingleton<_i1068.CacheManager>(() => _i1068.CacheManager());
    gh.lazySingleton<_i453.BaseNetworkInfo>(
      () => _i606.NetworkInfo(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i325.BaseShareService>(
      () => _i149.SharePlusService(gh<_i998.SharePlus>()),
    );
    gh.lazySingleton<_i607.BasePackageInfoAdapter>(
      () => _i595.PackageInfoPlusAdapter(gh<_i655.PackageInfo>()),
    );
    gh.lazySingleton<_i520.BasePermissionService>(
      () => const _i621.PermissionHandlerService(),
    );
    gh.lazySingleton<_i79.BaseAuditLogger>(() => const _i203.AppAuditLogger());
    gh.lazySingleton<_i48.BaseToastService>(
      () => _i267.ToastificationService(gh<_i781.ThemeService>()),
    );
    gh.lazySingleton<_i400.SecureStorageService>(
      () => _i400.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i907.SharedPrefsService>(
      () => _i907.SharedPrefsService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1033.BasePrefStorageService>(
      () => _i200.StorageFacade(
        sharedPrefsService: gh<_i907.SharedPrefsService>(),
        secureStorageService: gh<_i400.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i177.NetworkCubit>(
      () => _i177.NetworkCubit(gh<_i453.BaseNetworkInfo>()),
    );
    gh.lazySingleton<_i403.BaseClipboardGuardService>(
      () => _i403.ClipboardGuardService(gh<_i79.BaseAuditLogger>()),
    );
    gh.lazySingleton<_i334.BaseUrlLauncherServices>(
      () => _i396.UrlLauncherService(gh<_i79.BaseAuditLogger>()),
    );
    gh.lazySingleton<_i976.LocalizationCubit>(
      () => _i976.LocalizationCubit(l10nService: gh<_i823.L10nService>()),
    );
    gh.lazySingleton<_i810.BaseAppInfoService>(
      () => _i95.AppInfoService(gh<_i607.BasePackageInfoAdapter>()),
    );
    gh.lazySingleton<_i821.BaseLocalizationRepository>(
      () => _i386.LocalizationRepository(
        storage: gh<_i1033.BasePrefStorageService>(),
        l10nService: gh<_i823.L10nService>(),
      ),
    );
    gh.lazySingleton<_i239.BaseSecureVaultService>(
      () => _i239.SecureVaultService(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i79.BaseAuditLogger>(),
      ),
    );
    gh.lazySingleton<_i957.BaseThemeRepository>(
      () => _i958.ThemeRepository(gh<_i1033.BasePrefStorageService>()),
    );
    gh.lazySingleton<_i200.StorageFacade>(
      () => injectionModule.storageFacade(gh<_i1033.BasePrefStorageService>()),
    );
    gh.factory<_i969.BaseFileOpenerService>(
      () => _i624.UrlFileOpenerService(
        gh<_i334.BaseUrlLauncherServices>(),
        gh<_i79.BaseAuditLogger>(),
      ),
    );
    gh.lazySingleton<_i573.ThemeCubit>(
      () => _i573.ThemeCubit(gh<_i957.BaseThemeRepository>()),
    );
    gh.lazySingleton<_i173.UserSessionServiceBase>(
      () => _i173.UserSessionService(gh<_i200.StorageFacade>()),
    );
    await gh.factoryAsync<_i361.Dio>(
      () => injectionModule.dio(
        gh<_i976.LocalizationCubit>(),
        gh<_i173.UserSessionServiceBase>(),
        gh<String>(instanceName: 'dioCachePath'),
      ),
      preResolve: true,
    );
    gh.factory<_i909.BaseAttachmentHandlerService>(
      () => _i230.AttachmentHandlerService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i425.ApiService>(
      () => injectionModule.apiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i680.AuthProfileRepository>(
      () => _i84.AuthProfileRepositoryImpl(gh<_i425.ApiService>()),
    );
    gh.factory<_i822.BaseFileManagerFacade>(
      () => _i679.FileManagerFacade(gh<_i909.BaseAttachmentHandlerService>()),
    );
    gh.factory<_i1028.GetProfileUsecase>(
      () => _i1028.GetProfileUsecase(gh<_i680.AuthProfileRepository>()),
    );
    gh.factory<_i602.ProfileCubit>(
      () =>
          _i602.ProfileCubit(getProfileUsecase: gh<_i1028.GetProfileUsecase>()),
    );
    gh.lazySingleton<_i113.AccountingReposiory>(
      () => _i801.AccountingReposioryImpl(api: gh<_i425.ApiService>()),
    );
    gh.lazySingleton<_i850.LoginRepository>(
      () => _i139.LoginRepositoryImpl(
        api: gh<_i425.ApiService>(),
        session: gh<_i173.UserSessionServiceBase>(),
      ),
    );
    gh.factory<_i146.GetAccountsUsecase>(
      () => _i146.GetAccountsUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i146.GetAccountUsecase>(
      () => _i146.GetAccountUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i146.CreateAccountUsecase>(
      () => _i146.CreateAccountUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i146.UpdateAccountUsecase>(
      () => _i146.UpdateAccountUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i53.GetChecksUsecase>(
      () => _i53.GetChecksUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i53.GetCheckUsecase>(
      () => _i53.GetCheckUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i53.CreateCheckUsecase>(
      () => _i53.CreateCheckUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i53.UpdateCheckUsecase>(
      () => _i53.UpdateCheckUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i53.UpdateCheckStatusUsecase>(
      () =>
          _i53.UpdateCheckStatusUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i749.GetExpensesUsecase>(
      () => _i749.GetExpensesUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i749.GetExpenseUsecase>(
      () => _i749.GetExpenseUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i749.CreateExpenseUsecase>(
      () => _i749.CreateExpenseUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i749.UpdateExpenseUsecase>(
      () => _i749.UpdateExpenseUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i665.GetJournalEntriesUsecase>(
      () =>
          _i665.GetJournalEntriesUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i665.GetJournalEntryUsecase>(
      () => _i665.GetJournalEntryUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i665.PostJournalEntryUsecase>(
      () =>
          _i665.PostJournalEntryUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i276.GetGeneralLedgerUsecase>(
      () =>
          _i276.GetGeneralLedgerUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i942.GetProfitLossUsecase>(
      () => _i942.GetProfitLossUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i942.GetTaxReportUsecase>(
      () => _i942.GetTaxReportUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i942.GetBalanceSheetUsecase>(
      () => _i942.GetBalanceSheetUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i608.GetTransfersUsecase>(
      () => _i608.GetTransfersUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i608.GetTransferUsecase>(
      () => _i608.GetTransferUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i608.CreateTransferUsecase>(
      () => _i608.CreateTransferUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i372.GetTreasuriesUsecase>(
      () => _i372.GetTreasuriesUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i372.GetTreasuryUsecase>(
      () => _i372.GetTreasuryUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i372.CreateTreasuryUsecase>(
      () => _i372.CreateTreasuryUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i372.UpdateTreasuryUsecase>(
      () => _i372.UpdateTreasuryUsecase(repo: gh<_i113.AccountingReposiory>()),
    );
    gh.factory<_i352.AccountingReportsCubit>(
      () => _i352.AccountingReportsCubit(
        getProfitLoss: gh<_i942.GetProfitLossUsecase>(),
        getTaxReport: gh<_i942.GetTaxReportUsecase>(),
        getBalanceSheet: gh<_i942.GetBalanceSheetUsecase>(),
      ),
    );
    gh.factory<_i949.AccountingTreasuriesCubit>(
      () => _i949.AccountingTreasuriesCubit(
        getTreasuries: gh<_i372.GetTreasuriesUsecase>(),
        createTreasury: gh<_i372.CreateTreasuryUsecase>(),
        updateTreasury: gh<_i372.UpdateTreasuryUsecase>(),
      ),
    );
    gh.factory<_i172.LoginUsecase>(
      () => _i172.LoginUsecase(repo: gh<_i850.LoginRepository>()),
    );
    gh.factory<_i752.RefreshTokenUsecase>(
      () => _i752.RefreshTokenUsecase(repo: gh<_i850.LoginRepository>()),
    );
    gh.factory<_i990.AccountingLedgerCubit>(
      () => _i990.AccountingLedgerCubit(
        getGeneralLedger: gh<_i276.GetGeneralLedgerUsecase>(),
      ),
    );
    gh.factory<_i147.AccountingTransfersCubit>(
      () => _i147.AccountingTransfersCubit(
        getTransfers: gh<_i608.GetTransfersUsecase>(),
        createTransfer: gh<_i608.CreateTransferUsecase>(),
      ),
    );
    gh.factory<_i826.LoginCubit>(
      () => _i826.LoginCubit(gh<_i172.LoginUsecase>()),
    );
    gh.factory<_i656.AccountingAccountsCubit>(
      () => _i656.AccountingAccountsCubit(
        getAccounts: gh<_i146.GetAccountsUsecase>(),
        createAccount: gh<_i146.CreateAccountUsecase>(),
        updateAccount: gh<_i146.UpdateAccountUsecase>(),
      ),
    );
    gh.factory<_i451.AccountingChecksCubit>(
      () => _i451.AccountingChecksCubit(
        getChecks: gh<_i53.GetChecksUsecase>(),
        createCheck: gh<_i53.CreateCheckUsecase>(),
        updateCheck: gh<_i53.UpdateCheckUsecase>(),
        updateCheckStatus: gh<_i53.UpdateCheckStatusUsecase>(),
      ),
    );
    gh.factory<_i391.AccountingJournalCubit>(
      () => _i391.AccountingJournalCubit(
        getJournalEntries: gh<_i665.GetJournalEntriesUsecase>(),
        getJournalEntry: gh<_i665.GetJournalEntryUsecase>(),
        postJournalEntry: gh<_i665.PostJournalEntryUsecase>(),
      ),
    );
    gh.factory<_i224.AccountingExpensesCubit>(
      () => _i224.AccountingExpensesCubit(
        getExpenses: gh<_i749.GetExpensesUsecase>(),
        createExpense: gh<_i749.CreateExpenseUsecase>(),
        updateExpense: gh<_i749.UpdateExpenseUsecase>(),
      ),
    );
    return this;
  }

  _i823.L10nService get l10nService => get<_i823.L10nService>();

  _i781.ThemeService get themeService => get<_i781.ThemeService>();

  _i1068.CacheManager get cacheManager => get<_i1068.CacheManager>();

  _i606.NetworkInfo get networkInfo => get<_i606.NetworkInfo>();

  _i149.SharePlusService get sharePlusService => get<_i149.SharePlusService>();

  _i595.PackageInfoPlusAdapter get packageInfoPlusAdapter =>
      get<_i595.PackageInfoPlusAdapter>();

  _i621.PermissionHandlerService get permissionHandlerService =>
      get<_i621.PermissionHandlerService>();

  _i203.AppAuditLogger get appAuditLogger => get<_i203.AppAuditLogger>();

  _i267.ToastificationService get toastificationService =>
      get<_i267.ToastificationService>();

  _i400.SecureStorageService get secureStorageService =>
      get<_i400.SecureStorageService>();

  _i907.SharedPrefsService get sharedPrefsService =>
      get<_i907.SharedPrefsService>();

  _i200.StorageFacade get storageFacade => get<_i200.StorageFacade>();

  _i177.NetworkCubit get networkCubit => get<_i177.NetworkCubit>();

  _i403.ClipboardGuardService get clipboardGuardService =>
      get<_i403.ClipboardGuardService>();

  _i396.UrlLauncherService get urlLauncherService =>
      get<_i396.UrlLauncherService>();

  _i976.LocalizationCubit get localizationCubit =>
      get<_i976.LocalizationCubit>();

  _i95.AppInfoService get appInfoService => get<_i95.AppInfoService>();

  _i386.LocalizationRepository get localizationRepository =>
      get<_i386.LocalizationRepository>();

  _i239.SecureVaultService get secureVaultService =>
      get<_i239.SecureVaultService>();

  _i958.ThemeRepository get themeRepository => get<_i958.ThemeRepository>();

  _i624.UrlFileOpenerService get urlFileOpenerService =>
      get<_i624.UrlFileOpenerService>();

  _i573.ThemeCubit get themeCubit => get<_i573.ThemeCubit>();

  _i173.UserSessionService get userSessionService =>
      get<_i173.UserSessionService>();

  _i230.AttachmentHandlerService get attachmentHandlerService =>
      get<_i230.AttachmentHandlerService>();

  _i84.AuthProfileRepositoryImpl get authProfileRepositoryImpl =>
      get<_i84.AuthProfileRepositoryImpl>();

  _i679.FileManagerFacade get fileManagerFacade =>
      get<_i679.FileManagerFacade>();

  _i1028.GetProfileUsecase get getProfileUsecase =>
      get<_i1028.GetProfileUsecase>();

  _i602.ProfileCubit get profileCubit => get<_i602.ProfileCubit>();

  _i801.AccountingReposioryImpl get accountingReposioryImpl =>
      get<_i801.AccountingReposioryImpl>();

  _i139.LoginRepositoryImpl get loginRepositoryImpl =>
      get<_i139.LoginRepositoryImpl>();

  _i146.GetAccountsUsecase get getAccountsUsecase =>
      get<_i146.GetAccountsUsecase>();

  _i146.GetAccountUsecase get getAccountUsecase =>
      get<_i146.GetAccountUsecase>();

  _i146.CreateAccountUsecase get createAccountUsecase =>
      get<_i146.CreateAccountUsecase>();

  _i146.UpdateAccountUsecase get updateAccountUsecase =>
      get<_i146.UpdateAccountUsecase>();

  _i53.GetChecksUsecase get getChecksUsecase => get<_i53.GetChecksUsecase>();

  _i53.GetCheckUsecase get getCheckUsecase => get<_i53.GetCheckUsecase>();

  _i53.CreateCheckUsecase get createCheckUsecase =>
      get<_i53.CreateCheckUsecase>();

  _i53.UpdateCheckUsecase get updateCheckUsecase =>
      get<_i53.UpdateCheckUsecase>();

  _i53.UpdateCheckStatusUsecase get updateCheckStatusUsecase =>
      get<_i53.UpdateCheckStatusUsecase>();

  _i749.GetExpensesUsecase get getExpensesUsecase =>
      get<_i749.GetExpensesUsecase>();

  _i749.GetExpenseUsecase get getExpenseUsecase =>
      get<_i749.GetExpenseUsecase>();

  _i749.CreateExpenseUsecase get createExpenseUsecase =>
      get<_i749.CreateExpenseUsecase>();

  _i749.UpdateExpenseUsecase get updateExpenseUsecase =>
      get<_i749.UpdateExpenseUsecase>();

  _i665.GetJournalEntriesUsecase get getJournalEntriesUsecase =>
      get<_i665.GetJournalEntriesUsecase>();

  _i665.GetJournalEntryUsecase get getJournalEntryUsecase =>
      get<_i665.GetJournalEntryUsecase>();

  _i665.PostJournalEntryUsecase get postJournalEntryUsecase =>
      get<_i665.PostJournalEntryUsecase>();

  _i276.GetGeneralLedgerUsecase get getGeneralLedgerUsecase =>
      get<_i276.GetGeneralLedgerUsecase>();

  _i942.GetProfitLossUsecase get getProfitLossUsecase =>
      get<_i942.GetProfitLossUsecase>();

  _i942.GetTaxReportUsecase get getTaxReportUsecase =>
      get<_i942.GetTaxReportUsecase>();

  _i942.GetBalanceSheetUsecase get getBalanceSheetUsecase =>
      get<_i942.GetBalanceSheetUsecase>();

  _i608.GetTransfersUsecase get getTransfersUsecase =>
      get<_i608.GetTransfersUsecase>();

  _i608.GetTransferUsecase get getTransferUsecase =>
      get<_i608.GetTransferUsecase>();

  _i608.CreateTransferUsecase get createTransferUsecase =>
      get<_i608.CreateTransferUsecase>();

  _i372.GetTreasuriesUsecase get getTreasuriesUsecase =>
      get<_i372.GetTreasuriesUsecase>();

  _i372.GetTreasuryUsecase get getTreasuryUsecase =>
      get<_i372.GetTreasuryUsecase>();

  _i372.CreateTreasuryUsecase get createTreasuryUsecase =>
      get<_i372.CreateTreasuryUsecase>();

  _i372.UpdateTreasuryUsecase get updateTreasuryUsecase =>
      get<_i372.UpdateTreasuryUsecase>();

  _i352.AccountingReportsCubit get accountingReportsCubit =>
      get<_i352.AccountingReportsCubit>();

  _i949.AccountingTreasuriesCubit get accountingTreasuriesCubit =>
      get<_i949.AccountingTreasuriesCubit>();

  _i172.LoginUsecase get loginUsecase => get<_i172.LoginUsecase>();

  _i752.RefreshTokenUsecase get refreshTokenUsecase =>
      get<_i752.RefreshTokenUsecase>();

  _i990.AccountingLedgerCubit get accountingLedgerCubit =>
      get<_i990.AccountingLedgerCubit>();

  _i147.AccountingTransfersCubit get accountingTransfersCubit =>
      get<_i147.AccountingTransfersCubit>();

  _i826.LoginCubit get loginCubit => get<_i826.LoginCubit>();

  _i656.AccountingAccountsCubit get accountingAccountsCubit =>
      get<_i656.AccountingAccountsCubit>();

  _i451.AccountingChecksCubit get accountingChecksCubit =>
      get<_i451.AccountingChecksCubit>();

  _i391.AccountingJournalCubit get accountingJournalCubit =>
      get<_i391.AccountingJournalCubit>();

  _i224.AccountingExpensesCubit get accountingExpensesCubit =>
      get<_i224.AccountingExpensesCubit>();
}

class _$InjectionModule extends _i441.InjectionModule {}
