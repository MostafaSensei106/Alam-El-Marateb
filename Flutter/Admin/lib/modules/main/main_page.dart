import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaisel/kaisel.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/extensions/extensions.dart';
import '../../core/router/app_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return KaiselBranchedShell.specs(
      branches: [
        KaiselBranchSpec<HomeRoute>(
          initial: const HomeRoot(),
          builder: (context, route) => switch (route) {
            HomeRoot() => const _HomePlaceholder(),
          },
        ),
        KaiselBranchSpec<SettingsRoute>(
          initial: const SettingsRoot(),
          builder: (context, route) => switch (route) {
            SettingsRoot() => const _SettingsPlaceholder(),
          },
        ),
      ],
      chromeBuilder: (context, active, branchContent, switchBranch) {
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: active,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: colors.surface,
                  indicatorColor: colors.primaryContainer,
                  onDestinationSelected: (index) {
                    unawaited(HapticFeedback.lightImpact());
                    switchBranch(index);
                  },
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(LucideIcons.home),
                      selectedIcon: const Icon(LucideIcons.homeDir),
                      label: Text(context.localeKeys.home),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: branchContent),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Home')));
  }
}

final class _SettingsPlaceholder extends StatelessWidget {
  const _SettingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Settings')));
  }
}
