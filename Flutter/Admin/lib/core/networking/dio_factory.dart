import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_header.dart';
import '../constants/security_configs.dart';
import '../services/session/user_session_service.dart';
import '../utils/localization/logic/cubit/localization_cubit.dart';
import 'dio_cache_interceptor_setup.dart';
import 'dio_certificate_pinning_interceptor.dart';
import 'dio_locale_interceptor.dart';
import 'dio_retry_interceptor.dart';
import 'dio_token_interceptor.dart';
import 'network_timeouts.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Future<Dio> getDio({
    required LocalizationCubit localizationCubit,
    required BaseUserSessionService userSessionService,
    required String cacheStoragePath,
  }) async {
    if (dio == null) {
      dio = Dio();
      dio!.transformer = BackgroundTransformer();
      dio!.httpClientAdapter = Http2Adapter(ConnectionManager());
      dio!
        ..options.headers[ApiHeader.accept] = ApiHeader.applicationJson
        ..options.headers[ApiHeader.contentType] = ApiHeader.applicationJson
        ..options.connectTimeout = NetworkTimeouts.connect
        ..options.receiveTimeout = NetworkTimeouts.receive
        ..options.sendTimeout = NetworkTimeouts.send;
      addDioInterceptors(
        localizationCubit: localizationCubit,
        userSessionService: userSessionService,
        cacheStoragePath: cacheStoragePath,
      );
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptors({
    required LocalizationCubit localizationCubit,
    required BaseUserSessionService userSessionService,
    required String cacheStoragePath,
  }) {
    dio?.interceptors.add(DioTokenInterceptor(userSessionService));
    dio?.interceptors.add(DioLocaleInterceptor(localizationCubit));

    dio?.interceptors.add(DioRetryInterceptor(dio: dio!));

    dio?.interceptors.add(
      CacheConfig.createInterceptor(storagePath: cacheStoragePath),
    );

    if (SecurityConfigs.enableCertificatePinning &&
        (Platform.isAndroid || Platform.isIOS)) {
      dio?.interceptors.add(createCertificatePinningInterceptor());
    }

    if (kDebugMode) {
      dio?.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }
  }
}
