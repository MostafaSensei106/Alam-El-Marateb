import 'package:flutter/material.dart';

import 'package:alam_el_marateb_constants/constants.dart';

final class CardComponent extends StatelessWidget {
  const CardComponent({
    required this.child,
    super.key,
    this.padding,
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(ApplicationPadding.padding),
    decoration: BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(ApplicationRadius.outerBorderRadius),
    ),
    child: child,
  );
}
