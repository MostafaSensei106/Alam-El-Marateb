/// Compile-time flavor configuration.
enum AppFlavor { dev, staging, prod }

/// Static app identity for this flavor. Backend client-gate keys must
/// allowlist [clientKey] (see backend CLIENT_KEYS).
class AppConfig {
  const AppConfig._();

  static AppFlavor get flavor => _parseFlavor(
    const String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
  );

  static AppFlavor _parseFlavor(String value) => AppFlavor.values.firstWhere(
    (flavor) => flavor.name == value,
    orElse: () => AppFlavor.dev,
  );

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String clientId = String.fromEnvironment(
    'CLIENT_ID',
    defaultValue: 'customer-app',
  );

  static const String clientKey = String.fromEnvironment(
    'CLIENT_KEY',
    defaultValue: 'dev-local-key',
  );

  static const String defaultLanguage = 'ar';
  static const String appName = 'Alam El Marateb — Customer';
}
