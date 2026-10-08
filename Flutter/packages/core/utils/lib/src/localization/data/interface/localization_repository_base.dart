abstract interface class LocalizationRepositoryBase {
  Future<void> cacheLanguageCode({required String languageCode});
  Future<String> getLanguageCode();
}
