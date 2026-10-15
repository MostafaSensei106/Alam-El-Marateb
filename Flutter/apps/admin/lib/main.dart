import 'package:alam_el_marateb_di/di.dart';
import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_ui/ui.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/router/admin_router';

/// Alam El Marateb Admin entrypoint.
///
/// Boot order: core DI → authenticated Dio → auth module → prime auth
/// state → router. Every step is shared code; app-specific pieces are
/// the router table and the home page only.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureCoreDependencies();
  final dio = await buildAuthenticatedDio();
  await registerAuthModule(dio: dio);
  await primeAuthState();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, _) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt<ThemeCubit>()),
          BlocProvider.value(value: getIt<LocalizationCubit>()),
          BlocProvider.value(value: getIt<NetworkCubit>()),
          BlocProvider(create: (_) => getIt<AuthCubit>()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              title: 'Alam El Marateb Admin',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeState.themeMode,
              builder: (context, child) =>
                  ConnectivityBanner(child: child ?? const SizedBox.shrink()),
              routerConfig: buildAdminRouter(),
            );
          },
        ),
      ),
    );
  }
}
