import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'network_config.config.dart';

/// Generated network registrations (see `network_module.dart`).
///
/// Run `dart run build_runner build` inside `packages/core/network`
/// after changing any `@injectable` annotation or module provider.
@InjectableInit(initializerName: 'initNetwork', asExtension: true)
void initNetwork(GetIt getIt) => getIt.initNetwork();
