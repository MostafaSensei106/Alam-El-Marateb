import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/inputs/password_form_field/password_form_field_component.dart';

/// Password input of the login form.
final class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return PasswordFieldComponent(label: context.localeKeys.password);
  }
}
