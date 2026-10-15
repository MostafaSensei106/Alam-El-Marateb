abstract interface class LocalizationRepositoryBase {
  /// Locales the app supports.
  List<String> get supportedLanguageCodes;

  /// Last-resort code when neither cache nor system locale matches.
  String get fallbackLanguageCode;

  Future<void> cacheLanguageCode({required String languageCode});
  Future<String> getLanguageCode();
}
