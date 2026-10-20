import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../navigation/admin_module.dart';
import '../../navigation/admin_modules.dart';
import 'admin_page_frame.dart';
import 'admin_section_workspace.dart';

/// Standard page for a module that is still navigated at the section level.
///
/// The page renders the localized module header, a full-width tab strip for the
/// planned screens, and one dense workspace per tab.
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
        AdminSectionHub(module: module),
      ],
    );
  }
}

/// Builds custom content for one hub section.
///
/// The callback receives the active [AdminSubSection] and its index so a
/// screen can keep its own state while still using the standard tab strip.
typedef AdminSectionBuilder =
    Widget Function(BuildContext context, AdminSubSection section, int index);

/// Tab navigator for the screens planned inside one module.
///
/// Every tab renders the full available width instead of sharing space with a
/// navigation list, so tables and boards stay readable on compact windows.
final class AdminSectionHub extends HookWidget {
  const AdminSectionHub({
    required this.module,
    super.key,
    this.sectionBuilder,
  });

  final AdminModule module;

  /// Optional override for tabs that need bespoke content instead of the
  /// generic section workspace.
  final AdminSectionBuilder? sectionBuilder;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final sections = module.subSections;
    final activeIndex = selectedIndex.value.clamp(0, sections.length - 1);
    final activeSection = sections[activeIndex];
    final builder = sectionBuilder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTabStrip(
          sections: sections,
          selectedIndex: activeIndex,
          onSelected: (index) => selectedIndex.value = index,
        ),
        const SizedBox(height: AppSpacing.medium),
        AnimatedSwitcher(
          duration: AppMotion.fast,
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: builder == null
              ? AdminSectionWorkspace(
                  key: ValueKey(activeSection.title),
                  module: module,
                  section: activeSection,
                )
              : KeyedSubtree(
                  key: ValueKey(activeSection.title),
                  child: builder(context, activeSection, activeIndex),
                ),
        ),
      ],
    );
  }
}

final class _SectionTabStrip extends StatelessWidget {
  const _SectionTabStrip({
    required this.sections,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AdminSubSection> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xSmall),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.large),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var index = 0; index < sections.length; index++) ...[
              if (index > 0) const SizedBox(width: AppSpacing.xSmall),
              _SectionTab(
                section: sections[index],
                selected: index == selectedIndex,
                onTap: () => onSelected(index),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _SectionTab extends StatelessWidget {
  const _SectionTab({
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
    final foreground = selected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;
    final radius = BorderRadius.circular(AppRadii.medium);

    return Material(
      color: selected ? colorScheme.secondaryContainer : Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.small,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(section.icon, size: AppIconSizes.small, color: foreground),
              const SizedBox(width: AppSpacing.xSmall),
              Text(
                section.title,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
