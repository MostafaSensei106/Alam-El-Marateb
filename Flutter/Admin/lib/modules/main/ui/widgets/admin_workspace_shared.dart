import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../core/widgets/display/empty_state_widget.dart';
import '../../../../core/widgets/inputs/search_bar/search_bar_component.dart';
import 'admin_page_frame.dart';

/// Shared chrome for every full-width admin workspace.
///
/// The sample-data workspace and the endpoint-backed one must look identical:
/// same header rhythm, same detached search field and same paginator. Keeping
/// the pieces here means a redesign only has to happen once.

/// Header card that introduces the active section.
final class AdminWorkspaceHeader extends StatelessWidget {
  const AdminWorkspaceHeader({
    required this.title,
    required this.icon,
    required this.pills,
    super.key,
  });

  final String title;
  final IconData icon;

  /// Count, availability and action controls rendered next to the title.
  final List<Widget> pills;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: AdminSectionHeading(
        title: title,
        icon: icon,
        trailing: Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: pills,
        ),
      ),
    );
  }
}

/// Standalone search field intentionally kept outside the header card so it
/// reads as its own control instead of part of the section chrome.
final class AdminWorkspaceSearchBar extends StatelessWidget {
  const AdminWorkspaceSearchBar({
    required this.search,
    required this.hasQuery,
    required this.onClear,
    super.key,
    this.hintText,
  });

  final TextEditingController search;
  final bool hasQuery;
  final VoidCallback onClear;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SearchBarComponent(
          controller: search,
          hintText: hintText ?? l10n.wireframeSearch,
          trailing: hasQuery
              ? [
                  IconButton(
                    onPressed: onClear,
                    tooltip: l10n.sectionClearSearch,
                    icon: const Icon(LucideIcons.x, size: AppIconSizes.small),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

/// Footer paginator shared by every workspace, with compact and RTL handling.
final class AdminPaginationBar extends StatelessWidget {
  const AdminPaginationBar({
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.from,
    required this.to,
    required this.total,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    super.key,
    this.pageSizeOptions = const <int>[6, 12, 24],
  });

  final int page;
  final int pageCount;
  final int pageSize;
  final int from;
  final int to;
  final int total;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;
  final List<int> pageSizeOptions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final veryCompact = constraints.maxWidth < 420;
          final pageLabel = compact
              ? '${page + 1}/$pageCount'
              : l10n.paginationPageOf(page + 1, pageCount);
          final iconButtonStyle = IconButton.styleFrom(
            minimumSize: const Size(32, 32),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );

          final controls = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!veryCompact) ...[
                Text(
                  l10n.paginationPerPage,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.xSmall),
              ],
              DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: pageSize,
                  isDense: true,
                  iconSize: AppIconSizes.small,
                  style: textTheme.labelMedium,
                  items: [
                    for (final size in pageSizeOptions)
                      DropdownMenuItem(value: size, child: Text('$size')),
                  ],
                  onChanged: (value) {
                    if (value != null) onPageSizeChanged(value);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Text(
                pageLabel,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.xSmall),
              IconButton(
                onPressed: page > 0 ? () => onPageChanged(page - 1) : null,
                tooltip: l10n.paginationPrevious,
                style: iconButtonStyle,
                icon: Icon(
                  isRtl ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
                  size: AppIconSizes.small,
                ),
              ),
              IconButton(
                onPressed: page < pageCount - 1
                    ? () => onPageChanged(page + 1)
                    : null,
                tooltip: l10n.paginationNext,
                style: iconButtonStyle,
                icon: Icon(
                  isRtl ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                  size: AppIconSizes.small,
                ),
              ),
            ],
          );

          final summary = Text(
            l10n.paginationShowing(from, to, total),
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                summary,
                const SizedBox(height: AppSpacing.xSmall),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: controls,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: summary),
              const SizedBox(width: AppSpacing.small),
              controls,
            ],
          );
        },
      ),
    );
  }
}

/// Empty-state panel shared by the sample and endpoint workspaces.
final class AdminWorkspaceEmptyState extends StatelessWidget {
  const AdminWorkspaceEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.large,
        vertical: AppSpacing.xxLarge,
      ),
      child: EmptyStateWidget(
        icon: icon,
        title: title,
        subtitle: subtitle,
        action: action,
      ),
    );
  }
}
