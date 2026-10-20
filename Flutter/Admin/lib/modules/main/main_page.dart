import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaisel/kaisel.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/extensions/extensions.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/localization/logic/cubit/localization_cubit.dart';
import '../../core/utils/theme/logic/cubit/theme_cubit.dart';
import '../../l10n/app_localizations.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KaiselBranchedShell.specs(
      branches: [
        KaiselBranchSpec<DashboardRoute>(
          initial: const DashboardRoot(),
          builder: (context, route) => switch (route) {
            DashboardRoot() => _AdminSectionPage(
              title: context.localeKeys.dashboardTitle,
              description: context.localeKeys.dashboardDescription,
              features: [
                context.localeKeys.dashboardFeature1,
                context.localeKeys.dashboardFeature2,
                context.localeKeys.dashboardFeature3,
                context.localeKeys.dashboardFeature4,
                context.localeKeys.dashboardFeature5,
              ],
            ),
          },
        ),
        KaiselBranchSpec<IdentityRoute>(
          initial: const IdentityRoot(),
          builder: (context, route) => switch (route) {
            IdentityRoot() => _AdminSectionPage(
              title: context.localeKeys.identityTitle,
              description: context.localeKeys.identityDescription,
              features: [
                context.localeKeys.identityFeature1,
                context.localeKeys.identityFeature2,
                context.localeKeys.identityFeature3,
              ],
            ),
          },
        ),
        KaiselBranchSpec<CatalogRoute>(
          initial: const CatalogRoot(),
          builder: (context, route) => switch (route) {
            CatalogRoot() => _AdminSectionPage(
              title: context.localeKeys.catalogTitle,
              description: context.localeKeys.catalogDescription,
              features: [
                context.localeKeys.catalogFeature1,
                context.localeKeys.catalogFeature2,
                context.localeKeys.catalogFeature3,
                context.localeKeys.catalogFeature4,
                context.localeKeys.catalogFeature5,
              ],
            ),
          },
        ),
        KaiselBranchSpec<InventoryRoute>(
          initial: const InventoryRoot(),
          builder: (context, route) => switch (route) {
            InventoryRoot() => _AdminSectionPage(
              title: context.localeKeys.inventoryTitle,
              description: context.localeKeys.inventoryDescription,
              features: [
                context.localeKeys.inventoryFeature1,
                context.localeKeys.inventoryFeature2,
                context.localeKeys.inventoryFeature3,
                context.localeKeys.inventoryFeature4,
                context.localeKeys.inventoryFeature5,
              ],
            ),
          },
        ),
        KaiselBranchSpec<SalesRoute>(
          initial: const SalesRoot(),
          builder: (context, route) => switch (route) {
            SalesRoot() => _AdminSectionPage(
              title: context.localeKeys.salesTitle,
              description: context.localeKeys.salesDescription,
              features: [
                context.localeKeys.salesFeature1,
                context.localeKeys.salesFeature2,
                context.localeKeys.salesFeature3,
                context.localeKeys.salesFeature4,
                context.localeKeys.salesFeature5,
                context.localeKeys.salesFeature6,
              ],
            ),
          },
        ),
        KaiselBranchSpec<PurchasingRoute>(
          initial: const PurchasingRoot(),
          builder: (context, route) => switch (route) {
            PurchasingRoot() => _AdminSectionPage(
              title: context.localeKeys.purchasingTitle,
              description: context.localeKeys.purchasingDescription,
              features: [
                context.localeKeys.purchasingFeature1,
                context.localeKeys.purchasingFeature2,
                context.localeKeys.purchasingFeature3,
                context.localeKeys.purchasingFeature4,
              ],
            ),
          },
        ),
        KaiselBranchSpec<CrmRoute>(
          initial: const CrmRoot(),
          builder: (context, route) => switch (route) {
            CrmRoot() => _AdminSectionPage(
              title: context.localeKeys.crmTitle,
              description: context.localeKeys.crmDescription,
              features: [
                context.localeKeys.crmFeature1,
                context.localeKeys.crmFeature2,
                context.localeKeys.crmFeature3,
                context.localeKeys.crmFeature4,
              ],
            ),
          },
        ),
        KaiselBranchSpec<DeliveryRoute>(
          initial: const DeliveryRoot(),
          builder: (context, route) => switch (route) {
            DeliveryRoot() => _AdminSectionPage(
              title: context.localeKeys.deliveryTitle,
              description: context.localeKeys.deliveryDescription,
              features: [
                context.localeKeys.deliveryFeature1,
                context.localeKeys.deliveryFeature2,
                context.localeKeys.deliveryFeature3,
                context.localeKeys.deliveryFeature4,
                context.localeKeys.deliveryFeature5,
              ],
            ),
          },
        ),
        KaiselBranchSpec<HrRoute>(
          initial: const HrRoot(),
          builder: (context, route) => switch (route) {
            HrRoot() => _AdminSectionPage(
              title: context.localeKeys.hrTitle,
              description: context.localeKeys.hrDescription,
              features: [
                context.localeKeys.hrFeature1,
                context.localeKeys.hrFeature2,
                context.localeKeys.hrFeature3,
                context.localeKeys.hrFeature4,
              ],
            ),
          },
        ),
        KaiselBranchSpec<AccountingRoute>(
          initial: const AccountingRoot(),
          builder: (context, route) => switch (route) {
            AccountingRoot() => _AdminSectionPage(
              title: context.localeKeys.accountingTitle,
              description: context.localeKeys.accountingDescription,
              features: [
                context.localeKeys.accountingFeature1,
                context.localeKeys.accountingFeature2,
                context.localeKeys.accountingFeature3,
                context.localeKeys.accountingFeature4,
                context.localeKeys.accountingFeature5,
              ],
            ),
          },
        ),
        KaiselBranchSpec<MarketingRoute>(
          initial: const MarketingRoot(),
          builder: (context, route) => switch (route) {
            MarketingRoot() => _AdminSectionPage(
              title: context.localeKeys.marketingTitle,
              description: context.localeKeys.marketingDescription,
              features: [
                context.localeKeys.marketingFeature1,
                context.localeKeys.marketingFeature2,
              ],
            ),
          },
        ),
        KaiselBranchSpec<AdminProfileRoute>(
          initial: const AdminProfileRoot(),
          builder: (context, route) => switch (route) {
            AdminProfileRoot() => _AdminSectionPage(
              title: context.localeKeys.profileTitle,
              description: context.localeKeys.profileDescription,
              features: [
                context.localeKeys.profileFeature1,
                context.localeKeys.profileFeature2,
                context.localeKeys.profileFeature3,
                context.localeKeys.profileFeature4,
              ],
            ),
          },
        ),
        KaiselBranchSpec<AdminSettingsRoute>(
          initial: const AdminSettingsRoot(),
          builder: (context, route) => switch (route) {
            AdminSettingsRoot() => _AdminSectionPage(
              title: context.localeKeys.settingsTitle,
              description: context.localeKeys.settingsDescription,
              features: [
                context.localeKeys.settingsFeature1,
                context.localeKeys.settingsFeature2,
                context.localeKeys.settingsFeature3,
              ],
            ),
          },
        ),
      ],
      chromeBuilder: (context, active, branchContent, switchBranch) {
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                _AdminNavigationRail(
                  selectedIndex: active,
                  onDestinationSelected: (index) {
                    unawaited(HapticFeedback.lightImpact());
                    switchBranch(index);
                  },
                ),
                VerticalDivider(
                  width: 1,
                  color: context.colorScheme.outlineVariant,
                ),
                Expanded(child: branchContent),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Adaptive navigation rail used as the admin shell's primary navigation.
///
/// On wide windows the rail expands and shows full labels next to the icons.
/// On narrower windows it collapses to an icon rail with labels underneath.
/// Users can still override the automatic behaviour with the leading toggle.
class _AdminNavigationRail extends StatefulWidget {
  const _AdminNavigationRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<_AdminNavigationRail> createState() => _AdminNavigationRailState();
}

const double _railWidth = 100;
const double _extendedRailWidth = 256;

class _AdminNavigationRailState extends State<_AdminNavigationRail> {
  bool? _extendedOverride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final extended =
        _extendedOverride ?? MediaQuery.sizeOf(context).width >= 1200;

    debugPrint(
      'RAIL size=${MediaQuery.sizeOf(context)} '
      'dpr=${MediaQuery.devicePixelRatioOf(context)} extended=$extended',
    );

    final width = extended ? _extendedRailWidth : _railWidth;

    // `NavigationRail` lays out its leading/trailing widgets with the width
    // constraints it receives. Inside a `Row` those constraints are unbounded,
    // so give the rail an explicit width to avoid a RenderFlex unbounded-width
    // assertion from the `Expanded` children in the header/footer.
    return SizedBox(
      width: width,
      child: NavigationRail(
        extended: extended,
        labelType: extended
            ? NavigationRailLabelType.none
            : NavigationRailLabelType.all,
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationSelected,
        scrollable: true,
        trailingAtBottom: true,
        groupAlignment: -1,
        minWidth: _railWidth,
        minExtendedWidth: _extendedRailWidth,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.secondaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        unselectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        leading: _RailHeader(
          extended: extended,
          onToggleExtended: () {
            setState(() => _extendedOverride = !extended);
          },
        ),
        trailing: _RailFooter(extended: extended),
        destinations: [
          for (final destination in _destinations(context.localeKeys))
            NavigationRailDestination(
              icon: Icon(destination.icon),
              label: Text(
                destination.label,
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

class _RailHeader extends StatelessWidget {
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [brandMark, const SizedBox(height: 4), toggle],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 8, 12),
      child: Row(
        children: [
          brandMark,
          const SizedBox(width: 12),
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

class _RailFooter extends StatelessWidget {
  const _RailFooter({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.isArabic;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RailAction(
            extended: extended,
            icon: isDark ? LucideIcons.sun : LucideIcons.moon,
            label: context.localeKeys.toggleTheme,
            onTap: () {
              unawaited(
                context.read<ThemeCubit>().changeTheme(
                  isDark ? ThemeMode.light : ThemeMode.dark,
                ),
              );
            },
          ),
          _RailAction(
            extended: extended,
            icon: LucideIcons.languages,
            label: isArabic
                ? context.localeKeys.english
                : context.localeKeys.arabic,
            tooltip: context.localeKeys.changeLanguage,
            onTap: () {
              unawaited(
                context.read<LocalizationCubit>().changeLanguage(
                  isArabic ? 'en' : 'ar',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RailAction extends StatelessWidget {
  const _RailAction({
    required this.extended,
    required this.icon,
    required this.label,
    required this.onTap,
    this.tooltip,
  });

  final bool extended;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    if (!extended) {
      return IconButton(
        onPressed: onTap,
        tooltip: tooltip ?? label,
        icon: Icon(icon),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailDestination {
  const _RailDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

List<_RailDestination> _destinations(AppLocalizations l10n) => [
  _RailDestination(label: l10n.navDashboard, icon: LucideIcons.layoutDashboard),
  _RailDestination(label: l10n.navIdentity, icon: LucideIcons.shieldCheck),
  _RailDestination(label: l10n.navCatalog, icon: LucideIcons.package),
  _RailDestination(label: l10n.navInventory, icon: LucideIcons.warehouse),
  _RailDestination(label: l10n.navSales, icon: LucideIcons.calculator),
  _RailDestination(label: l10n.navPurchasing, icon: LucideIcons.shoppingBag),
  _RailDestination(label: l10n.navCrm, icon: LucideIcons.headset),
  _RailDestination(label: l10n.navDelivery, icon: LucideIcons.truck),
  _RailDestination(label: l10n.navHr, icon: LucideIcons.users),
  _RailDestination(label: l10n.navAccounting, icon: LucideIcons.landmark),
  _RailDestination(label: l10n.navMarketing, icon: LucideIcons.megaphone),
  _RailDestination(label: l10n.navProfile, icon: LucideIcons.circleUser),
  _RailDestination(label: l10n.navSettings, icon: LucideIcons.settings),
];

class _AdminSectionPage extends StatelessWidget {
  const _AdminSectionPage({
    required this.title,
    required this.description,
    required this.features,
  });

  final String title;
  final String description;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.construction,
                          size: 18,
                          color: colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.localeKeys.screenComingSoon,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 720 ? 2 : 1;
                    final cardWidth =
                        (constraints.maxWidth - (columns - 1) * 12) / columns;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final feature in features)
                          SizedBox(
                            width: cardWidth,
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: colorScheme.surfaceContainerLow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  LucideIcons.arrowRight,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                                title: Text(feature),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
