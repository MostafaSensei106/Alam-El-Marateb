import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/base_theme_repository.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._repo) : super(const ThemeState()) {
    unawaited(_init());
  }

  final BaseThemeRepository _repo;

  Future<void> _init() async {
    final themeMode = await _repo.getThemeMode();
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> changeTheme(ThemeMode newMode) async {
    if (state.themeMode == newMode) return;

    emit(state.copyWith(themeMode: newMode));
    await _repo.cacheThemeMode(newMode);
  }
}
