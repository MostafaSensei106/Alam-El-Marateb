// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../../../constants/validation_regex.dart';
import '../../../../extensions/extensions.dart';
import '../../base/validation_pipeline.dart';

/// Max characters allowed for a city name.
const int kCityMaxLength = 50;

enum CityValidatorError { empty, tooLong, invalidSpecialChars }

final class CityValidator extends FormzInput<String, CityValidatorError> {
  const CityValidator.pure() : super.pure('');
  const CityValidator.dirty([super.value = '']) : super.dirty();

  @override
  CityValidatorError? validator(String value) {
    return ValidationPipeline<CityValidatorError>(value)
        .required(CityValidatorError.empty)
        .maxLength(kCityMaxLength, CityValidatorError.tooLong)
        .notMatches(
          ValidationRegex.invalidSpecialCharsRegExp,
          CityValidatorError.invalidSpecialChars,
        )
        .evaluate();
  }
}

extension CityValidatorErrorX on CityValidatorError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      CityValidatorError.empty => l.error_city_cant_be_empty,
      CityValidatorError.tooLong => l.error_city_too_long,
      CityValidatorError.invalidSpecialChars =>
        l.error_city_invalid_special_characters,
    };
  }
}
