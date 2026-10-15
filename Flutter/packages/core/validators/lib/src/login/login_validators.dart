import 'package:formz/formz.dart';

import '../base/validation_pipeline.dart';

enum LoginPhoneValidationError { empty }

final class LoginPhoneValidator
    extends FormzInput<String, LoginPhoneValidationError> {
  const LoginPhoneValidator.pure() : super.pure('');
  const LoginPhoneValidator.dirty([super.value = '']) : super.dirty();

  @override
  LoginPhoneValidationError? validator(String value) {
    return ValidationPipeline<LoginPhoneValidationError>(value)
        .required(LoginPhoneValidationError.empty)
        .evaluate();
  }
}

extension LoginPhoneValidationErrorX on LoginPhoneValidationError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => 'error_phone_number_cant_be_empty';

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => 'Phone number can\'t be empty.';
}

enum LoginPasswordValidationError { empty }

final class LoginPasswordValidator
    extends FormzInput<String, LoginPasswordValidationError> {
  const LoginPasswordValidator.pure() : super.pure('');
  const LoginPasswordValidator.dirty([super.value = '']) : super.dirty();

  @override
  LoginPasswordValidationError? validator(String value) {
    return ValidationPipeline<LoginPasswordValidationError>(value)
        .required(LoginPasswordValidationError.empty)
        .evaluate();
  }
}

extension LoginPasswordValidationErrorX on LoginPasswordValidationError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => 'error_password_cant_be_empty';

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => 'Password can\'t be empty.';
}
