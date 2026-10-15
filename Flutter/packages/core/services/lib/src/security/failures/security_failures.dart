/// Typed failures for the security layer.
///
/// Deliberately NOT extending the app-wide `Failures` sealed hierarchy
/// (sealed classes cannot be extended outside their library). Convert to a
/// `Failures` subtype at the repository/use-case boundary when needed.
sealed class SecurityFailure implements Exception {
  const SecurityFailure(this.message);
  final String message;
}

final class VaultFailure extends SecurityFailure {
  const VaultFailure(super.message, {this.cause});

  const VaultFailure.invalidPayload() : this('Invalid encrypted payload.');

  const VaultFailure.keyUnavailable() : this('Encryption key is unavailable.');

  const VaultFailure.operationFailed(String op) : this('Vault $op failed.');

  final Object? cause;
}

final class BiometricFailure extends SecurityFailure {
  const BiometricFailure(super.message);

  const BiometricFailure.unavailable()
    : this('Biometric authentication is not available on this device.');

  const BiometricFailure.lockedOut()
    : this('Too many attempts. Biometric authentication is locked.');

  const BiometricFailure.denied() : this('Authentication was not completed.');
}

/// Outcome of a biometric gate check — explicit, no boolean traps.
///
/// Named `*Outcome` to avoid clashing with the audit [SecurityEvent]s
/// (`BiometricGranted` / `BiometricDenied` in `security_event.dart`),
/// which feed analytics dashboards and must keep stable names.
sealed class BiometricOutcome {
  const BiometricOutcome();
}

final class BiometricGrantedOutcome extends BiometricOutcome {
  const BiometricGrantedOutcome();
}

final class BiometricDeniedOutcome extends BiometricOutcome {
  const BiometricDeniedOutcome(this.failure);
  final BiometricFailure failure;
}
