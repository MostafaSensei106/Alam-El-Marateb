// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../../constants/validation_regex.dart';
import '../../../extensions/extensions.dart';
import '../base/validation_pipeline.dart';

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
        .matches(ValidationRegex.min3CharsRegExp, NameValidatorError.tooShort)
        .matches(ValidationRegex.max20CharsRegExp, NameValidatorError.tooLong)
        .matches(ValidationRegex.nameRegExp, NameValidatorError.invalid)
        .notMatches(
          ValidationRegex.emojiRegExp,
          NameValidatorError.emojiNotAllowed,
        )
        .notMatches(
          ValidationRegex.invalidSpecialCharsRegExp,
          NameValidatorError.invalidSpecialChars,
        )
        .evaluate();
  }
}

extension NameValidatorErrorExtension on NameValidatorError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      NameValidatorError.empty => l.error_name_cant_be_empty,
      NameValidatorError.invalid => l.error_name_invalid,
      NameValidatorError.tooShort =>
        l.error_name_too_short_at_least_3_characters,
      NameValidatorError.tooLong => l.error_name_too_long_maximum_20_characters,
      NameValidatorError.invalidSpecialChars =>
        l.error_name_invalid_special_characters,
      NameValidatorError.emojiNotAllowed => l.error_name_emoji_not_allowed,
    };
  }
}
