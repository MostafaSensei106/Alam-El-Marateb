import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/widgets/buttons/filled_button/filled_button_component.dart';

/// Primary submit action, currently routing straight into the workspace.
final class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButtonComponent.icon(
      icon: LucideIcons.logIn,
      label: context.localeKeys.login,
      height: 53,
      onPressed: () =>
          context.router<AppRoute>().replaceTop(const MainRouteEntry()),
    );
  }
}
