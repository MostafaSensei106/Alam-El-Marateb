import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../navigation/admin_modules.dart';
import 'admin_brand_mark.dart';
import 'admin_page_frame.dart';

/// Slide-out navigation used on compact windows.
///
/// Wide windows use `AdminNavigationRail`; phones and small tablets use this
/// drawer so the workspace content keeps the full window width.
final class AdminNavigationDrawer extends StatelessWidget {
  const AdminNavigationDrawer({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onOpenAccount,
    super.key,
  });

  /// Branch index currently displayed by the shell.
  final int selectedIndex;

  /// Called with the branch index the user picked, after the drawer closes.
  final ValueChanged<int> onDestinationSelected;

  /// Called after the drawer closes when the user taps the account block.
  final VoidCallback onOpenAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final modules = AdminModules.all(l10n);

    return Drawer(
      backgroundColor: colorScheme.surfaceContainer,
      child: SafeArea(
        child: Column(
          children: [
            const _DrawerHeader(),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                  vertical: AppSpacing.small,
                ),
                children: [
                  for (final (index, module) in modules.indexed)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        selected: index == selectedIndex,
                        selectedColor: colorScheme.onPrimaryContainer,
                        selectedTileColor: colorScheme.primaryContainer,
                        leading: Icon(module.icon),
                        title: Text(
                          module.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.large),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          onDestinationSelected(index);
                        },
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            _DrawerProfileTile(
              onTap: () {
                Navigator.of(context).pop();
                onOpenAccount();
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Brand mark, workspace name and the close control.
final class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.large,
        AppSpacing.large,
        AppSpacing.small,
        AppSpacing.medium,
      ),
      child: Row(
        children: [
          const AdminBrandMark(),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Text(
              context.localeKeys.alm_el_marateb,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
          ),
          IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(LucideIcons.x, size: 20),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

/// Clickable account block pinned to the bottom of the drawer.
final class _DrawerProfileTile extends StatelessWidget {
  const _DrawerProfileTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.small),
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.large),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.large),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.small),
            child: Row(
              children: [
                AdminAvatar(name: l10n.adminDisplayName, size: 40),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.adminDisplayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.adminRole,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
