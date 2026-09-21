import 'package:dio/dio.dart';

/// Provides the current UI language code (`ar` | `en`).
typedef LanguageProvider = String Function();

/// Sends the backend i18n headers.
///
/// Backend resolves messages + translated catalog content from the
/// `X-Lang` header (`ar` | `en`, default `ar`). `Accept-Language` is
/// sent alongside for CDN / proxy compatibility.
/// (Port of Hadidi-Win `DioLocaleInterceptor`, header renamed to `X-Lang`.)
final class LangInterceptor extends Interceptor {
  LangInterceptor(this._languageProvider);

  final LanguageProvider _languageProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final lang = _languageProvider().toLowerCase();
    final normalized = (lang == 'en' || lang == 'ar') ? lang : 'ar';
    options.headers['X-Lang'] = normalized;
    options.headers['Accept-Language'] = normalized;
    handler.next(options);
  }
}
