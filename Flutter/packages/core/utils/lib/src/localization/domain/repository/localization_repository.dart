import 'package:injectable/injectable.dart';
import 'package:utils/src/localization/data/interface/localization_repository_base.dart';

@LazySingleton(as: LocalizationRepositoryBase)
final class LocalizationRepository implements LocalizationRepositoryBase {
  LocalizationRepository({required this._localizationService, required this._storageFacad})

  final StorageFacad _storageFacad;
  final globalLocalizationService _localizationService;

  @override
  Future<void> cacheLanguageCode({required String languageCode}) {
    throw UnimplementedError();
  }

  @override
  Future<String> getLanguageCode() {
    throw UnimplementedError();
  }
}
