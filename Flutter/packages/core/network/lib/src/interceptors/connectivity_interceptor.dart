import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import 'network_info/interface_placeholder.dart'
    if (dart.library.io) 'network_info.dart';

export 'network_info.dart';

export 'network_info.dart';

/// Intercepts every request to:
/// 1. Block immediately when no adapter is on (typed `connectionError`,
///    no wasted round-trips).
/// 2. Retry only transient failures (drops, timeouts, 502/503/504) with
///    exponential back-off — never 4xx/500/501.
/// 3. Report real connectivity changes via [onConnectionChanged].
///
/// (Port of Hadidi-Win `DioConnectivityInterceptor`, decoupled from the
/// app's `NetworkCubit`: the app passes a callback instead.)
final class DioConnectivityInterceptor extends Interceptor {
  DioConnectivityInterceptor({
    required Dio dio,
    required this.networkInfo,
    required this.onConnectionChanged,
    this.logger,
  }) {
    _retryInterceptor = RetryInterceptor(
      dio: dio,
      logPrint: logger ?? _noopLogger,
      retries: _retryDelays.length,
      retryDelays: _retryDelays,
      retryEvaluator: (DioException error, int attempt) async {
        final shouldRetry = _isTransientNetworkError(error);
        if (shouldRetry) {
          logger?.call(
            '[Retry] attempt $attempt — ${error.type}: ${error.message}',
          );
        }
        return shouldRetry;
      },
    );
  }

  final BaseNetworkInfo networkInfo;
  final void Function(bool isConnected) onConnectionChanged;
  final void Function(String message)? logger;

  late final RetryInterceptor _retryInterceptor;

  static const _retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
  ];

  static const _retryableStatusCodes = {502, 503, 504};

  static void _noopLogger(String _) {}

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final hasConnection = await networkInfo.isConnected;
    if (!hasConnection) {
      onConnectionChanged(false);
      logger?.call('[Connectivity] Request blocked — no network available.');
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const SocketException('No network available'),
          message: 'No internet connection. Please check your network.',
        ),
      );
    }
    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    onConnectionChanged(true);
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isTransientNetworkError(err)) {
      logger?.call(
        '[Retry] Transient error — starting retry: ${err.type}'
        '${err.response?.statusCode != null ? ' (${err.response!.statusCode})' : ''}',
      );
      return _retryInterceptor.onError(err, handler);
    }
    return handler.next(err);
  }

  bool _isTransientNetworkError(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionError => _isConnectivityCause(err.error),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => true,
      DioExceptionType.badResponse => _retryableStatusCodes.contains(
        err.response?.statusCode,
      ),
      _ => false,
    };
  }

  bool _isConnectivityCause(Object? cause) {
    if (cause is TlsException) return false;
    if (cause is SocketException) return true;
    if (cause is HttpException) return true;
    return true;
  }
}
