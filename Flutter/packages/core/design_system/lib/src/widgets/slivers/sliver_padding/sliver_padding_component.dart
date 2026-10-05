import 'package:flutter/material.dart';

import '../../../ds_config.dart';

class SliverPaddingComponent extends StatelessWidget {
  const SliverPaddingComponent({required this.sliver, super.key, this.padding});
  final EdgeInsetsGeometry? padding;
  final Widget sliver;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: padding ?? const EdgeInsets.all(DsConfig.padding),
    sliver: sliver,
  );
}
