import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/assets_images.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import 'login_form_panel.dart';
import 'login_language_button.dart';

/// Login composition for compact windows.
///
/// A full-bleed photograph sits behind a collapsing sliver app bar; the
/// credential form lives in a rounded sheet that floats over the photo and the
/// language switch drops to a single floating icon at the bottom.
final class LoginCompactLayout extends StatelessWidget {
  const LoginCompactLayout({super.key});

  static const double _headerHeight = 340;
  static const double _sheetRadius = 32;
  static const double _bottomBarSpace = 88;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;
    final keyboardVisible = mediaQuery.viewInsets.bottom > 0;

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                expandedHeight: _headerHeight,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: Text(
                  context.localeKeys.alm_el_marateb,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: _CompactBackground(),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.large,
                  AppSpacing.large,
                  AppSpacing.large,
                  _bottomBarSpace + bottomInset,
                ),
                sliver: SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -AppSpacing.xxLarge),
                    child: const _LoginSheet(radius: _sheetRadius),
                  ),
                ),
              ),
            ],
          ),
          if (!keyboardVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset + AppSpacing.large,
              child: const Center(child: LoginLanguageIconButton()),
            ),
        ],
      ),
    );
  }
}

/// Photographic header with a scrim that keeps the greeting readable.
final class _CompactBackground extends StatelessWidget {
  const _CompactBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AssetsImages.authBackground, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.45, 1],
              colors: [
                Colors.black.withValues(alpha: 0.45),
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          start: AppSpacing.xLarge,
          end: AppSpacing.xLarge,
          bottom: 40,
          child:
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localeKeys.welcomeBack,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.small),
                      Text(
                        context
                            .localeKeys
                            .enterYourCredentialsToAccessYourAccount,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(delay: 250.ms, duration: 450.ms)
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  ),
        ),
      ],
    );
  }
}

/// Rounded surface that carries the credential form over the photo.
final class _LoginSheet extends StatelessWidget {
  const _LoginSheet({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.large),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: const LoginFormBody(showHeader: false),
            ),
          ],
        )
        .animate(delay: 150.ms)
        .slideY(
          begin: 0.12,
          end: 0,
          duration: 450.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: 300.ms);
  }
}
