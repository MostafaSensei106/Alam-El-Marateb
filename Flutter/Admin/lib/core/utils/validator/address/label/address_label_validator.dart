// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../../../constants/validation_regex.dart';
import '../../../../extensions/extensions.dart';
import '../../base/validation_pipeline.dart';

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
        .notMatches(
          ValidationRegex.emojiRegExp,
          AddressLabelValidatorError.emojiNotAllowed,
        )
        .notMatches(
          ValidationRegex.invalidSpecialCharsRegExp,
          AddressLabelValidatorError.invalidSpecialChars,
        )
        .evaluate();
  }
}

extension AddressLabelValidatorErrorX on AddressLabelValidatorError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      AddressLabelValidatorError.empty => l.error_address_label_cant_be_empty,
      AddressLabelValidatorError.tooLong => l.error_address_label_too_long,
      AddressLabelValidatorError.invalidSpecialChars =>
        l.error_address_invalid_special_characters,
      AddressLabelValidatorError.emojiNotAllowed =>
        l.error_address_emoji_not_allowed,
    };
  }
}
