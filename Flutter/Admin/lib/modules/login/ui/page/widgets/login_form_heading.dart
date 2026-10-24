import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';

/// Product name shown above the login headings.
final class LoginBrandTitle extends StatelessWidget {
  const LoginBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localeKeys.alm_el_marateb,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

/// Primary "login" heading of the form.
final class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localeKeys.login,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

/// Supporting sentence telling the user why credentials are needed.
final class LoginSubtitle extends StatelessWidget {
  const LoginSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.localeKeys.enterYourCredentialsToAccessYourAccount,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
