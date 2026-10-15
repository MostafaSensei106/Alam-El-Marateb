import 'package:formz/formz.dart';

import '../base/validation_pipeline.dart';

final _strongPasswordRegExp = RegExp(
  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$',
);

enum PasswordValidationError { empty, invalid, minLength }

final class PasswordValidator
    extends FormzInput<String, PasswordValidationError> {
  const PasswordValidator.pure() : super.pure('');
  const PasswordValidator.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    return ValidationPipeline<PasswordValidationError>(value)
        .required(PasswordValidationError.empty)
        .minLength(8, PasswordValidationError.minLength)
        .matches(_strongPasswordRegExp, PasswordValidationError.invalid)
        .evaluate();
  }
}

extension PasswordValidationErrorX on PasswordValidationError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => switch (this) {
    PasswordValidationError.empty => 'error_password_cant_be_empty',
    PasswordValidationError.invalid => 'error_password_must_contain_uppercase_lowercase_number_and_special_character',
    PasswordValidationError.minLength =>
      'error_password_must_be_at_least_8_characters_long',
  };

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => switch (this) {
    PasswordValidationError.empty => 'Password can\'t be empty.',
    PasswordValidationError.invalid => 'Password must contain uppercase, lowercase, number and special character.',
    PasswordValidationError.minLength =>
      'Password must be at least 8 characters long.',
  };
}
