import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';

final class BadgeComponent extends StatelessWidget {
  const BadgeComponent({required this.child, required this.label, super.key});
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) => Badge(
    label: Text(label),
    backgroundColor: Theme.of(context).colorScheme.error,
    alignment: context.isArabic
        ? AlignmentGeometry.topRight
        : AlignmentGeometry.topLeft,
    child: child,
  );
}
