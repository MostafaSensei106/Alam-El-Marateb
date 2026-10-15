import 'package:alam_el_marateb_services/services.dart';
import 'package:alam_el_marateb_utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryStorage implements PrefStorageServiceBase {
  final map = <String, Object>{};

  @override
  Future<bool> clearAll() async {
    map.clear();
    return true;
  }

  @override
  Future<T?> getData<T>({required String key}) async => map[key] as T?;

  @override
  Future<bool> removeData({required String key}) async =>
      map.remove(key) != null;

  @override
  Future<bool> setData<T>({required String key, required T value}) async {
    map[key] = value as Object;
    return true;
  }
}

void main() {
  group('ThemeRepository', () {
    test('defaults to system and round-trips mode', () async {
      final repo = ThemeRepository(_MemoryStorage());

      expect(await repo.getThemeMode(), ThemeMode.system);

      await repo.cacheThemeMode(ThemeMode.dark);
      expect(await repo.getThemeMode(), ThemeMode.dark);
    });

    test('falls back to system on unknown value', () async {
      final storage = _MemoryStorage();
      final repo = ThemeRepository(storage);
      await storage.setData(key: 'theme_mode', value: 'nope');
      expect(await repo.getThemeMode(), ThemeMode.system);
    });
  });

  group('ThemeCubit', () {
    test('loads cached mode and changes theme', () async {
      final cubit = ThemeCubit(ThemeRepository(_MemoryStorage()));
      // Allow async _init to complete
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.themeMode, ThemeMode.system);

      await cubit.changeTheme(ThemeMode.dark);
      expect(cubit.state.themeMode, ThemeMode.dark);
      await cubit.close();
    });
  });

  group('LocalizationRepository', () {
    test('round-trips language code', () async {
      final repo = LocalizationRepository(_MemoryStorage());
      await repo.cacheLanguageCode(languageCode: 'en');
      expect(await repo.getLanguageCode(), 'en');
    });
  });

  group('LocalizationCubit', () {
    test('loads cached language and changes it', () async {
      final storage = _MemoryStorage();
      final repo = LocalizationRepository(storage);
      await repo.cacheLanguageCode(languageCode: 'en');

      final cubit = LocalizationCubit(repo);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.langCode, 'en');

      await cubit.changeLanguage('ar');
      expect(cubit.state.langCode, 'ar');
      expect(await repo.getLanguageCode(), 'ar');
      await cubit.close();
    });

    test('changeLanguage is a no-op for the same code', () async {
      final cubit = LocalizationCubit(LocalizationRepository(_MemoryStorage()));
      await Future<void>.delayed(Duration.zero);
      final before = cubit.state;
      await cubit.changeLanguage(before.langCode);
      expect(cubit.state, before);
      await cubit.close();
    });
  });

  group('AppTheme', () {
    test('exposes light and dark themes', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.light.textTheme.bodyLarge?.fontFamily, 'Hadidi');
    });
  });
}
