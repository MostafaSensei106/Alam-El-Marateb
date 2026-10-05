import 'package:dio/dio.dart';

import '../headers.dart';
import '../network_config.dart';

/// Attaches first-party client identity to every request.
/// Without these headers the backend answers 401 CLIENT_REJECTED.
class ClientKeyInterceptor extends Interceptor {
  const ClientKeyInterceptor(this._config);

  final NetworkConfig _config;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiHeaders.apiClient] = _config.clientId;
    options.headers[ApiHeaders.apiKey] = _config.clientKey;
    handler.next(options);
  }
}
