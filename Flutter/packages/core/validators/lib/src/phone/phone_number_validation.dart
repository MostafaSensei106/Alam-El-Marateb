import 'package:formz/formz.dart';

import '../base/validation_pipeline.dart';

final _phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

enum PhoneNumberValidation { empty, invalid, minLength }

final class PhoneNumberValidator
    extends FormzInput<String, PhoneNumberValidation> {
  const PhoneNumberValidator.pure() : super.pure('');
  const PhoneNumberValidator.dirty([super.value = '']) : super.dirty();

  @override
  PhoneNumberValidation? validator(String value) {
    return ValidationPipeline<PhoneNumberValidation>(value)
        .required(PhoneNumberValidation.empty)
        .matches(_phoneRegExp, PhoneNumberValidation.invalid)
        .minLength(11, PhoneNumberValidation.minLength)
        .evaluate();
  }
}

extension PhoneNumberValidationX on PhoneNumberValidation {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => switch (this) {
    PhoneNumberValidation.empty => 'error_phone_number_cant_be_empty',
    PhoneNumberValidation.invalid => 'error_phone_number_invalid',
    PhoneNumberValidation.minLength => 'error_phone_number_min_length',
  };

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => switch (this) {
    PhoneNumberValidation.empty => 'Phone number can\'t be empty.',
    PhoneNumberValidation.invalid => 'Invalid phone number.',
    PhoneNumberValidation.minLength =>
      'Phone number must be at least 11 digits.',
  };
}
