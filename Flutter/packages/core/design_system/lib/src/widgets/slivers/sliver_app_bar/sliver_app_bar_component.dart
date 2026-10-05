import 'package:flutter/material.dart';

final class SliverAppBarComponent extends StatelessWidget {
  const SliverAppBarComponent({
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
    this.backgroundColor,
    this.foregroundColor,
    this.leadingWidth,
  });
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double? leadingWidth;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) => SliverAppBar(
    title: title,
    leading: leading,
    leadingWidth: leadingWidth,
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
    scrolledUnderElevation: 0,
    actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
  );
}
