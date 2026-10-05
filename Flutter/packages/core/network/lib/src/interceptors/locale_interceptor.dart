import 'package:dio/dio.dart';

import '../headers.dart';

/// Sends the current locale on every request (`X-Lang: ar|en`).
class LocaleInterceptor extends Interceptor {
  LocaleInterceptor({required this._languageProvider});

  final String Function() _languageProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiHeaders.language] = _languageProvider();
    handler.next(options);
  }
}
