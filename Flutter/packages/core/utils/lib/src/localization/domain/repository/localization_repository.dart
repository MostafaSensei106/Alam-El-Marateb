import 'dart:ui' as ui;

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:alam_el_marateb_services/services.dart';
import 'package:injectable/injectable.dart';

import 'package:alam_el_marateb_utils/src/localization/data/interface/localization_repository_base.dart';

@LazySingleton(as: LocalizationRepositoryBase)
final class LocalizationRepository implements LocalizationRepositoryBase {
  LocalizationRepository(this._storage);

  final PrefStorageServiceBase _storage;

  /// Locales the app supports (override per app by replacing this
  /// registration with a configured instance before dependents resolve).
  final List<String> supportedLanguageCodes = const ['ar', 'en'];
  final String fallbackLanguageCode = 'ar';

  @override
  Future<void> cacheLanguageCode({required String languageCode}) async {
    await _storage.setData<String>(
      key: PrefKeys.localizationLanguageCode,
      value: languageCode,
    );
  }

  @override
  Future<String> getLanguageCode() async {
    final cached = await _storage.getData<String>(
      key: PrefKeys.localizationLanguageCode,
    );
    if (cached != null && cached.isNotEmpty) return cached;

    final systemLangCode = ui.PlatformDispatcher.instance.locale.languageCode;
    if (supportedLanguageCodes.contains(systemLangCode)) {
      return systemLangCode;
    }
    return fallbackLanguageCode;
  }
}
