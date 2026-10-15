import 'package:alam_el_marateb_constants/constants.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:alam_el_marateb_utils/src/theme/data/interface/base_theme_repository.dart';

@LazySingleton(as: BaseThemeRepository)
class ThemeRepository implements BaseThemeRepository {
  ThemeRepository(this._storage);
  final PrefStorageServiceBase _storage;

  @override
  Future<void> cacheThemeMode(ThemeMode themeMode) async {
    await _storage.setData(key: PrefKeys.themeMode, value: themeMode.name);
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    final cachedThemeName = await _storage.getData<String>(
      key: PrefKeys.themeMode,
    );
    if (cachedThemeName == null) return ThemeMode.system;

    return ThemeMode.values.firstWhere(
      (e) => e.name == cachedThemeName,
      orElse: () => ThemeMode.system,
    );
  }
}
