// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:alam_el_marateb_constants/constants.dart';

final class CheckboxListTileComponent extends StatelessWidget {
  const CheckboxListTileComponent({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.useInBorderRadius = false,
  });
  final String title;
  final bool value;
  final bool useInBorderRadius;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) => CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    title: Text(title),
    value: value,
    onChanged: (value) {
      unawaited(HapticFeedback.vibrate());
      onChanged(value);
    },
    shape: RoundedRectangleBorder(
      borderRadius: useInBorderRadius
          ? BorderRadiusGeometry.circular(ApplicationRadius.innerBorderRadius)
          : BorderRadius.circular(ApplicationRadius.outerBorderRadius),
    ),
  );
}
