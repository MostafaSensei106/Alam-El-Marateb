// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:alam_el_marateb_services/services.dart' as _i42;
import 'package:alam_el_marateb_utils/src/cache/cache_manager.dart' as _i196;
import 'package:alam_el_marateb_utils/src/localization/data/interface/localization_repository_base.dart'
    as _i230;
import 'package:alam_el_marateb_utils/src/localization/domain/repository/localization_repository.dart'
    as _i920;
import 'package:alam_el_marateb_utils/src/localization/logic/cubit/localization_cubit.dart'
    as _i487;
import 'package:alam_el_marateb_utils/src/theme/data/interface/base_theme_repository.dart'
    as _i811;
import 'package:alam_el_marateb_utils/src/theme/domain/repository/theme_repository.dart'
    as _i514;
import 'package:alam_el_marateb_utils/src/theme/logic/cubit/theme_cubit.dart'
    as _i572;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initUtils({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i196.CacheManager>(() => _i196.CacheManager());
    gh.lazySingleton<_i230.LocalizationRepositoryBase>(
      () => _i920.LocalizationRepository(
        gh<_i42.PrefStorageServiceBase>(),
        supportedLanguageCodes: gh<List<String>>(),
        fallbackLanguageCode: gh<String>(),
      ),
    );
    gh.lazySingleton<_i487.LocalizationCubit>(
      () => _i487.LocalizationCubit(
        gh<_i230.LocalizationRepositoryBase>(),
        supportedLanguageCodes: gh<List<String>>(),
        fallbackLanguageCode: gh<String>(),
      ),
    );
    gh.lazySingleton<_i811.BaseThemeRepository>(
      () => _i514.ThemeRepository(gh<_i42.PrefStorageServiceBase>()),
    );
    gh.lazySingleton<_i572.ThemeCubit>(
      () => _i572.ThemeCubit(gh<_i811.BaseThemeRepository>()),
    );
    return this;
  }
}
