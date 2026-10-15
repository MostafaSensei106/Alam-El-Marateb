import 'package:alam_el_marateb_auth/alam_el_marateb_auth.dart';
import 'package:alam_el_marateb_di/di.dart';
import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:alam_el_marateb_ui/ui.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/router/staff_router.dart';

/// Alam El Marateb Staff entrypoint.
///
/// Boot order: core DI → authenticated Dio → auth module → prime auth
/// state → router. Every step is shared code; app-specific pieces are
/// the router table and the home page only.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSignalObserver.observer = const AppBlocObserver();
  await configureCoreDependencies();
  final dio = await buildAuthenticatedDio(clientName: 'staff-app');
  registerAttachmentService(dio);
  await registerAuthModule(dio: dio, allowedRoles: AppRoles.staffApp);
  await primeAuthState();
  runApp(const StaffApp());
}

class StaffApp extends StatelessWidget {
  const StaffApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, _) => BlocSignalProvider.value(
        value: getIt<ThemeCubit>(),
        child: BlocSignalProvider.value(
          value: getIt<LocalizationCubit>(),
          child: BlocSignalProvider.value(
            value: getIt<NetworkCubit>(),
            child: BlocSignalProvider(
              create: (_) => getIt<AuthCubit>(),
              child: BlocSignalBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return MaterialApp.router(
                    title: 'Alam El Marateb Staff',
                    theme: AppTheme.light,
                    darkTheme: AppTheme.dark,
                    themeMode: themeState.themeMode,
                    builder: (context, child) => ConnectivityBanner(
                      child: child ?? const SizedBox.shrink(),
                    ),
                    routerConfig: buildStaffRouter(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
