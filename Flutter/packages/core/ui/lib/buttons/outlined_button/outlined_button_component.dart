import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:alam_el_marateb_ui/src/foundation/ui_metrics.dart';

final class OutlinedButtonComponent extends StatelessWidget {
  const OutlinedButtonComponent({
    required this.label,
    required this.onPressed,
    super.key,
    this.isEnabled = true,
    this.useInBorderRadius = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  }) : icon = null;

  const OutlinedButtonComponent.icon({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.isEnabled = true,
    this.useInBorderRadius = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  });
  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool useInBorderRadius;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) => icon == null
      ? OutlinedButton(
          onPressed: isEnabled
              ? () {
                  unawaited(HapticFeedback.vibrate());
                  onPressed();
                }
              : null,
          style: _getButtonStyle(context),
          child: Text(label),
        )
      : OutlinedButton.icon(
          onPressed: isEnabled
              ? () {
                  unawaited(HapticFeedback.vibrate());
                  onPressed();
                }
              : null,
          style: _getButtonStyle(context),
          icon: Icon(icon, size: ApplicationIconsSize.iconSize),
          label: Text(label),
        );

  ButtonStyle _getButtonStyle(BuildContext context) => OutlinedButton.styleFrom(
    side: BorderSide(
      color: backgroundColor ?? Theme.of(context).colorScheme.outline,
    ),
    foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.primary,
    minimumSize: Size(
      width ?? double.infinity,
      height ?? UiMetrics.buttonHeight,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: useInBorderRadius
          ? BorderRadius.circular(ApplicationRadius.innerBorderRadius)
          : BorderRadius.circular(ApplicationRadius.outerBorderRadius),
    ),
  );
}
