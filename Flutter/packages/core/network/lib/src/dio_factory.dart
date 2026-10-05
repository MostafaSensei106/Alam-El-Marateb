import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'interceptors/auth_token_interceptor.dart';
import 'interceptors/client_key_interceptor.dart';
import 'interceptors/connectivity_retry_interceptor.dart';
import 'interceptors/locale_interceptor.dart';
import 'network_config.dart';
import 'network_info/interface/base_network_info.dart';
import 'token_storage.dart';

/// Builds the shared Dio instance for an app flavor.
///
/// Wiring order matters: client-key → locale → auth → connectivity → logger.
/// The logger stays last so it records the final headers of each attempt.
class DioFactory {
  const DioFactory._();

  static Dio create({
    required NetworkConfig config,
    required TokenStorage tokenStorage,
    required RefreshTokens onRefresh,
    required Future<void> Function() onSessionExpired,
    required BaseNetworkInfo networkInfo,
    required String Function() languageProvider,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        headers: const <String, dynamic>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    )..transformer = BackgroundTransformer();
    dio.interceptors.addAll(<Interceptor>[
      ClientKeyInterceptor(config),
      LocaleInterceptor(languageProvider: languageProvider),
      AuthTokenInterceptor(
        storage: tokenStorage,
        onRefresh: onRefresh,
        onSessionExpired: onSessionExpired,
        retryClient: () => dio,
      ),
      ConnectivityRetryInterceptor(networkInfo: networkInfo),
      if (config.enableLogging && kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
    ]);
    return dio;
  }
}
