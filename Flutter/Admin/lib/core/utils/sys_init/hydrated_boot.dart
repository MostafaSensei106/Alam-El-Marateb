import 'package:bloc_signals_hydrate/bloc_signals_hydrate.dart';

/// Fail-closed boot decisions for hydrated state persistence.
///
/// There is deliberately NO plaintext fallback: if the secure backend cannot
/// be established, persistence is disabled ([DisabledStorage]) instead of
/// silently downgrading to an unencrypted store.
enum HydratedBootDecision {
  /// Secure storage is available: hydrated state is persisted and encrypted
  /// by the platform keystore (Keychain / Keystore).
  secureStorage,

  /// Secure storage is unavailable (missing plugin, locked keystore, I/O):
  /// persistence is disabled for this boot. Never plaintext.
  persistenceDisabled,
}

/// Fail-closed [HydratedStorage]: all reads miss, all writes are dropped.
///
/// Used when the secure backend cannot be established. The app keeps running
/// (availability) but persists nothing (confidentiality) — strictly better
/// than a silent plaintext downgrade.
final class DisabledStorage implements HydratedStorage {
  const DisabledStorage();

  @override
  dynamic read(String key) => null;

  @override
  Future<void> write(String key, dynamic value) async {}

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> clear() async {}
}
