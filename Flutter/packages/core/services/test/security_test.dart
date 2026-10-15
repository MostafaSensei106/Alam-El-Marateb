import 'package:alam_el_marateb_services/services.dart';
import 'package:test/test.dart';

void main() {
  group('RedactionPolicy', () {
    const policy = RedactionPolicy();

    test('detects sensitive keys', () {
      expect(policy.isSensitiveKey('userToken'), isTrue);
      expect(policy.isSensitiveKey('password'), isTrue);
      expect(policy.isSensitiveKey('authorization'), isTrue);
      expect(policy.isSensitiveKey('fcmToken'), isTrue);
      expect(policy.isSensitiveKey('userName'), isFalse);
      expect(policy.isSensitiveKey('couponCode'), isFalse);
    });

    test('redacts sensitive map values only', () {
      final out = policy.redactMap({
        'host': 'api.example.com',
        'userToken': 'secret-123',
      });
      expect(out['host'], 'api.example.com');
      expect(out['userToken'], RedactionPolicy.redactedValue);
    });

    test('redacts errors carrying secrets', () {
      expect(
        policy.redactError(Exception('invalid password xyz')),
        'Redacted security error',
      );
      expect(
        policy.redactError(Exception('plain failure')),
        isA<Exception>(),
      );
    });

    test('redacts bearer tokens in text', () {
      final out = policy.redactText('call with Bearer abc123 failed');
      expect(out, contains(RedactionPolicy.redactedValue));
      expect(out, isNot(contains('abc123')));
    });
  });

  group('SecurityFailure', () {
    test('vault factories carry messages', () {
      expect(
        const VaultFailure.invalidPayload().message,
        contains('payload'),
      );
      expect(
        const VaultFailure.keyUnavailable().message,
        contains('unavailable'),
      );
      expect(
        const VaultFailure.operationFailed('encrypt').message,
        contains('encrypt'),
      );
    });

    test('biometric outcome carries failure', () {
      const outcome = BiometricDeniedOutcome(
        BiometricFailure.denied(),
      );
      expect(outcome.failure.message, isNotEmpty);
      expect(const BiometricGrantedOutcome(), isA<BiometricOutcome>());
    });
  });
}
