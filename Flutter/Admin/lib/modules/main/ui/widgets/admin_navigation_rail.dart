import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../navigation/admin_module.dart';
import '../../navigation/admin_modules.dart';
import 'admin_account_dialog.dart';
import 'admin_page_frame.dart';

/// Adaptive navigation rail used as the admin workspace's primary navigation.
///
/// On wide windows the rail expands and shows full labels next to the icons.
/// On narrower windows it collapses to an icon rail with labels underneath.
/// Users can override the automatic behaviour with the header toggle.
final class AdminNavigationRail extends HookWidget {
  const AdminNavigationRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onSelectModule,
    super.key,
  });

  /// Width of the icon-only rail.
  static const double collapsedWidth = 100;

  /// Width of the rail with labels and the profile block.
  static const double extendedWidth = 256;

  /// Branch index currently displayed by the shell.
  final int selectedIndex;

  /// Called with the branch index the user picked.
  final ValueChanged<int> onDestinationSelected;

  /// Called when the account menu requests another module.
  final ValueChanged<AdminModuleId> onSelectModule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final theme = Theme.of(context);
    final extendedOverride = useState<bool?>(null);
    final isWideWindow = MediaQuery.sizeOf(context).width >= 1200;
    final extended = extendedOverride.value ?? isWideWindow;
    final modules = AdminModules.all(l10n);

    // `NavigationRail` lays out its leading/trailing widgets with the width
    // constraints it receives. Inside a `Row` those constraints are unbounded,
    // so give the rail an explicit width to avoid a RenderFlex unbounded-width
    // assertion from the `Expanded` children in the header/footer.
    return SizedBox(
      width: extended ? extendedWidth : collapsedWidth,
      child: NavigationRail(
        extended: extended,
        labelType: extended
            ? NavigationRailLabelType.none
            : NavigationRailLabelType.all,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        scrollable: true,
        trailingAtBottom: true,
        groupAlignment: -1,
        minWidth: collapsedWidth,
        minExtendedWidth: extendedWidth,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.secondaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        unselectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        leading: _RailHeader(
          extended: extended,
          onToggleExtended: () {
            extendedOverride.value = !extended;
          },
        ),
        trailing: _RailProfileTile(
          extended: extended,
          onTap: () {
            unawaited(
              showAdminAccountDialog(context, onSelectModule: onSelectModule),
            );
          },
        ),
        destinations: [
          for (final module in modules)
            NavigationRailDestination(
              icon: Icon(module.icon),
              label: Text(
                module.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

/// Brand mark, workspace name and the expand/collapse control.
final class _RailHeader extends StatelessWidget {
  const _RailHeader({required this.extended, required this.onToggleExtended});

  final bool extended;
  final VoidCallback onToggleExtended;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brandMark = DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Icon(
          LucideIcons.store,
          size: 22,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
    final toggle = IconButton(
      onPressed: onToggleExtended,
      tooltip: extended
          ? context.localeKeys.collapseNavigation
          : context.localeKeys.expandNavigation,
      icon: Icon(
        extended ? LucideIcons.panelLeftClose : LucideIcons.panelLeftOpen,
      ),
      visualDensity: VisualDensity.compact,
    );

    if (!extended) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            brandMark,
            const SizedBox(height: AppSpacing.xSmall),
            toggle,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.large,
        AppSpacing.medium,
        AppSpacing.small,
        AppSpacing.medium,
      ),
      child: Row(
        children: [
          brandMark,
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Text(
              context.localeKeys.alm_el_marateb,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(),
            ),
          ),
          toggle,
        ],
      ),
    );
  }
}

/// Clickable account block pinned to the bottom of the rail.
final class _RailProfileTile extends StatelessWidget {
  const _RailProfileTile({required this.extended, required this.onTap});

  final bool extended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final avatar = AdminAvatar(name: l10n.adminDisplayName, size: 40);

    if (!extended) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.small,
          0,
          AppSpacing.small,
          AppSpacing.medium,
        ),
        child: Tooltip(
          message: l10n.openAccountMenu,
          child: Semantics(
            button: true,
            label: l10n.openAccountMenu,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadii.large),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xSmall),
                  child: avatar,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.small,
        0,
        AppSpacing.small,
        AppSpacing.medium,
      ),
      child: Tooltip(
        message: l10n.openAccountMenu,
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
                  avatar,
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
      ),
    );
  }
}
