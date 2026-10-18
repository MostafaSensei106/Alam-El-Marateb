import 'package:formz/formz.dart';

import '../email/email_validators.dart';
import '../name/name_validator.dart';
import '../password/password_validation.dart';
import '../phone/phone_number_validation.dart';

enum GovernorateValidatorError { empty }

final class GovernorateValidator
    extends FormzInput<int?, GovernorateValidatorError> {
  const GovernorateValidator.pure() : super.pure(null);
  const GovernorateValidator.dirty([super.value]) : super.dirty();

  @override
  GovernorateValidatorError? validator(int? value) {
    if (value == null || value <= 0) {
      return GovernorateValidatorError.empty;
    }
    return null;
  }
}

class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.governorate,
  });

  final NameValidator name;
  final EmailValidator email;
  final PasswordValidator password;
  final PhoneNumberValidator phone;
  final GovernorateValidator governorate;

  bool get isValid =>
      name.isValid &&
      email.isValid &&
      password.isValid &&
      phone.isValid &&
      governorate.isValid;
}
