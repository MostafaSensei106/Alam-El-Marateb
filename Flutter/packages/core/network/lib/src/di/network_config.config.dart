// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:alam_el_marateb_network/src/connectivity/base_network_info.dart'
    as _i21;
import 'package:alam_el_marateb_network/src/connectivity/network_cubit.dart'
    as _i30;
import 'package:alam_el_marateb_network/src/connectivity/network_info.dart'
    as _i589;
import 'package:alam_el_marateb_network/src/di/network_module.dart' as _i643;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initNetwork({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i895.Connectivity>(() => networkModule.connectivity);
    gh.lazySingleton<_i21.BaseNetworkInfo>(
      () => _i589.NetworkInfo(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i30.NetworkCubit>(
      () => _i30.NetworkCubit(gh<_i21.BaseNetworkInfo>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i643.NetworkModule {}
