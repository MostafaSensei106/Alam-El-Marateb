import 'package:get_it/get_it.dart';

/// Global service locator for core packages.
///
/// Each app calls [configureCoreDependencies] during boot, then registers
/// its own feature dependencies. Domain-specific resets (cart, wishlist,
/// …) live in `packages/modules/*`, never here — this package stays
/// domain-free so a bug fix propagates to all apps from one place.
final GetIt getIt = GetIt.instance;

/// Placeholder — full injectable wiring lands in Phase 5 (composition).
/// Kept async so app boot code doesn't need to change later.
Future<void> configureCoreDependencies() async {
  // No-op for now. Generated `di.config.dart` will be wired here.
}
