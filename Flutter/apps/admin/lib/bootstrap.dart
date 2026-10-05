import 'package:flutter/widgets.dart';

import 'app.dart';
import 'di/injection.dart';

/// Bootstrap: bindings → DI → app. Crash reporting and flavor
/// logging attach here as their packages land.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  runApp(const AdminApp());
}
