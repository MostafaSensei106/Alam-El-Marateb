import 'package:formz/formz.dart';

import '../../base/validation_pipeline.dart';

final _emojiRegExp = RegExp(
  r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
  unicode: true,
);
final _invalidSpecialCharsRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

/// Max characters allowed for a full address line.
const int kAddressLineMaxLength = 100;

enum AddressLineValidatorError {
  empty,
  tooLong,
  invalidSpecialChars,
  emojiNotAllowed,
}

final class AddressLineValidator
    extends FormzInput<String, AddressLineValidatorError> {
  const AddressLineValidator.pure() : super.pure('');
  const AddressLineValidator.dirty([super.value = '']) : super.dirty();

  @override
  AddressLineValidatorError? validator(String value) {
    return ValidationPipeline<AddressLineValidatorError>(value)
        .required(AddressLineValidatorError.empty)
        .maxLength(kAddressLineMaxLength, AddressLineValidatorError.tooLong)
        .notMatches(_emojiRegExp, AddressLineValidatorError.emojiNotAllowed)
        .notMatches(
          _invalidSpecialCharsRegExp,
          AddressLineValidatorError.invalidSpecialChars,
        )
        .evaluate();
  }
}

extension AddressLineValidatorErrorX on AddressLineValidatorError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => switch (this) {
    AddressLineValidatorError.empty => 'error_address_line_cant_be_empty',
    AddressLineValidatorError.tooLong => 'error_address_line_too_long',
    AddressLineValidatorError.invalidSpecialChars =>
      'error_address_invalid_special_characters',
    AddressLineValidatorError.emojiNotAllowed =>
      'error_address_emoji_not_allowed',
  };

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => switch (this) {
    AddressLineValidatorError.empty => 'Address can\'t be empty.',
    AddressLineValidatorError.tooLong =>
      'Address is too long (max $kAddressLineMaxLength characters).',
    AddressLineValidatorError.invalidSpecialChars =>
      'Address contains invalid special characters.',
    AddressLineValidatorError.emojiNotAllowed =>
      'Emoji is not allowed in address.',
  };
}
