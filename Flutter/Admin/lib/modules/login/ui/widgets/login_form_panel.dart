import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kaisel/kaisel.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/buttons/filled_button/filled_button_component.dart';
import '../../../../core/widgets/buttons/text_button/text_button_component.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../core/widgets/inputs/checkbox/checkbox_component.dart';
import '../../../../core/widgets/inputs/password_form_field/password_form_field_component.dart';
import '../../../../core/widgets/inputs/text_form_field/text_form_field_component.dart';

/// Credential form half of the wide login screen.
///
/// The heading, inputs, options and submit action stay together because they
/// share one staggered entrance animation.
final class LoginFormPanel extends StatelessWidget {
  const LoginFormPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          height: double.infinity,
          color: context.colorScheme.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xLarge,
            vertical: AppSpacing.xLarge,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: const LoginFormBody(),
              ),
            ),
          ),
        )
        .animate(delay: 250.ms)
        .slideX(
          begin: 0.12,
          end: 0,
          duration: 700.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: 500.ms);
  }
}

/// Login fields shared by the wide panel and the compact sheet.
///
/// Every row staggers in from top to bottom; [showHeader] is disabled on
/// compact screens because the photographic header already greets the user and
/// the collapsed app bar carries the product name.
final class LoginFormBody extends StatelessWidget {
  const LoginFormBody({super.key, this.showHeader = true});

  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          [
                if (showHeader) ...[
                  const _LoginBrandTitle(),
                  const SizedBox(height: AppSpacing.xxLarge),
                  const _LoginTitle(),
                  const SizedBox(height: AppSpacing.small),
                  const _LoginSubtitle(),
                  const SizedBox(height: AppSpacing.xxLarge),
                ],
                const _LoginEmailField(),
                const SizedBox(height: AppSpacing.xLarge),
                const _LoginPasswordField(),
                const SizedBox(height: AppSpacing.small),
                const _LoginOptionsRow(),
                const SizedBox(height: AppSpacing.xLarge),
                const _LoginSubmitButton(),
              ]
              .animate(delay: 550.ms, interval: 90.ms)
              .fadeIn(duration: 350.ms)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: 450.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}

/// Product name shown above the login headings.
final class _LoginBrandTitle extends StatelessWidget {
  const _LoginBrandTitle();

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
final class _LoginTitle extends StatelessWidget {
  const _LoginTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localeKeys.login,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

/// Supporting sentence telling the user why credentials are needed.
final class _LoginSubtitle extends StatelessWidget {
  const _LoginSubtitle();

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

/// Email input of the login form.
final class _LoginEmailField extends StatelessWidget {
  const _LoginEmailField();

  @override
  Widget build(BuildContext context) {
    return TextFormFieldComponent(
      label: context.localeKeys.emailAddress,
      prefixIcon: LucideIcons.mail,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

/// Password input of the login form.
final class _LoginPasswordField extends StatelessWidget {
  const _LoginPasswordField();

  @override
  Widget build(BuildContext context) {
    return PasswordFieldComponent(label: context.localeKeys.password);
  }
}

/// "Remember me" checkbox paired with the "forgot password" action.
final class _LoginOptionsRow extends StatelessWidget {
  const _LoginOptionsRow();

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

/// Primary submit action, currently routing straight into the workspace.
final class _LoginSubmitButton extends StatelessWidget {
  const _LoginSubmitButton();

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
