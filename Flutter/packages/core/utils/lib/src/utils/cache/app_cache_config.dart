import 'package:nested/nested.dart';

/// App-composed prefetch registry for offline-first caching and
/// background prefetching.
///
/// The shared package cannot know app modules, so each app registers
/// its own providers once at startup:
///
/// ```dart
/// AppCacheConfig.register([
///   BlocProvider(create: (_) => getIt<ProfileCubit>()..load()),
/// ]);
/// ```
///
/// Keeps the original contract (`prefetchProviders`) while staying
/// open for extension without modifying shared code.
final class AppCacheConfig {
  const AppCacheConfig._();

  static final List<SingleChildWidget> _providers = <SingleChildWidget>[];

  static void register(List<SingleChildWidget> providers) {
    _providers.addAll(providers);
  }

  static List<SingleChildWidget> get prefetchProviders =>
      List<SingleChildWidget>.unmodifiable(_providers);
}
