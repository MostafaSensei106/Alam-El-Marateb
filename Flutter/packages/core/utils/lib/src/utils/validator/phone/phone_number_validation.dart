// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

import '../../../constants/validation_regex.dart';
import '../../../extensions/extensions.dart';
import '../base/validation_pipeline.dart';

enum PhoneNumberValidation { empty, invalid, minLength }

final class PhoneNumberValidator
    extends FormzInput<String, PhoneNumberValidation> {
  const PhoneNumberValidator.pure() : super.pure('');
  const PhoneNumberValidator.dirty([super.value = '']) : super.dirty();

  @override
  PhoneNumberValidation? validator(String value) {
    return ValidationPipeline<PhoneNumberValidation>(value)
        .required(PhoneNumberValidation.empty)
        .matches(ValidationRegex.phoneRegExp, PhoneNumberValidation.invalid)
        .minLength(11, PhoneNumberValidation.minLength)
        .evaluate();
  }
}

extension PhoneNumberValidationExtension on PhoneNumberValidation {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      PhoneNumberValidation.empty => l.error_phone_number_cant_be_empty,
      PhoneNumberValidation.invalid => l.error_phone_number_invalid,
      PhoneNumberValidation.minLength => l.error_phone_number_min_length,
    };
  }
}
