import 'package:alam_el_marateb_constants/constants.dart';
import 'package:dio/dio.dart';

/// Attaches the first-party client gate headers on every request.
///
/// The backend (`ClientKeyFilter`) rejects ANY `/api/` call — login
/// included — with 401 `CLIENT_REJECTED` when these are missing, so this
/// interceptor must run before auth interceptors (order is set in
/// `buildAuthenticatedDio`). Values are app-owned: [clientName] identifies
/// the app (`customer-app`, …), [clientKey] must match the backend's
/// `app.clients.keys` (default `dev-local-key` for local dev).
final class DioClientKeyInterceptor extends Interceptor {
  const DioClientKeyInterceptor({
    required this.clientName,
    required this.clientKey,
  });

  final String clientName;
  final String clientKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiHeader.xApiClient] = clientName;
    options.headers[ApiHeader.xApiKey] = clientKey;
    handler.next(options);
  }
}
