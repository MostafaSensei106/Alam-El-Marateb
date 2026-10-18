import 'package:nested/nested.dart';

/// Centralized configuration for all modules that require offline-first caching
/// and background prefetching.
///
/// This adheres to the Open-Closed Principle (OCP) and Single Responsibility
/// Principle (SRP). If a new module needs to be prefetched, it should be
/// added here without modifying the UI layer.
final class AppCacheConfig {
  const AppCacheConfig._();
  static List<SingleChildWidget> get prefetchProviders => [];
}
