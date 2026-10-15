import 'package:alam_el_marateb_validators/validators.dart';
import 'package:test/test.dart';

void main() {
  group('EmailValidator', () {
    test('pure is invalid', () {
      expect(const EmailValidator.pure().isValid, isFalse);
    });

    test('accepts valid email', () {
      expect(
        const EmailValidator.dirty('user@example.com').isValid,
        isTrue,
      );
    });

    test('rejects empty', () {
      const v = EmailValidator.dirty('');
      expect(v.isValid, isFalse);
      expect(v.error, EmailValidationError.empty);
    });

    test('rejects missing @', () {
      const v = EmailValidator.dirty('userexample.com');
      expect(v.error, EmailValidationError.missingAtSign);
    });

    test('rejects uppercase', () {
      const v = EmailValidator.dirty('User@example.com');
      expect(v.error, EmailValidationError.notInLowerCase);
    });

    test('exposes stable message ids', () {
      expect(
        EmailValidationError.empty.messageId,
        'error_email_cant_be_empty',
      );
      expect(EmailValidationError.empty.defaultMessage, isNotEmpty);
    });
  });

  group('PasswordValidator', () {
    test('accepts strong password', () {
      expect(const PasswordValidator.dirty('Abcdef1@').isValid, isTrue);
    });

    test('rejects short password', () {
      const v = PasswordValidator.dirty('Ab1@');
      expect(v.error, PasswordValidationError.minLength);
    });

    test('rejects weak password', () {
      const v = PasswordValidator.dirty('abcdefgh');
      expect(v.error, PasswordValidationError.invalid);
    });
  });

  group('ConfirmPasswordValidator', () {
    test('accepts matching passwords', () {
      expect(
        const ConfirmPasswordValidator.dirty(
          password: 'Abcdef1@',
          value: 'Abcdef1@',
        ).isValid,
        isTrue,
      );
    });

    test('rejects mismatch', () {
      const v = ConfirmPasswordValidator.dirty(
        password: 'Abcdef1@',
        value: 'other',
      );
      expect(v.error, ConfirmPasswordValidationError.mismatch);
    });
  });

  group('PhoneNumberValidator', () {
    test('accepts valid phone', () {
      expect(
        const PhoneNumberValidator.dirty('01012345678').isValid,
        isTrue,
      );
    });

    test('rejects empty', () {
      expect(
        const PhoneNumberValidator.dirty('').error,
        PhoneNumberValidation.empty,
      );
    });
  });

  group('NameValidator', () {
    test('accepts valid name', () {
      expect(const NameValidator.dirty('Ahmed Mohamed').isValid, isTrue);
    });

    test('rejects short name', () {
      expect(
        const NameValidator.dirty('Ab').error,
        NameValidatorError.tooShort,
      );
    });

    test('rejects emoji as invalid (pipeline order: letters check first)', () {
      // NOTE: matches the mono behavior — the name-letters check runs
      // before the emoji check, so emoji input reports `invalid`.
      expect(
        const NameValidator.dirty('Ahmed 😀').error,
        NameValidatorError.invalid,
      );
    });
  });

  group('Address validators', () {
    test('address line accepts normal input', () {
      // NOTE: `,` and `.` are in the invalid-special-chars set (mono
      // behavior), so the sample input avoids them.
      expect(
        const AddressLineValidator.dirty('12 Tahrir St Cairo').isValid,
        isTrue,
      );
    });

    test('city rejects empty', () {
      expect(const CityValidator.dirty('').error, CityValidatorError.empty);
    });

    test('label enforces max length', () {
      final long = List.filled(kAddressLabelMaxLength + 1, 'a').join();
      expect(
        AddressLabelValidator.dirty(long).error,
        AddressLabelValidatorError.tooLong,
      );
    });
  });

  group('Login validators', () {
    test('login phone requires value', () {
      expect(
        const LoginPhoneValidator.dirty('').error,
        LoginPhoneValidationError.empty,
      );
      expect(
        const LoginPhoneValidator.dirty('01012345678').isValid,
        isTrue,
      );
    });

    test('login password requires value', () {
      expect(
        const LoginPasswordValidator.dirty('secret').isValid,
        isTrue,
      );
    });
  });

  group('RegisterParams', () {
    test('isValid only when all fields valid', () {
      const params = RegisterParams(
        name: NameValidator.dirty('Ahmed Mohamed'),
        email: EmailValidator.dirty('user@example.com'),
        password: PasswordValidator.dirty('Abcdef1@'),
        phone: PhoneNumberValidator.dirty('01012345678'),
        governorate: GovernorateValidator.dirty(1),
      );
      expect(params.isValid, isTrue);

      const invalid = RegisterParams(
        name: NameValidator.dirty('Ahmed Mohamed'),
        email: EmailValidator.dirty('bad'),
        password: PasswordValidator.dirty('Abcdef1@'),
        phone: PhoneNumberValidator.dirty('01012345678'),
        governorate: GovernorateValidator.dirty(1),
      );
      expect(invalid.isValid, isFalse);
    });

    test('governorate rejects null and zero', () {
      expect(
        const GovernorateValidator.dirty(null).error,
        GovernorateValidatorError.empty,
      );
      expect(
        const GovernorateValidator.dirty(0).error,
        GovernorateValidatorError.empty,
      );
    });
  });
}
