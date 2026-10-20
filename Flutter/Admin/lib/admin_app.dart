import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:toastification/toastification.dart';

import 'core/constants/app_metadata.dart';
import 'core/di/di.dart';
import 'core/router/app_router.dart';
import 'core/utils/localization/logic/cubit/localization_cubit.dart';
import 'core/utils/network/logic/cubit/network_cubit.dart';
import 'core/utils/theme/app_theme.dart';
import 'core/utils/theme/logic/cubit/theme_cubit.dart';
import 'l10n/app_localizations.dart';

final class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocSignalProvider(
      providers: const [],
      child: ToastificationWrapper(
        child: MultiBlocSignalProvider(
          providers: [
            BlocSignalProvider(create: (_) => getIt<LocalizationCubit>()),
            BlocSignalProvider(create: (_) => getIt<NetworkCubit>()),
            BlocSignalProvider(create: (_) => getIt<ThemeCubit>()),
          ],
          child: Builder(
            builder: (context) {
              final locale = context.select(
                (LocalizationCubit cubit) => cubit.state.value.langCode,
              );
              final themeMode = context.select(
                (ThemeCubit cubit) => cubit.state.value.themeMode,
              );
              return MaterialApp.router(
                title: AppMetadata.name,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                locale: Locale(locale),
                scrollBehavior: const CupertinoScrollBehavior(),
                restorationScopeId: 'app',
                localizationsDelegates: const [
                  ...AppLocalizations.localizationsDelegates,
                  SfGlobalLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: AppRouter.config,
              );
            },
          ),
        ),
      ),
    );
  }
}
