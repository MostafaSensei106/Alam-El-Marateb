import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kaisel/kaisel.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/constants/assets_images.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/buttons/filled_button/filled_button_component.dart';
import '../../../core/widgets/buttons/text_button/text_button_component.dart';
import '../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../core/widgets/inputs/checkbox/checkbox_component.dart';
import '../../../core/widgets/inputs/password_form_field/password_form_field_component.dart';
import '../../../core/widgets/inputs/text_form_field/text_form_field_component.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 800;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isWide)
              const Row(
                children: [
                  Expanded(child: _LoginFormPanel()),
                  Expanded(child: _LoginImagePanel()),
                ],
              )
            else
              const Column(
                children: [
                  Expanded(flex: 3, child: _LoginImagePanel()),
                  Expanded(flex: 2, child: _LoginFormPanel()),
                ],
              ),
            Positioned(
              top: MediaQuery.paddingOf(context).top,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Row(
                  children: [
                    TextButtonComponent.icon(
                      label: context.localeKeys.changeLanguage,
                      icon: LucideIcons.languages,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginImagePanel extends StatelessWidget {
  const _LoginImagePanel();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AssetsImages.authBackground, fit: BoxFit.cover),
              PositionedDirectional(
                start: 32,
                end: 32,
                bottom: 40,
                child:
                    Text(
                          context.localeKeys.welcomeBack,
                          style: context.textTheme.displayMedium!.copyWith(
                            color: Colors.white,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 400.ms)
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        ),
              ),
            ],
          ),
        )
        .animate()
        .slideX(begin: -1, end: 0, duration: 800.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 350.ms);
  }
}

class _LoginFormPanel extends StatelessWidget {
  const _LoginFormPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fields = <Widget>[
      Text(
        context.localeKeys.alm_el_marateb,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineSmall,
      ),
      Text(context.localeKeys.login, style: theme.textTheme.headlineMedium),
      Text(
        context.localeKeys.enterYourCredentialsToAccessYourAccount,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      TextFormFieldComponent(
        label: context.localeKeys.emailAddress,
        prefixIcon: LucideIcons.mail,
        keyboardType: TextInputType.emailAddress,
      ),
      PasswordFieldComponent(label: context.localeKeys.password),
      Row(
        mainAxisAlignment: .spaceBetween,
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
      ),
      FilledButtonComponent.icon(
        icon: LucideIcons.logIn,
        label: context.localeKeys.login,
        height: 53,
        onPressed: () =>
            context.router<AppRoute>().replaceTop(const MainRouteEntry()),
      ),
    ];

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:
                      [
                            fields[0],
                            const SizedBox(height: AppSpacing.xxLarge),
                            fields[1],
                            const SizedBox(height: AppSpacing.small),
                            fields[2],
                            const SizedBox(height: AppSpacing.xxLarge),
                            fields[3],
                            const SizedBox(height: AppSpacing.xLarge),
                            fields[4],
                            const SizedBox(height: AppSpacing.small),
                            fields[5],
                            const SizedBox(height: AppSpacing.xLarge),
                            fields[6],
                          ]
                          .animate(delay: 550.ms, interval: 90.ms)
                          .fadeIn(duration: 350.ms)
                          .slideY(
                            begin: 0.06,
                            end: 0,
                            duration: 450.ms,
                            curve: Curves.easeOutCubic,
                          ),
                ),
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
