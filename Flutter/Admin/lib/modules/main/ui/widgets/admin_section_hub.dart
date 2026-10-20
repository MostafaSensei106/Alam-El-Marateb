import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../navigation/admin_module.dart';
import '../../navigation/admin_modules.dart';
import 'admin_page_frame.dart';
import 'admin_wireframe.dart';

/// Standard page for a module that is still navigated at the section level.
///
/// The page renders the localized module header and the master-detail preview
/// for its planned screens.
final class AdminModuleHubPage extends StatelessWidget {
  const AdminModuleHubPage({required this.moduleId, super.key});

  final AdminModuleId moduleId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final module = AdminModules.byId(l10n, moduleId);

    return AdminPageFrame(
      children: [
        AdminPageHeader(
          icon: module.icon,
          title: module.title,
          description: module.description,
          badge: l10n.adminWorkspace,
        ),
        const SizedBox(height: AppSpacing.large),
        const AdminPrototypeBanner(),
        const SizedBox(height: AppSpacing.large),
        AdminSectionHub(module: module),
      ],
    );
  }
}

/// Master-detail navigator for the screens planned inside one module.
///
/// Wide windows get a vertical list beside the preview; compact windows get a
/// horizontally scrolling chip row above it.
final class AdminSectionHub extends HookWidget {
  const AdminSectionHub({required this.module, super.key});

  final AdminModule module;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final selectedIndex = useState(0);
    final sections = module.subSections;
    final activeIndex = selectedIndex.value.clamp(0, sections.length - 1);
    final activeSection = sections[activeIndex];

    final preview = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: AdminWireframePreview(
        key: ValueKey(activeSection.title),
        section: activeSection,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final listCard = AdminSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                  vertical: AppSpacing.small,
                ),
                child: AdminSectionHeading(
                  title: l10n.hubScreens,
                  subtitle: l10n.hubSelectScreen,
                  icon: LucideIcons.layoutGrid,
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              if (constraints.maxWidth >= 900)
                for (var index = 0; index < sections.length; index++)
                  _HubListTile(
                    section: sections[index],
                    selected: index == activeIndex,
                    onTap: () => selectedIndex.value = index,
                  )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var index = 0; index < sections.length; index++) ...[
                        if (index > 0) const SizedBox(width: AppSpacing.small),
                        _HubChip(
                          section: sections[index],
                          selected: index == activeIndex,
                          onTap: () => selectedIndex.value = index,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );

        if (constraints.maxWidth >= 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 300, child: listCard),
              const SizedBox(width: AppSpacing.xLarge),
              Expanded(child: preview),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            listCard,
            const SizedBox(height: AppSpacing.large),
            preview,
          ],
        );
      },
    );
  }
}

final class _HubListTile extends StatelessWidget {
  const _HubListTile({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final AdminSubSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final foreground = selected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected ? colorScheme.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.small,
            ),
            child: Row(
              children: [
                Icon(section.icon, size: AppIconSizes.small, color: foreground),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    section.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: selected ? colorScheme.onSecondaryContainer : null,
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: AppIconSizes.small,
                  color: foreground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _HubChip extends StatelessWidget {
  const _HubChip({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final AdminSubSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selected ? colorScheme.secondaryContainer : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        side: BorderSide(
          color: selected
              ? colorScheme.secondary.withValues(alpha: 0.4)
              : colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                section.icon,
                size: AppIconSizes.small,
                color: selected
                    ? colorScheme.onSecondaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xSmall),
              Text(
                section.title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
