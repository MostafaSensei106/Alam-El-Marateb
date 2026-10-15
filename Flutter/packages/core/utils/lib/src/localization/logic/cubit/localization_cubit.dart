import 'dart:async';
import 'dart:ui' as ui;

import 'package:alam_el_marateb_di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:alam_el_marateb_utils/src/cache/cache_manager.dart';
import 'package:alam_el_marateb_utils/src/localization/data/interface/localization_repository_base.dart';

part 'localization_state.dart';
part 'localization_cubit.freezed.dart';

/// Owns the active language code.
///
/// Design notes vs the old monolith:
/// - Persistence goes through [LocalizationRepositoryBase] (shared-prefs)
///   instead of `HydratedCubit` — one storage story, easily mocked in tests.
/// - Supported locales arrive as plain [supportedLanguageCodes] instead of an
///   `L10nService` wrapping generated code — each app owns `gen-l10n` and
///   just passes its codes (e.g. `['ar', 'en']`).
/// - Switching language refreshes every registered cache (new headers).
@lazySingleton
class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit(
    this._repository, {
    this.supportedLanguageCodes = const ['ar', 'en'],
    this.fallbackLanguageCode = 'ar',
  }) : super(const LocalizationState(langCode: 'ar')) {
    unawaited(_init());
  }

  final LocalizationRepositoryBase _repository;
  final List<String> supportedLanguageCodes;
  final String fallbackLanguageCode;

  Future<void> _init() async {
    final cached = await _repository.getLanguageCode();
    if (isClosed) return;
    if (cached.isNotEmpty) {
      emit(LocalizationState(langCode: cached));
      return;
    }

    final systemLangCode = ui.PlatformDispatcher.instance.locale.languageCode;
    if (supportedLanguageCodes.contains(systemLangCode)) {
      emit(LocalizationState(langCode: systemLangCode));
    } else {
      emit(LocalizationState(langCode: fallbackLanguageCode));
    }
  }

  Future<void> changeLanguage(String langCode) async {
    if (state.langCode == langCode) return;
    emit(LocalizationState(langCode: langCode));
    await _repository.cacheLanguageCode(languageCode: langCode);
    // Refresh all active caches with the new language headers
    if (getIt.isRegistered<CacheManager>()) {
      await getIt<CacheManager>().refreshAllCache();
    }
  }
}
