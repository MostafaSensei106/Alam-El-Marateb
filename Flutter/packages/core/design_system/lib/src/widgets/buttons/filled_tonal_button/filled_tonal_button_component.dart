import 'dart:async';

import 'package:flutter/material.dart';
import '../../../ds_config.dart';
import 'package:flutter/services.dart';


final class FilledTonalButtonComponent extends StatelessWidget {
  const FilledTonalButtonComponent({
    required this.label,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  }) : icon = null;

  const FilledTonalButtonComponent.icon({
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
      ? FilledButton.tonal(
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: _getButtonStyle(context),
          child: Text(label),
        )
      : FilledButton.tonalIcon(
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: _getButtonStyle(context),
          icon: Icon(icon, size: DsConfig.iconSize),
          label: Text(label),
        );

  ButtonStyle _getButtonStyle(BuildContext context) => FilledButton.styleFrom(
    enableFeedback: true,
    backgroundColor:
        backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer,
    foregroundColor:
        foregroundColor ?? Theme.of(context).colorScheme.onSecondaryContainer,
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
