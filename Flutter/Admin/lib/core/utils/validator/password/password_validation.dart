// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../../constants/validation_regex.dart';
import '../../../extensions/extensions.dart';
import '../base/validation_pipeline.dart';

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
        .matches(
          ValidationRegex.strongPasswordRegExp,
          PasswordValidationError.invalid,
        )
        .evaluate();
  }
}

extension PasswordValidationErrorExtension on PasswordValidationError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      PasswordValidationError.empty => l.error_password_cant_be_empty,
      PasswordValidationError.invalid =>
        l.error_password_must_contain_uppercase_lowercase_number_and_special_character,
      PasswordValidationError.minLength =>
        l.error_password_must_be_at_least_8_characters_long,
    };
  }
}
