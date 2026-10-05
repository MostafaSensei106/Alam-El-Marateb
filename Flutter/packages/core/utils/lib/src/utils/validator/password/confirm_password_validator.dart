import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../../extensions/extensions.dart';
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

extension ConfirmPasswordValidationErrorExtension
    on ConfirmPasswordValidationError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      ConfirmPasswordValidationError.empty => l.error_password_cant_be_empty,
      ConfirmPasswordValidationError.mismatch =>
        'Passwords do not match', // Add to l10n later if needed
    };
  }
}
