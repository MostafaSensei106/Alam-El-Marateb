import 'package:flutter/material.dart';

import '../../constants/app_config.dart';

final class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: .light,

    fontFamily: 'Rubik',

    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppConfig.outBorderRadius),
        ),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    //  brightness: .dark,

    fontFamily: 'Rubik',

    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppConfig.outBorderRadius),
        ),
      ),
    ),
  );
}
