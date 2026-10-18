import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_config.dart';
import '../../buttons/icon_button/icon_button_component.dart';

final class SidePageSliverAppBarComponent extends StatelessWidget {
  const SidePageSliverAppBarComponent({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.pinned = false,
    this.floating = false,
    this.snap = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.bottom,
    this.centerTitle = true,
    this.titleSpacing,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final double? titleSpacing;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;

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
  Widget build(BuildContext context) => SliverAppBar(
    title: title,
    leading: _buildSidePageAppBarIcon(
      context,
      cheakLocation(context)
          ? Icons.keyboard_double_arrow_right_rounded
          : Icons.keyboard_double_arrow_left_rounded,
    ),
    actions: actions,
    pinned: pinned,
    floating: floating,
    snap: snap,
    expandedHeight: expandedHeight,
    flexibleSpace: flexibleSpace,
    bottom: bottom,
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    foregroundColor: foregroundColor,
    centerTitle: centerTitle,
    elevation: 0,
    actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
    titleSpacing: titleSpacing,

    scrolledUnderElevation: 0,
  );

  /// Builds the icon button for the app bar.
  Widget _buildSidePageAppBarIcon(BuildContext context, IconData icon) =>
      Padding(
        padding: const EdgeInsets.all(AppConfig.paddingHalf),
        child: IconButtonComponent.outlined(
          onPressed: () => leave(context),
          icon: icon,
        ),
      );
}
