import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:go_router/go_router.dart';

import '../../../constants/app_config.dart';
import '../../buttons/icon_button/icon_button_component.dart';

/// An app bar designed for side pages, with an optional back button and actions.
class SidePageAppBarComponent extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a [SidePageAppBarComponent].
  const SidePageAppBarComponent({
    required this.title,
    super.key,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// The title to display in the app bar.
  final String title;

  /// A list of widgets to display as actions in the app bar.
  final List<Widget>? actions;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The foreground color of the app bar (e.g., for title and icons).
  final Color? foregroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Navigates back to the previous screen with haptic feedback.
  void leave(BuildContext context) {
    unawaited(HapticFeedback.vibrate());
    context.pop();
  }

  /// Checks if the current locale is Arabic.
  ///
  /// Returns `true` if the language code is 'ar', otherwise `false`.
  bool cheakLocation(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    return isArabic;
  }

  @override
  Widget build(BuildContext context) => AppBar(
    leading: _buildSidePageAppBarIcon(
      context,
      cheakLocation(context)
          ? Icons.keyboard_double_arrow_right_rounded
          : Icons.keyboard_double_arrow_left_rounded,
    ),
    title: Text(title, style: TextStyle(color: foregroundColor)),
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
    actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
    actions: actions,
  );

  /// Builds the icon button for the app bar.
  Widget _buildSidePageAppBarIcon(BuildContext context, IconData icon) =>
      Padding(
        padding: const EdgeInsets.all(AppConfig.paddingHalf),
        child: IconButtonComponent.outlined(
          onPressed: () => leave(context),
          foregroundColor:
              foregroundColor ?? Theme.of(context).colorScheme.onSurface,
          icon: icon,
        ),
      );
}
