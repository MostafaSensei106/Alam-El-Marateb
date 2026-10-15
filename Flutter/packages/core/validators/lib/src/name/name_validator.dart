import 'package:formz/formz.dart';

import '../base/validation_pipeline.dart';

final _min3CharsRegExp = RegExp(r'^.{3,}$');
final _max20CharsRegExp = RegExp(r'^.{0,20}$');
final _nameRegExp = RegExp(r'^[\p{L}\s]+$', unicode: true);
final _emojiRegExp = RegExp(
  r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
  unicode: true,
);
final _invalidSpecialCharsRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

enum NameValidatorError {
  empty,
  invalid,
  tooShort,
  tooLong,
  invalidSpecialChars,
  emojiNotAllowed,
}

final class NameValidator extends FormzInput<String, NameValidatorError> {
  const NameValidator.pure() : super.pure('');
  const NameValidator.dirty([super.value = '']) : super.dirty();

  @override
  NameValidatorError? validator(String value) {
    return ValidationPipeline<NameValidatorError>(value)
        .required(NameValidatorError.empty)
        .matches(_min3CharsRegExp, NameValidatorError.tooShort)
        .matches(_max20CharsRegExp, NameValidatorError.tooLong)
        .matches(_nameRegExp, NameValidatorError.invalid)
        .notMatches(_emojiRegExp, NameValidatorError.emojiNotAllowed)
        .notMatches(
          _invalidSpecialCharsRegExp,
          NameValidatorError.invalidSpecialChars,
        )
        .evaluate();
  }
}

extension NameValidatorErrorX on NameValidatorError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => switch (this) {
    NameValidatorError.empty => 'error_name_cant_be_empty',
    NameValidatorError.invalid => 'error_name_invalid',
    NameValidatorError.tooShort =>
      'error_name_too_short_at_least_3_characters',
    NameValidatorError.tooLong => 'error_name_too_long_maximum_20_characters',
    NameValidatorError.invalidSpecialChars =>
      'error_name_invalid_special_characters',
    NameValidatorError.emojiNotAllowed => 'error_name_emoji_not_allowed',
  };

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => switch (this) {
    NameValidatorError.empty => 'Name can\'t be empty.',
    NameValidatorError.invalid => 'Invalid name.',
    NameValidatorError.tooShort => 'Name is too short (min 3 characters).',
    NameValidatorError.tooLong => 'Name is too long (max 20 characters).',
    NameValidatorError.invalidSpecialChars =>
      'Name contains invalid special characters.',
    NameValidatorError.emojiNotAllowed => 'Emoji is not allowed in name.',
  };
}
