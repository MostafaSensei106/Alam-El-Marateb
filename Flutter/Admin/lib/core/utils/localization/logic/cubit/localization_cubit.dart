import 'dart:async';
import 'dart:ui' as ui;

import 'package:bloc_signals_hydrate/bloc_signals_hydrate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../services/l10n/l10n_service.dart';

part 'localization_cubit.freezed.dart';
part 'localization_state.dart';

@lazySingleton
class LocalizationCubit extends HydratedCubitSignal<LocalizationState> {
  LocalizationCubit({required L10nService l10nService})
    : _l10nService = l10nService,
      super(initialState: _getInitialState(l10nService));

  final L10nService _l10nService;

  static LocalizationState _getInitialState(L10nService l10nService) {
    final systemLangCode = ui.PlatformDispatcher.instance.locale.languageCode;
    final supportedCodes = l10nService.supportedLocales.map(
      (e) => e.languageCode,
    );

    if (supportedCodes.contains(systemLangCode)) {
      return LocalizationState(langCode: systemLangCode);
    }

    return LocalizationState(
      langCode: l10nService.supportedLocales.first.languageCode,
    );
  }

  Future<void> changeLanguage(String langCode) async {
    if (state.value.langCode == langCode) return;
    emit(LocalizationState(langCode: langCode));
    //    await getIt<CacheManager>().refreshAllCache();
  }

  Future<void> toggleLanguage() async {
    final supportedLocales = _l10nService.supportedLocales;
    if (supportedLocales.isEmpty) return;

    final currentIndex = supportedLocales.indexWhere(
      (locale) => locale.languageCode == state.value.langCode,
    );
    final nextIndex = (currentIndex + 1) % supportedLocales.length;
    await changeLanguage(supportedLocales[nextIndex].languageCode);
  }

  @override
  LocalizationState? fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    final langCode = json['langCode'] as String?;
    if (langCode == null || langCode.isEmpty) return null;
    return LocalizationState(langCode: langCode);
  }

  @override
  Map<String, dynamic>? toJson(LocalizationState state) {
    return {'langCode': state.langCode};
  }
}
