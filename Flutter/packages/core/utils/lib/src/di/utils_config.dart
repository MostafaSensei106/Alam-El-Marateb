import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'utils_config.config.dart';

/// Generated utils registrations (theme, localization, cache).
///
/// Run `dart run build_runner build` inside `packages/core/utils`
/// after changing any `@injectable` annotation.
@InjectableInit(initializerName: 'initUtils', asExtension: true)
void initUtils(GetIt getIt) => getIt.initUtils();
