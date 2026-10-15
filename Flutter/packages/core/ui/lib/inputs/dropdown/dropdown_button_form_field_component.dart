import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:alam_el_marateb_constants/constants.dart';

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
        ? BorderRadius.circular(ApplicationRadius.innerBorderRadius)
        : BorderRadius.circular(ApplicationRadius.outerBorderRadius),

    decoration: InputDecoration(
      labelText: label,
      errorText: errorText,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainer,
      prefixIcon: Icon(prefixIcon, color: Theme.of(context).colorScheme.primary),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: useInBorderRadius
            ? BorderRadius.circular(ApplicationRadius.innerBorderRadius)
            : BorderRadius.circular(ApplicationRadius.outerBorderRadius),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: useInBorderRadius
            ? BorderRadius.circular(ApplicationRadius.innerBorderRadius)
            : BorderRadius.circular(ApplicationRadius.outerBorderRadius),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    ),
  );
}
