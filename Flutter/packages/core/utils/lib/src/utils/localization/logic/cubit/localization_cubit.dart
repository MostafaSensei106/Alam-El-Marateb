import 'dart:async';
import 'dart:ui' as ui;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../di/di.dart';
import '../../../../services/l10n/l10n_service.dart';
import '../../../cache/cache_manager.dart';

part 'localization_state.dart';
part 'localization_cubit.freezed.dart';

@lazySingleton
class LocalizationCubit extends HydratedCubit<LocalizationState> {
  LocalizationCubit({required L10nService l10nService})
    : super(_getInitialState(l10nService));

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
    if (state.langCode == langCode) return;
    emit(LocalizationState(langCode: langCode));
    // Refresh all active caches with the new language headers
    await getIt<CacheManager>().refreshAllCache();
  }

  @override
  LocalizationState? fromJson(Map<String, dynamic> json) {
    final langCode = json['langCode'] as String?;
    if (langCode == null || langCode.isEmpty) return null;
    return LocalizationState(langCode: langCode);
  }

  @override
  Map<String, dynamic>? toJson(LocalizationState state) {
    return {'langCode': state.langCode};
  }
}
