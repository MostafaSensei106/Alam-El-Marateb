/// Static configuration for one app flavor. Built by the app's
/// bootstrap (flavor config) and handed to [DioFactory] — never hardcoded
/// inside shared code.
class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,
    required this.clientId,
    required this.clientKey,
    this.connectTimeout = const Duration(seconds: 20),
    this.receiveTimeout = const Duration(seconds: 20),
    this.sendTimeout = const Duration(seconds: 20),
    this.enableLogging = false,
    this.defaultLanguage = 'ar',
  });

  final String baseUrl;
  final String clientId;
  final String clientKey;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final bool enableLogging;
  final String defaultLanguage;
}
