import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../../main/ui/widgets/admin_preferences.dart';
import '../../../main/ui/widgets/admin_section_hub.dart';
import '../widgets/app_info_panel.dart';

/// Workspace-wide preferences: appearance, notifications, defaults and app
/// information.
///
/// Every preference group is a full-width tab so the controls keep their
/// breathing room instead of competing with a navigation list.
final class SettingsPage extends HookWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final orderAlerts = useState(true);
    final lowStockAlerts = useState(true);
    final reviewAlerts = useState(false);
    final dailyDigest = useState(true);
    final autoRefresh = useState(true);
    final branch = useState('main');
    final landingPage = useState(AdminModuleId.dashboard);
    final modules = AdminModules.all(l10n);
    final settingsModule = modules[AdminModuleId.settings.index];

    Widget saveButton() {
      return FilledButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
        },
        icon: const Icon(LucideIcons.check, size: AppIconSizes.small),
        label: Text(l10n.settingsSave),
      );
    }

    Widget preferenceTab(Widget card) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          card,
          const SizedBox(height: AppSpacing.large),
          Align(alignment: AlignmentDirectional.centerEnd, child: saveButton()),
        ],
      );
    }

    final appearance = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.appearance,
            subtitle: l10n.settingsAppearanceHint,
            icon: LucideIcons.sunMoon,
          ),
          const SizedBox(height: AppSpacing.large),
          const AdminThemeLanguageControls(),
        ],
      ),
    );

    final notifications = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.settingsNotifications,
            subtitle: l10n.settingsNotificationsHint,
            icon: LucideIcons.bell,
          ),
          const SizedBox(height: AppSpacing.large),
          _SwitchRow(
            icon: LucideIcons.shoppingBag,
            label: l10n.settingsNotificationOrders,
            description: l10n.settingsNotificationOrdersHint,
            value: orderAlerts.value,
            onChanged: (value) => orderAlerts.value = value,
          ),
          Divider(
            height: AppSpacing.xLarge,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _SwitchRow(
            icon: LucideIcons.packageMinus,
            label: l10n.settingsNotificationLowStock,
            description: l10n.settingsNotificationLowStockHint,
            value: lowStockAlerts.value,
            onChanged: (value) => lowStockAlerts.value = value,
          ),
          Divider(
            height: AppSpacing.xLarge,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _SwitchRow(
            icon: LucideIcons.star,
            label: l10n.settingsNotificationReviews,
            description: l10n.settingsNotificationReviewsHint,
            value: reviewAlerts.value,
            onChanged: (value) => reviewAlerts.value = value,
          ),
          Divider(
            height: AppSpacing.xLarge,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _SwitchRow(
            icon: LucideIcons.mail,
            label: l10n.settingsNotificationDigest,
            description: l10n.settingsNotificationDigestHint,
            value: dailyDigest.value,
            onChanged: (value) => dailyDigest.value = value,
          ),
        ],
      ),
    );

    final general = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.settingsGeneral,
            subtitle: l10n.settingsGeneralHint,
            icon: LucideIcons.slidersHorizontal,
          ),
          const SizedBox(height: AppSpacing.large),
          AdminPreferenceRow(
            icon: LucideIcons.store,
            label: l10n.settingsDefaultBranch,
            description: l10n.settingsDefaultBranchHint,
            control: AdminSegmentedControl<String>(
              selected: branch.value,
              onChanged: (value) => branch.value = value,
              segments: [
                AdminSegment(value: 'main', label: l10n.settingsBranchMain),
                AdminSegment(value: 'alex', label: l10n.settingsBranchAlex),
                AdminSegment(value: 'giza', label: l10n.settingsBranchGiza),
              ],
            ),
          ),
          Divider(
            height: AppSpacing.xLarge,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          AdminPreferenceRow(
            icon: LucideIcons.layoutDashboard,
            label: l10n.settingsLandingPage,
            description: l10n.settingsLandingPageHint,
            control: AdminSegmentedControl<AdminModuleId>(
              selected: landingPage.value,
              onChanged: (value) => landingPage.value = value,
              segments: [
                for (final module in modules.take(3))
                  AdminSegment<AdminModuleId>(
                    value: module.id,
                    label: module.label,
                    icon: module.icon,
                  ),
              ],
            ),
          ),
          Divider(
            height: AppSpacing.xLarge,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _SwitchRow(
            icon: LucideIcons.refreshCw,
            label: l10n.settingsAutoRefresh,
            description: l10n.settingsAutoRefreshHint,
            value: autoRefresh.value,
            onChanged: (value) => autoRefresh.value = value,
          ),
        ],
      ),
    );

    return AdminPageFrame(
      children: [
        AdminPageHeader(
          icon: LucideIcons.settings,
          title: l10n.settingsTitle,
          description: l10n.settingsDescription,
          badge: l10n.adminWorkspace,
        ),
        const SizedBox(height: AppSpacing.large),
        AdminSectionHub(
          module: settingsModule,
          sectionBuilder: (context, section, index) => switch (index) {
            0 => preferenceTab(appearance),
            1 => preferenceTab(notifications),
            2 => preferenceTab(general),
            _ => const AppInfoPanel(),
          },
        ),
      ],
    );
  }
}

final class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AdminPreferenceRow(
      icon: icon,
      label: label,
      description: description,
      controlWidth: 70,
      control: Switch.adaptive(value: value, onChanged: onChanged),
    );
  }
}
