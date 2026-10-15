import 'dart:async';

import 'package:alam_el_marateb_auth/alam_el_marateb_auth.dart';
import 'package:alam_el_marateb_constants/constants.dart';
import 'package:alam_el_marateb_ui/ui.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Staff home. Role chrome lives here; feature screens plug in as
/// modules grow (catalog, orders, ...).
class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocalizationCubit>().stateValue.langCode;
    return Scaffold(
      appBar: const AppBarComponent(title: 'Alam El Marateb Staff'),
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
                final next = theme.stateValue.themeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
                unawaited(theme.changeTheme(next));
              },
            ),
            SizedBox(height: 12.h),
            FilledButtonComponent(
              label: 'Sign out',
              onPressed: () => context.read<AuthCubit>().signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
