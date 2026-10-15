// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:alam_el_marateb_auth/src/domain/repositories/auth_repository.dart' as _i126;
import 'package:alam_el_marateb_auth/src/domain/usecases/login_usecase.dart' as _i25;
import 'package:alam_el_marateb_auth/src/domain/usecases/logout_usecase.dart' as _i545;
import 'package:alam_el_marateb_auth/src/presentation/cubit/auth_cubit.dart' as _i1032;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initAuth({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i25.LoginUseCase>(
      () => _i25.LoginUseCase(gh<_i126.AuthRepository>()),
    );
    gh.lazySingleton<_i545.LogoutUseCase>(
      () => _i545.LogoutUseCase(gh<_i126.AuthRepository>()),
    );
    gh.factory<_i1032.AuthCubit>(
      () =>
          _i1032.AuthCubit(gh<_i25.LoginUseCase>(), gh<_i545.LogoutUseCase>()),
    );
    return this;
  }
}
