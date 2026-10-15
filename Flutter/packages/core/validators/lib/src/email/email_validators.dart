import 'package:formz/formz.dart';

import '../base/validation_pipeline.dart';

final _emailRegExp = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);
final _arabicRegExp = RegExp(
  r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
);
final _emojiRegExp = RegExp(
  r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
  unicode: true,
);

enum EmailValidationError {
  empty,
  invalid,
  invalidCharacters,
  missingAtSign,
  notInLowerCase,
  arabicNotAllowed,
  emojiNotAllowed,
}

final class EmailValidator extends FormzInput<String, EmailValidationError> {
  const EmailValidator.pure() : super.pure('');
  const EmailValidator.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    return ValidationPipeline<EmailValidationError>(value)
        .required(EmailValidationError.empty)
        .contains('@', EmailValidationError.missingAtSign)
        .isLowerCase(EmailValidationError.notInLowerCase)
        .matches(_emailRegExp, EmailValidationError.invalid)
        .notMatches(_arabicRegExp, EmailValidationError.arabicNotAllowed)
        .notMatches(_emojiRegExp, EmailValidationError.emojiNotAllowed)
        .evaluate();
  }
}

extension EmailValidationErrorX on EmailValidationError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => switch (this) {
    EmailValidationError.empty => 'error_email_cant_be_empty',
    EmailValidationError.invalid => 'error_email_not_invalid_format',
    EmailValidationError.invalidCharacters =>
      'error_email_contains_invalid_characters',
    EmailValidationError.missingAtSign => 'error_email_must_contain_at_symbol',
    EmailValidationError.notInLowerCase => 'error_email_must_be_in_lowercase',
    EmailValidationError.arabicNotAllowed => 'error_arabic_not_allowed',
    EmailValidationError.emojiNotAllowed => 'error_email_emoji_not_allowed',
  };

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => switch (this) {
    EmailValidationError.empty => 'Email can\'t be empty.',
    EmailValidationError.invalid => 'Invalid email format.',
    EmailValidationError.invalidCharacters =>
      'Email contains invalid characters.',
    EmailValidationError.missingAtSign => 'Email must contain @.',
    EmailValidationError.notInLowerCase => 'Email must be lowercase.',
    EmailValidationError.arabicNotAllowed =>
      'Arabic characters are not allowed.',
    EmailValidationError.emojiNotAllowed => 'Emoji is not allowed.',
  };
}
