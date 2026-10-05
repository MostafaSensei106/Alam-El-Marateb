import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../constants/app_config.dart';
import '../../../extensions/extensions.dart';

final class DropdownButtonFormFieldComponent<T> extends StatelessWidget {
  const DropdownButtonFormFieldComponent({
    required this.label,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    super.key,
    this.useInBorderRadius = false,
    this.errorText,
    this.onTap,
    this.initialValue,
    this.hintText,
  });

  final String label;
  final IconData prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final T? initialValue;
  final void Function(T?) onChanged;
  final bool useInBorderRadius;
  final String? errorText;
  final void Function()? onTap;
  final String? hintText;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T>(
    icon: const Icon(Iconsax.arrow_bottom_copy),
    initialValue: initialValue,
    items: items,
    onChanged: onChanged,
    elevation: 0,
    onTap: () {
      unawaited(HapticFeedback.vibrate());
      onTap?.call();
    },
    borderRadius: useInBorderRadius
        ? BorderRadius.circular(AppConfig.inBorderRadius)
        : BorderRadius.circular(AppConfig.outBorderRadius),

    decoration: InputDecoration(
      labelText: label,
      errorText: errorText,
      filled: true,
      fillColor: context.colorScheme.surfaceContainer,
      prefixIcon: Icon(prefixIcon, color: context.colorScheme.primary),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: useInBorderRadius
            ? BorderRadius.circular(AppConfig.inBorderRadius)
            : BorderRadius.circular(AppConfig.outBorderRadius),
        borderSide: BorderSide(color: context.colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: useInBorderRadius
            ? BorderRadius.circular(AppConfig.inBorderRadius)
            : BorderRadius.circular(AppConfig.outBorderRadius),
        borderSide: BorderSide(color: context.colorScheme.outlineVariant),
      ),
    ),
  );
}
