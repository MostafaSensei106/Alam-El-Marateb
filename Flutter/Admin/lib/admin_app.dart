import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart';

import 'core/router/app_router.dart';

final class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocSignalProvider(
      providers: const [],
      child: MaterialApp.router(routerConfig: AppRouter.config),
    );
  }
}
