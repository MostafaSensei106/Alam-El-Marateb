import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'auth_config.config.dart';

/// Generated auth registrations (use-cases + cubit).
///
/// The repository and API service take runtime values (configured `Dio`,
/// per-app roles) and stay manual — see `registerAuthModule()`.
///
/// Run `dart run build_runner build` inside `packages/modules/auth`
/// after changing any `@injectable` annotation.
@InjectableInit(
  initializerName: 'initAuth',
  preferInjectable: true,
  asExtension: true,
)
void initAuth(GetIt getIt) => getIt.initAuth();
