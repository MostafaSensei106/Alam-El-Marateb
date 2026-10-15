import 'package:flutter/material.dart';

class BottomNavBarComponent extends StatelessWidget {
  const BottomNavBarComponent({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    super.key,
  });
  final int currentIndex;
  final List<BottomNavigationBarItem> items;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: currentIndex,
    onDestinationSelected: onTap,
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    backgroundColor: Theme.of(context).colorScheme.surface,
    destinations: items
        .map(
          (item) => NavigationDestination(
            icon: item.icon,
            selectedIcon: item.activeIcon,
            label: item.label ?? '',
          ),
        )
        .toList(),
  );
}
