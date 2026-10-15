import 'package:formz/formz.dart';

import '../../base/validation_pipeline.dart';

final _invalidSpecialCharsRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

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
          _invalidSpecialCharsRegExp,
          CityValidatorError.invalidSpecialChars,
        )
        .evaluate();
  }
}

extension CityValidatorErrorX on CityValidatorError {
  /// Stable l10n key — the app resolves it to the localized string.
  String get messageId => switch (this) {
    CityValidatorError.empty => 'error_city_cant_be_empty',
    CityValidatorError.tooLong => 'error_city_too_long',
    CityValidatorError.invalidSpecialChars =>
      'error_city_invalid_special_characters',
  };

  /// English fallback used when l10n is unavailable (tests, previews).
  String get defaultMessage => switch (this) {
    CityValidatorError.empty => 'City can\'t be empty.',
    CityValidatorError.tooLong =>
      'City is too long (max $kCityMaxLength characters).',
    CityValidatorError.invalidSpecialChars =>
      'City contains invalid special characters.',
  };
}
