import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/assets_images.dart';
import '../../../../core/extensions/extensions.dart';

/// Decorative image half of the login screen.
///
/// Slides in from the leading edge and reveals the welcome message slightly
/// after the panel itself settles.
final class LoginImagePanel extends StatelessWidget {
  const LoginImagePanel({super.key});

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
