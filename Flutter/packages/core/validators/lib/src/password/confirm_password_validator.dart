import 'package:formz/formz.dart';

import '../base/validation_pipeline.dart';

enum ConfirmPasswordValidationError { empty, mismatch }

final class ConfirmPasswordValidator
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPasswordValidator.pure({this.password = ''}) : super.pure('');
  const ConfirmPasswordValidator.dirty({
    required this.password,
    String value = '',
  }) : super.dirty(value);

  final String password;

  @override
  ConfirmPasswordValidationError? validator(String value) {
    return ValidationPipeline<ConfirmPasswordValidationError>(value)
        .required(ConfirmPasswordValidationError.empty)
        .equals(password, ConfirmPasswordValidationError.mismatch)
        .evaluate();
  }
}

extension ConfirmPasswordValidationErrorX on ConfirmPasswordValidationError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => switch (this) {
    ConfirmPasswordValidationError.empty => 'error_password_cant_be_empty',
    ConfirmPasswordValidationError.mismatch => 'error_passwords_do_not_match',
  };

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => switch (this) {
    ConfirmPasswordValidationError.empty => 'Password can\'t be empty.',
    ConfirmPasswordValidationError.mismatch => 'Passwords do not match.',
  };
}
