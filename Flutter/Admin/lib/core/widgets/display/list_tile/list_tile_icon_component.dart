import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/app_config.dart';
import 'list_tile_component.dart';

final class ListTileIconComponent extends StatelessWidget {
  const ListTileIconComponent({
    required this.title,
    required this.leading,
    this.useinBorderRadius = false,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.single;

  const ListTileIconComponent.top({
    required this.title,
    required this.leading,
    this.useinBorderRadius = false,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.top;

  const ListTileIconComponent.middle({
    required this.title,
    required this.leading,
    this.useinBorderRadius = false,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.middle;

  const ListTileIconComponent.bottom({
    required this.title,
    required this.leading,
    this.useinBorderRadius = false,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.bottom;

  final String title;
  final IconData leading;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool? selected;
  final bool useinBorderRadius;
  final ListTileGroupType groupType;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Container(
      padding: const EdgeInsets.all(AppConfig.paddingHalf),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(leading, size: AppConfig.iconSize, color: Colors.white),
    );

    switch (groupType) {
      case ListTileGroupType.top:
        return ListTileComponent.top(
          title: title,
          leading: iconWidget,
          subtitle: subtitle,
          trailing: trailing,
          selected: selected,
          useinBorderRadius: useinBorderRadius,
          onTap: () {
            unawaited(HapticFeedback.vibrate());
            onTap?.call();
          },
        );
      case ListTileGroupType.middle:
        return ListTileComponent.middle(
          title: title,
          leading: iconWidget,
          subtitle: subtitle,
          trailing: trailing,
          selected: selected,
          useinBorderRadius: useinBorderRadius,
          onTap: () {
            unawaited(HapticFeedback.vibrate());
            onTap?.call();
          },
        );
      case ListTileGroupType.bottom:
        return ListTileComponent.bottom(
          title: title,
          leading: iconWidget,
          subtitle: subtitle,
          trailing: trailing,
          selected: selected,
          useinBorderRadius: useinBorderRadius,
          onTap: () {
            unawaited(HapticFeedback.vibrate());
            onTap?.call();
          },
        );
      case ListTileGroupType.single:
        return ListTileComponent(
          title: title,
          leading: iconWidget,
          subtitle: subtitle,
          trailing: trailing,
          selected: selected,
          useinBorderRadius: useinBorderRadius,
          onTap: () {
            unawaited(HapticFeedback.vibrate());
            onTap?.call();
          },
        );
    }
  }
}
