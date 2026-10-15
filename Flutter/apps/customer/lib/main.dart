import 'dart:async';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:alam_el_marateb_di/di.dart';
import 'package:alam_el_marateb_network/network.dart';
import 'package:alam_el_marateb_ui/ui.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// TITLE: Alam El Marateb User
/// BOOT: shared core boot (configure once, fix once).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureCoreDependencies();
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

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
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Alam El Marateb User',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeState.themeMode,
              builder: (context, child) =>
                  ConnectivityBanner(child: child ?? const SizedBox.shrink()),
              home: const _HomePage(),
            );
          },
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final langCode = context.select(
      (LocalizationCubit cubit) => cubit.state.langCode,
    );
    return Scaffold(
      appBar: const AppBarComponent(title: 'Alam El Marateb User'),
      body: Padding(
        padding: const EdgeInsets.all(ApplicationPadding.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Shared core OK · lang: $langCode'),
            SizedBox(height: 16.h),
            FilledButtonComponent(
              label: 'Toggle theme (shared cubit)',
              onPressed: () {
                final theme = context.read<ThemeCubit>();
                unawaited(
                  theme.changeTheme(
                    theme.state.themeMode == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
