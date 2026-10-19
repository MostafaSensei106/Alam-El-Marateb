import 'package:alam_el_marateb_admin/core/services/security/audit/redaction_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = RedactionPolicy();

  group('RedactionPolicy.redactMap', () {
    test('redacts sensitive keys and keeps the rest', () {
      final result = policy.redactMap({
        'email': 'user@example.com',
        'password': 'hunter2',
        'authorization': 'Bearer abc.def',
        'couponCode': 'SUMMER',
      });

      expect(result['email'], 'user@example.com');
      expect(result['couponCode'], 'SUMMER');
      expect(result['password'], RedactionPolicy.redactedValue);
      expect(result['authorization'], RedactionPolicy.redactedValue);
    });

    test('returns an empty map for null or empty input', () {
      expect(policy.redactMap(null), isEmpty);
      expect(policy.redactMap({}), isEmpty);
    });
  });

  group('RedactionPolicy.redactError', () {
    test('collapses errors that mention secrets', () {
      expect(
        policy.redactError(Exception('invalid token 123')),
        'Redacted security error',
      );
    });

    test('passes through safe errors untouched', () {
      final error = Exception('network unreachable');
      expect(policy.redactError(error), same(error));
    });
  });

  group('RedactionPolicy.redactText', () {
    test('masks bearer credentials in place', () {
      expect(policy.redactText('header: Bearer abc123'), 'header: Bearer ***');
    });

    test('collapses lines containing other secret markers', () {
      expect(policy.redactText('password=hunter2'), 'Redacted security error');
    });
  });
}
