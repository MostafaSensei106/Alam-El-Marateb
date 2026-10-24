import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/buttons/text_button/text_button_component.dart';
import '../../../../../core/widgets/inputs/checkbox/checkbox_component.dart';

/// "Remember me" checkbox paired with the "forgot password" action.
final class LoginOptionsRow extends StatelessWidget {
  const LoginOptionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CheckboxComponent(
          title: context.localeKeys.rememberMe,
          value: true,
          onChanged: (v) {},
        ),
        TextButtonComponent(
          label: context.localeKeys.forgetPassword,
          onPressed: () {},
        ),
      ],
    );
  }
}
