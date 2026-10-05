import 'dart:async';

import 'package:flutter/material.dart';
import '../../../ds_config.dart';
import 'package:flutter/services.dart';

import 'package:core_utils/core_utils.dart';

final class TextFormFieldComponent extends StatelessWidget {
  const TextFormFieldComponent({
    required this.label,
    this.prefixIcon,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.useInBorderRadius = false,
    this.readOnly = false,
    this.isEnable = true,
    this.errorText,
    this.onTap,
    this.controller,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.onPrefixIconPressed,
    this.onSuffixIconPressed,
    this.fillColor,
    this.focusNode,
    this.maxLines = 1,
    this.textDirection,
    super.key,
  });

  final String label;
  final IconData? prefixIcon;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool useInBorderRadius;
  final bool readOnly;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final bool isEnable;
  final String? errorText;
  final String? initialValue;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final int maxLines;
  final VoidCallback? onPrefixIconPressed;
  final VoidCallback? onSuffixIconPressed;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) => TextFormField(
    focusNode: focusNode,
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    textAlign: textAlign,
    inputFormatters: inputFormatters,
    readOnly: readOnly,
    onChanged: onChanged,
    enabled: isEnable,
    initialValue: initialValue,
    maxLines: maxLines,
    onTapOutside: (event) => FocusScope.of(context).unfocus(),
    textDirection: textDirection,

    onTap: () {
      unawaited(HapticFeedback.vibrate());
      onTap?.call();
    },
    decoration: InputDecoration(
      labelText: label,
      errorText: errorText,
      filled: true,
      fillColor: fillColor ?? context.colorScheme.surfaceContainer,

      prefixIcon: prefixIcon != null
          ? IconButton(
              onPressed: onPrefixIconPressed,
              icon: Icon(prefixIcon, color: context.colorScheme.primary),
            )
          : null,
      suffixIcon: onSuffixIconPressed != null
          ? IconButton(
              onPressed: onSuffixIconPressed,
              icon: suffixIcon is IconData
                  ? Icon(suffixIcon as IconData)
                  : suffixIcon ?? const SizedBox.shrink(),
            )
          : suffixIcon is IconData
          ? Icon(suffixIcon as IconData)
          : suffixIcon,
      hintText: hintText,

      border: OutlineInputBorder(
        borderRadius: useInBorderRadius
            ? BorderRadius.circular(DsConfig.inBorderRadius)
            : BorderRadius.circular(DsConfig.outBorderRadius),
        borderSide: BorderSide(color: context.colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: useInBorderRadius
            ? BorderRadius.circular(DsConfig.inBorderRadius)
            : BorderRadius.circular(DsConfig.outBorderRadius),
        borderSide: BorderSide(color: context.colorScheme.outlineVariant),
      ),
    ),
  );
}
