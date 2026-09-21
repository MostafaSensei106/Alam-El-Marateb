import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:uuid/uuid.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/etag_interceptor.dart';
import 'interceptors/idempotency_interceptor.dart';
import 'interceptors/lang_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_info.dart';

/// Builds the shared Dio instance.
///
/// Interceptor order (matters):
/// 1. Trace-Id (generate `X-Trace-Id` per request when absent)
/// 2. Connectivity gate + smart retry (transient only)
/// 3. Auth (Bearer injection + single-flight 401 refresh)
/// 4. Language (`X-Lang` + `Accept-Language`)
/// 5. Idempotency (auto-key on mutating POSTs)
/// 6. ETag (conditional GET on allowlisted paths)
/// 7. Logging (debug only)
///
/// (Port of Hadidi-Win `DioFactory`, adapted: no app singletons inside
/// the package — the app injects its token/language/session callbacks.)
final class DioFactory {
  DioFactory._();

  static const defaultTimeout = Duration(seconds: 30);

  static Dio create({
    required String baseUrl,
    required TokenProvider tokenProvider,
    LanguageProvider? languageProvider,
    RefreshCallback? onRefreshToken,
    SessionExpiredCallback? onSessionExpired,
    BaseNetworkInfo? networkInfo,
    void Function(bool isConnected)? onConnectionChanged,
    bool Function(String path)? isAuthEndpoint,
    Duration timeout = defaultTimeout,
    bool enableHttp2 = true,
    bool enableLogging = true,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      ),
    );
    dio.transformer = BackgroundTransformer();
    if (enableHttp2) {
      dio.httpClientAdapter = Http2Adapter(ConnectionManager());
    }

    dio.interceptors.add(_TraceIdInterceptor());
    if (networkInfo != null) {
      dio.interceptors.add(
        DioConnectivityInterceptor(
          dio: dio,
          networkInfo: networkInfo,
          onConnectionChanged: onConnectionChanged ?? (_) {},
        ),
      );
    }
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokenProvider: tokenProvider,
        shouldRefresh: onRefreshToken,
        onSessionExpired: onSessionExpired,
        isAuthEndpoint: isAuthEndpoint ?? ((path) => path.contains('/auth/')),
      ),
    );
    if (languageProvider != null) {
      dio.interceptors.add(LangInterceptor(languageProvider));
    }
    dio.interceptors.add(IdempotencyInterceptor());
    dio.interceptors.add(EtagInterceptor());
    if (enableLogging) {
      dio.interceptors.add(createLoggingInterceptor());
    }
    return dio;
  }
}

/// Generates / propagates the `X-Trace-Id` correlation header.
///
/// The backend echoes it back and includes it in `ApiResponse.traceId`.
/// Send our ID when starting a trace; the server reuses it for log
/// correlation. Falls back to reading `ApiException.traceId` from errors.
final class _TraceIdInterceptor extends Interceptor {
  _TraceIdInterceptor({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent(
      'X-Trace-Id',
      () => _uuid.v4().replaceAll('-', '').substring(0, 16),
    );
    handler.next(options);
  }
}
