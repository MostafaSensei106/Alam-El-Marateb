import 'package:flutter/material.dart';

class TabBarComponent extends StatelessWidget {
  const TabBarComponent({required this.tabs, super.key, this.controller});
  final List<Tab> tabs;
  final TabController? controller;

  @override
  Widget build(BuildContext context) => TabBar(
    controller: controller,
    tabs: tabs,
    labelColor: Theme.of(context).colorScheme.primary,
    unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
    indicatorColor: Theme.of(context).colorScheme.primary,
  );
}
