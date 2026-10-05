import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../ds_config.dart';

final class ElevatedButtonComponent extends StatelessWidget {
  const ElevatedButtonComponent({
    required this.label,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  }) : icon = null;

  const ElevatedButtonComponent.icon({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  });
  final String label;
  final VoidCallback onPressed;
  final bool useInBorderRadius;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) => icon == null
      ? ElevatedButton(
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: _getButtonStyle(context),
          child: Text(label),
        )
      : ElevatedButton.icon(
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: _getButtonStyle(context),
          icon: Icon(icon, size: DsConfig.iconSize),
          label: Text(label),
        );

  ButtonStyle _getButtonStyle(BuildContext context) => ElevatedButton.styleFrom(
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
