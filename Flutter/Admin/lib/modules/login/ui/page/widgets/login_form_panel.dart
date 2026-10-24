import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import 'login_email_field.dart';
import 'login_form_heading.dart';
import 'login_options_row.dart';
import 'login_password_field.dart';
import 'login_submit_button.dart';

/// Credential form half of the login screen.
///
/// Each row animates in with a small stagger so the form builds top to bottom.
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:
                      [
                            const LoginBrandTitle(),
                            const SizedBox(height: AppSpacing.xxLarge),
                            const LoginTitle(),
                            const SizedBox(height: AppSpacing.small),
                            const LoginSubtitle(),
                            const SizedBox(height: AppSpacing.xxLarge),
                            const LoginEmailField(),
                            const SizedBox(height: AppSpacing.xLarge),
                            const LoginPasswordField(),
                            const SizedBox(height: AppSpacing.small),
                            const LoginOptionsRow(),
                            const SizedBox(height: AppSpacing.xLarge),
                            const LoginSubmitButton(),
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
