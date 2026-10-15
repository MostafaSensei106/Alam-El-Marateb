import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'services_config.config.dart';

/// Generated service registrations (see `service_module.dart`).
///
/// Run `dart run build_runner build` inside `packages/core/services`
/// after changing any `@injectable` annotation or module provider.
@InjectableInit(
  initializerName: 'initServices',
  asExtension: true,
)
Future<void> initServices(GetIt getIt) => getIt.initServices();
