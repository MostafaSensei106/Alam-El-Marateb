import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:alam_el_marateb_utils/src/theme/data/interface/base_theme_repository.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

@lazySingleton
class ThemeCubit extends CubitSignal<ThemeState> {
  ThemeCubit(this._repo) : super(initialState: const ThemeState()) {
    unawaited(_init());
  }

  final BaseThemeRepository _repo;

  Future<void> _init() async {
    final themeMode = await _repo.getThemeMode();
    if (isClosed) return;
    emit(stateValue.copyWith(themeMode: themeMode));
  }

  Future<void> changeTheme(ThemeMode newMode) async {
    if (stateValue.themeMode == newMode) return;

    emit(stateValue.copyWith(themeMode: newMode));
    await _repo.cacheThemeMode(newMode);
  }
}
