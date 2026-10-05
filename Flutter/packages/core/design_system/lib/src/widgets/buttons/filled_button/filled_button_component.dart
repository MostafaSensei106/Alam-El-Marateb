import 'dart:async';

import 'package:flutter/material.dart';
import '../../../ds_config.dart';
import 'package:flutter/services.dart';


final class FilledButtonComponent extends StatelessWidget {
  const FilledButtonComponent({
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

  const FilledButtonComponent.icon({
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
      ? FilledButton(
          onPressed: isEnabled
              ? () {
                  unawaited(HapticFeedback.vibrate());
                  onPressed();
                }
              : null,
          style: _getButtonStyle(context),
          child: Text(label),
        )
      : FilledButton.icon(
          onPressed: isEnabled
              ? () {
                  unawaited(HapticFeedback.vibrate());
                  onPressed();
                }
              : null,
          style: _getButtonStyle(context),
          icon: Icon(icon, size: DsConfig.iconSize),
          label: Text(label),
        );

  ButtonStyle _getButtonStyle(BuildContext context) => FilledButton.styleFrom(
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
    foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
    minimumSize: Size(
      width ?? double.infinity,
      height ?? DsConfig.buttonHeight,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: useInBorderRadius
          ? BorderRadius.circular(DsConfig.inBorderRadius)
          : BorderRadius.circular(DsConfig.outBorderRadius),
    ),
  );
}
