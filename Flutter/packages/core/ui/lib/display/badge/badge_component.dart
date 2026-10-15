import 'package:flutter/material.dart';

final class BadgeComponent extends StatelessWidget {
  const BadgeComponent({required this.child, required this.label, super.key});
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Badge(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.error,
      alignment: isRtl ? AlignmentGeometry.topRight : AlignmentGeometry.topLeft,
      child: child,
    );
  }
}
