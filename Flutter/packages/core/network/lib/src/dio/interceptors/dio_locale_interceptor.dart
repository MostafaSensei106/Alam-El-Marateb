import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';

/// Provides the current language code (e.g. `ar`, `en`).
/// Implemented by the app (usually reads `LocalizationCubit.state.langCode`)
/// so the network package never depends on localization state directly.
typedef LanguageCodeProvider = String Function();

final class DioLocaleInterceptor extends Interceptor {
  DioLocaleInterceptor(this._getLanguageCode);

  final LanguageCodeProvider _getLanguageCode;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final lang = _getLanguageCode();
    options.headers[ApiHeader.locale] = lang;
    options.headers[ApiHeader.acceptLanguage] = lang;
    handler.next(options);
  }
}
