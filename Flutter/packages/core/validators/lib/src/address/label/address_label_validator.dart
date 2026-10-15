import 'package:formz/formz.dart';

import '../../base/validation_pipeline.dart';

final _emojiRegExp = RegExp(
  r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
  unicode: true,
);
final _invalidSpecialCharsRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

/// Max characters allowed for an address label (e.g. "Home", "Office").
const int kAddressLabelMaxLength = 30;

enum AddressLabelValidatorError {
  empty,
  tooLong,
  invalidSpecialChars,
  emojiNotAllowed,
}

final class AddressLabelValidator
    extends FormzInput<String, AddressLabelValidatorError> {
  const AddressLabelValidator.pure() : super.pure('');
  const AddressLabelValidator.dirty([super.value = '']) : super.dirty();

  @override
  AddressLabelValidatorError? validator(String value) {
    return ValidationPipeline<AddressLabelValidatorError>(value)
        .required(AddressLabelValidatorError.empty)
        .maxLength(kAddressLabelMaxLength, AddressLabelValidatorError.tooLong)
        .notMatches(_emojiRegExp, AddressLabelValidatorError.emojiNotAllowed)
        .notMatches(
          _invalidSpecialCharsRegExp,
          AddressLabelValidatorError.invalidSpecialChars,
        )
        .evaluate();
  }
}

extension AddressLabelValidatorErrorX on AddressLabelValidatorError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => switch (this) {
    AddressLabelValidatorError.empty => 'error_address_label_cant_be_empty',
    AddressLabelValidatorError.tooLong => 'error_address_label_too_long',
    AddressLabelValidatorError.invalidSpecialChars =>
      'error_address_invalid_special_characters',
    AddressLabelValidatorError.emojiNotAllowed =>
      'error_address_emoji_not_allowed',
  };

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => switch (this) {
    AddressLabelValidatorError.empty => 'Address label can\'t be empty.',
    AddressLabelValidatorError.tooLong =>
      'Address label is too long (max $kAddressLabelMaxLength characters).',
    AddressLabelValidatorError.invalidSpecialChars =>
      'Address label contains invalid special characters.',
    AddressLabelValidatorError.emojiNotAllowed =>
      'Emoji is not allowed in address label.',
  };
}
