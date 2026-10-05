import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../routing/app_router.dart';
import '../session/auth_state.dart';

/// Thin shell: theme/locale/design_system plug in here in later slices.
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router =
        AdminRouter(authState: GetIt.instance<AuthState>()).router;
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
