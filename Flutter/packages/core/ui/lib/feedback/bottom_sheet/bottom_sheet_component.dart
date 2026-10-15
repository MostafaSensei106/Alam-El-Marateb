import 'package:flutter/material.dart';

import 'package:alam_el_marateb_constants/constants.dart';

final class BottomSheetComponent extends StatelessWidget {
  const BottomSheetComponent({required this.child, super.key, this.title});
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(ApplicationPadding.padding),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(ApplicationRadius.outerBorderRadius),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [if (title != null) ...[], child],
    ),
  );
}
