import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/inputs/text_form_field/text_form_field_component.dart';

/// Email input of the login form.
final class LoginEmailField extends StatelessWidget {
  const LoginEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormFieldComponent(
      label: context.localeKeys.emailAddress,
      prefixIcon: LucideIcons.mail,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
