import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/buttons/text_button/text_button_component.dart';

/// Language switch shown in the top overlay of the login screen.
final class LoginLanguageButton extends StatelessWidget {
  const LoginLanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButtonComponent.icon(
          label: context.localeKeys.changeLanguage,
          icon: LucideIcons.languages,
          onPressed: () {},
        ),
      ],
    );
  }
}
