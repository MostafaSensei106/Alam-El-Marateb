import 'dart:async';

import 'package:flutter/material.dart';
import '../../../ds_config.dart';
import 'package:flutter/services.dart';


enum IconButtonVariant { standard, filled, tonal, outlined }

final class IconButtonComponent extends StatelessWidget {
  const IconButtonComponent({
    required this.icon,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.toolTip,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
  }) : variant = IconButtonVariant.standard;

  const IconButtonComponent.filled({
    required this.icon,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.toolTip,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
  }) : variant = IconButtonVariant.filled;

  const IconButtonComponent.tonal({
    required this.icon,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.toolTip,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
  }) : variant = IconButtonVariant.tonal;

  const IconButtonComponent.outlined({
    required this.icon,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.toolTip,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
  }) : variant = IconButtonVariant.outlined;
  final IconData icon;
  final VoidCallback onPressed;
  final IconButtonVariant variant;
  final bool useInBorderRadius;

  final String? toolTip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? iconSize;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case IconButtonVariant.standard:
        return IconButton(
          icon: Icon(icon, size: iconSize ?? DsConfig.iconSize),
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          color: foregroundColor ?? Theme.of(context).colorScheme.primary,
        );
      case IconButtonVariant.filled:
        return IconButton.filled(
          icon: Icon(icon, size: iconSize ?? DsConfig.iconSize),
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: useInBorderRadius
                  ? BorderRadius.circular(DsConfig.inBorderRadius)
                  : BorderRadius.circular(DsConfig.outBorderRadius),
            ),
            backgroundColor:
                backgroundColor ??
                Theme.of(context).colorScheme.primaryContainer,
            foregroundColor:
                foregroundColor ??
                Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          padding: EdgeInsets.all(padding ?? DsConfig.paddingHalf),
        );
      case IconButtonVariant.tonal:
        return IconButton.filledTonal(
          icon: Icon(icon, size: iconSize ?? DsConfig.iconSize),
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: useInBorderRadius
                  ? BorderRadius.circular(DsConfig.inBorderRadius)
                  : BorderRadius.circular(DsConfig.outBorderRadius),
            ),
            backgroundColor:
                backgroundColor ??
                Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor:
                foregroundColor ??
                Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        );
      case IconButtonVariant.outlined:
        return IconButton.outlined(
          icon: Icon(icon, size: iconSize ?? DsConfig.iconSize),
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: useInBorderRadius
                  ? BorderRadius.circular(DsConfig.inBorderRadius)
                  : BorderRadius.circular(DsConfig.outBorderRadius),
            ),
            side: BorderSide(
              color:
                  backgroundColor ??
                  Theme.of(context).colorScheme.outlineVariant,
            ),
            foregroundColor:
                foregroundColor ?? Theme.of(context).colorScheme.primary,
          ),
        );
    }
  }
}
