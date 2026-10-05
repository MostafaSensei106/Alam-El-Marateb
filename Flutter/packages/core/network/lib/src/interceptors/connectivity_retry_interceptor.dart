import 'package:dio/dio.dart';

import '../network_info/interface/base_network_info.dart';

/// Retries idempotent-safe failures once when the device is back online:
/// connection errors only (never 4xx/5xx — those are terminal).
class ConnectivityRetryInterceptor extends Interceptor {
  ConnectivityRetryInterceptor({required NetworkInfo networkInfo})
    : _networkInfo = networkInfo;

  final NetworkInfo _networkInfo;

  static const String retriedKey = 'connectivityRetried';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final alreadyRetried = err.requestOptions.extra[retriedKey] == true;
    final isConnectionFailure =
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout;
    if (!alreadyRetried && isConnectionFailure) {
      if (await _networkInfo.isConnected) {
        try {
          final dio = Dio(
            BaseOptions(
              baseUrl: err.requestOptions.baseUrl,
              connectTimeout: err.requestOptions.connectTimeout,
              receiveTimeout: err.requestOptions.receiveTimeout,
              sendTimeout: err.requestOptions.sendTimeout,
            ),
          );
          final retry = err.requestOptions..extra[retriedKey] = true;
          final response = await dio.fetch<dynamic>(retry);
          handler.resolve(response);
          return;
        } catch (_) {
          // Single retry failed — surface the original failure below.
        }
      }
    }
    handler.next(err);
  }
}
