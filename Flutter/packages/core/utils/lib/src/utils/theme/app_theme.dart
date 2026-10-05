import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/app_config.dart';

final class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,

    fontFamily: 'Hadidi',

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff000454),
      surfaceTint: Color(0xff4f57a6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff161e6e),
      onPrimaryContainer: Color(0xff818add),
      secondary: Color(0xff595c7d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd5d7fe),
      onSecondaryContainer: Color(0xff5a5d7d),
      tertiary: Color(0xff290034),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff460d53),
      onTertiaryContainer: Color(0xffb979c3),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff1b1b20),
      onSurfaceVariant: Color(0xff464651),
      outline: Color(0xff767682),
      outlineVariant: Color(0xffe7e7ef),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303036),
      inversePrimary: Color(0xffbdc2ff),
      primaryFixed: Color(0xffe0e0ff),
      onPrimaryFixed: Color(0xff030b61),
      primaryFixedDim: Color(0xffbdc2ff),
      onPrimaryFixedVariant: Color(0xff373f8d),
      secondaryFixed: Color(0xffe0e0ff),
      onSecondaryFixed: Color(0xff161936),
      secondaryFixedDim: Color(0xffc2c4e9),
      onSecondaryFixedVariant: Color(0xff424464),
      tertiaryFixed: Color(0xfffed6ff),
      onTertiaryFixed: Color(0xff350041),
      tertiaryFixedDim: Color(0xfff4aefd),
      onTertiaryFixedVariant: Color(0xff682f73),
      surfaceDim: Color(0xffdbd9e0),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2fa),
      surfaceContainer: Color(0xffefedf4),
      surfaceContainerHigh: Color(0xffeae7ee),
      surfaceContainerHighest: Color(0xffe4e1e9),
    ),

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

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,

    fontFamily: 'Hadidi',

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbdc2ff),
      surfaceTint: Color(0xffbdc2ff),
      onPrimary: Color(0xff1e2675),
      primaryContainer: Color(0xff161e6e),
      onPrimaryContainer: Color(0xff818add),
      secondary: Color(0xffc2c4e9),
      onSecondary: Color(0xff2b2e4c),
      secondaryContainer: Color(0xff424464),
      onSecondaryContainer: Color(0xffb0b2d7),
      tertiary: Color(0xfff4aefd),
      onTertiary: Color(0xff4e175b),
      tertiaryContainer: Color(0xff460d53),
      onTertiaryContainer: Color(0xffb979c3),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131318),
      onSurface: Color(0xffe4e1e9),
      onSurfaceVariant: Color(0xffc6c5d3),
      outline: Color(0xff908f9c),
      outlineVariant: Color(0xff464651),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1e9),
      inversePrimary: Color(0xff4f57a6),
      primaryFixed: Color(0xffe0e0ff),
      onPrimaryFixed: Color(0xff030b61),
      primaryFixedDim: Color(0xffbdc2ff),
      onPrimaryFixedVariant: Color(0xff373f8d),
      secondaryFixed: Color(0xffe0e0ff),
      onSecondaryFixed: Color(0xff161936),
      secondaryFixedDim: Color(0xffc2c4e9),
      onSecondaryFixedVariant: Color(0xff424464),
      tertiaryFixed: Color(0xfffed6ff),
      onTertiaryFixed: Color(0xff350041),
      tertiaryFixedDim: Color(0xfff4aefd),
      onTertiaryFixedVariant: Color(0xff682f73),
      surfaceDim: Color(0xff131318),
      surfaceBright: Color(0xff39393e),
      surfaceContainerLowest: Color(0xff0e0e13),
      surfaceContainerLow: Color(0xff1b1b20),
      surfaceContainer: Color(0xff1f1f24),
      surfaceContainerHigh: Color(0xff2a292f),
      surfaceContainerHighest: Color(0xff34343a),
    ),

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

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
