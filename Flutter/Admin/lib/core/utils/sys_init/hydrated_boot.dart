import 'dart:io';

/// Fail-closed boot plan for HydratedBloc storage.
///
/// There is deliberately NO plaintext fallback: if encryption cannot be
/// established, persistence is disabled ([DisabledStorage]) instead of
/// silently downgrading. A silent downgrade would write fresh sensitive
/// data unencrypted while the rest of the app assumes encrypted storage.
enum HydratedBootDecision {
  /// No box files on disk: create a fresh encrypted box.
  freshEncrypted,

  /// Box files exist but no cipher key was ever stored: this is the legacy
  /// plaintext install. Quarantine the old files (recoverable) and rebuild
  /// an empty encrypted box. Cached cubits re-fetch from the network; the
  /// auth token lives in secure storage and is unaffected.
  migrateLegacy,

  /// Box files exist AND a key pre-existed, yet the box cannot be opened:
  /// the cause (lost key, corruption, I/O) is unknown, so the files are
  /// quarantined for forensics and persistence is disabled. Never deleted.
  quarantineAndDisable,

  /// No cipher could be established (secure storage unavailable):
  /// persistence disabled. Never plaintext.
  persistenceDisabled,
}

/// Pure, unit-testable boot matrix.
///
/// - [cipherAvailable]: a 32-byte cipher key could be loaded or generated.
/// - [keyExisted]: a key was already stored before this boot (i.e. this is
///   NOT a first run and any existing box was written encrypted).
/// - [boxExists]: `hydrated_box` files are present on disk.
HydratedBootDecision resolveHydratedBoot({
  required bool cipherAvailable,
  required bool keyExisted,
  required bool boxExists,
}) {
  if (!cipherAvailable) return HydratedBootDecision.persistenceDisabled;
  if (!boxExists) return HydratedBootDecision.freshEncrypted;
  if (!keyExisted) return HydratedBootDecision.migrateLegacy;
  // Key exists but the box may still fail to open (checked by the caller
  // attempting the open); the pre-open plan is freshEncrypted, and any
  // open failure degrades to quarantineAndDisable — never delete, never
  // plaintext.
  return HydratedBootDecision.freshEncrypted;
}

/// Post-open failure escalation for the [keyExisted] case.
///
/// The box could not be opened WITH the pre-existing key: cause unknown
/// (key mismatch, corruption, I/O). Quarantine for forensics and disable
/// persistence. Deleting would destroy potentially irrecoverable user data.
HydratedBootDecision resolveHydratedOpenFailure() =>
    HydratedBootDecision.quarantineAndDisable;

/// Fail-closed [Storage]: all reads miss, all writes are dropped.
///
/// Used when encryption cannot be established or an encrypted box is
/// unreadable. The app keeps running (availability) but persists nothing
/// (confidentiality) — strictly better than a silent plaintext downgrade.
final class DisabledStorage implements Storage {
  const DisabledStorage();
  @override
  dynamic read(String key) => null;

  @override
  Future<void> write(String key, dynamic value) async {}

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> clear() async {}

  @override
  Future<void> close() async {}
}

/// Filesystem side of the boot plan, operating on an injected [directory]
/// so it stays unit-testable without `path_provider`.
///
/// Quarantine RENAMES (`hydrated_box.hive` →
/// `hydrated_box.quarantine-<epoch>.hive`) instead of deleting, so a wrong
/// guess (e.g. transient I/O error misread as legacy data) stays recoverable.
/// Sibling data such as `dio_cache/` is never touched.
final class HydratedBoxFiles {
  HydratedBoxFiles(this.directory);

  final Directory directory;

  static const _boxBase = 'hydrated_box';
  static const _suffixes = ['.hive', '.lock'];

  bool get boxExists =>
      _suffixes.any((s) => File('${directory.path}/$_boxBase$s').existsSync());

  /// Renames existing box files with a quarantine timestamp.
  /// Returns the number of files quarantined.
  Future<int> quarantine() async {
    var count = 0;
    final stamp = DateTime.now().millisecondsSinceEpoch;
    for (final suffix in _suffixes) {
      final file = File('${directory.path}/$_boxBase$suffix');
      try {
        if (await file.exists()) {
          await file.rename(
            '${directory.path}/$_boxBase.quarantine-$stamp$suffix',
          );
          count++;
        }
      } catch (_) {
        // Best effort: the caller decides the outcome from the count.
      }
    }
    return count;
  }
}
