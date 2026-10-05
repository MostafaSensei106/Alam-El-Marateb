import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../ds_config.dart';

final class TextButtonComponent extends StatelessWidget {
  const TextButtonComponent({
    required this.label,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.isEnable = true,
    this.backgroundColor,
    this.foregroundColor,
  }) : icon = null;

  const TextButtonComponent.icon({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.isEnable = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final bool useInBorderRadius;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: useInBorderRadius
            ? BorderRadius.circular(DsConfig.inBorderRadius)
            : BorderRadius.circular(DsConfig.outBorderRadius),
      ),
    );

    return icon == null
        ? TextButton(
            onPressed: isEnable
                ? () {
                    unawaited(HapticFeedback.vibrate());
                    onPressed();
                  }
                : null,
            style: style,

            child: Text(label),
          )
        : TextButton.icon(
            onPressed: isEnable
                ? () {
                    unawaited(HapticFeedback.vibrate());
                    onPressed();
                  }
                : null,
            style: style,
            icon: Icon(icon, size: DsConfig.iconSize),
            label: Text(label),
          );
  }
}
