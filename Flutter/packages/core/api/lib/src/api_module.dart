import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

/// Backend environments. The `/api/v1` prefix lives in route constants,
/// so environments only carry the origin.
enum AppEnvironment {
  dev('https://dev-api.alamelmarateb.example.com'),
  staging('https://staging-api.alamelmarateb.example.com'),
  prod('https://api.alamelmarateb.example.com');

  const AppEnvironment(this.origin);
  final String origin;
}

/// Composition root: builds the shared Dio for an app. The app supplies
/// storage-backed callbacks; this package owns the backend contract.
Dio buildAlamMaratebDio({
  required AppEnvironment environment,
  required TokenProvider tokenProvider,
  required LanguageProvider languageProvider,
  RefreshCallback? onRefreshToken,
  SessionExpiredCallback? onSessionExpired,
  BaseNetworkInfo? networkInfo,
  void Function(bool isConnected)? onConnectionChanged,
}) {
  return DioFactory.create(
    baseUrl: environment.origin,
    tokenProvider: tokenProvider,
    languageProvider: languageProvider,
    onRefreshToken: onRefreshToken,
    onSessionExpired: onSessionExpired,
    networkInfo: networkInfo,
    onConnectionChanged: onConnectionChanged,
    isAuthEndpoint: _isAuthEndpoint,
  );
}

bool _isAuthEndpoint(String path) {
  return path.contains('/auth/refresh') ||
      path.contains('/auth/login') ||
      path.contains('/auth/register') ||
      path.contains('/auth/forgot-password') ||
      path.contains('/auth/reset-password');
}

/// Marks a request public (skips bearer injection).
Map<String, dynamic> publicExtra() => {requireTokenKey: false};
