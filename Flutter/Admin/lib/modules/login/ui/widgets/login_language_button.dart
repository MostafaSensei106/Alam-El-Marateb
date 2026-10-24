import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/buttons/text_button/text_button_component.dart';

/// Language switch shown in the top overlay of the wide login screen.
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

/// Icon-only language switch floating at the bottom of compact screens.
final class LoginLanguageIconButton extends StatelessWidget {
  const LoginLanguageIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton.filledTonal(
      onPressed: () {},
      tooltip: context.localeKeys.changeLanguage,
      iconSize: 22,
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        minimumSize: const Size.square(52),
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      icon: const Icon(LucideIcons.languages),
    );
  }
}
