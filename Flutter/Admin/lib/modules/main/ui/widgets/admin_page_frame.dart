import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../core/widgets/display/card/card_component.dart';

/// Vertically scrollable page body with a centered, width-limited column.
///
/// Every module page renders its content through this frame so the admin
/// workspace keeps a consistent rhythm on wide desktop windows and compact
/// mobile ones.
final class AdminPageFrame extends StatelessWidget {
  const AdminPageFrame({
    required this.children,
    super.key,
    this.maxWidth = 1240,
    this.padding,
  });

  final List<Widget> children;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 720;

    return ListView(
      padding:
          padding ??
          EdgeInsets.all(isCompact ? AppSpacing.large : AppSpacing.large),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

/// Page heading with an icon badge, title, description and optional actions.
final class AdminPageHeader extends StatelessWidget {
  const AdminPageHeader({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
    this.badge,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? badge;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final heading = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadii.large),
          ),
          child: Icon(
            icon,
            size: AppIconSizes.medium,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.large),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final titleText = Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(height: 1.2),
                  );
                  if (badge == null) return titleText;

                  final pill = AdminStatusPill(
                    label: badge!,
                    tone: AdminPillTone.primary,
                  );

                  // The pill keeps its intrinsic width, so on a narrow header
                  // it would squeeze the title to zero and overflow the row.
                  if (constraints.maxWidth < 480) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText,
                        const SizedBox(height: AppSpacing.xSmall),
                        pill,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Flexible(child: titleText),
                      const SizedBox(width: AppSpacing.small),
                      pill,
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xSmall),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (trailing == null) return heading;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading,
              const SizedBox(height: AppSpacing.large),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: trailing,
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: heading),
            const SizedBox(width: AppSpacing.large),
            trailing!,
          ],
        );
      },
    );
  }
}

/// Rounded panel used to group related content inside a page.
final class AdminSurfaceCard extends StatelessWidget {
  const AdminSurfaceCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.large),
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardComponent(
      padding: padding,
      color: color ?? colorScheme.surfaceContainerLow,
      child: child,
    );
  }
}

/// Card heading with an optional trailing widget.
final class AdminSectionHeading extends StatelessWidget {
  const AdminSectionHeading({
    required this.title,
    super.key,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final heading = Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: AppIconSizes.medium, color: colorScheme.primary),
          const SizedBox(width: AppSpacing.medium),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    if (trailing == null) return heading;

    return LayoutBuilder(
      builder: (context, constraints) {
        // On compact cards a trailing pill cannot share the row with the
        // title: the pill would keep its intrinsic width, squeeze the title
        // to zero and push the row past the card edge. Stack it instead.
        if (constraints.maxWidth < 560) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading,
              const SizedBox(height: AppSpacing.small),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: trailing,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: heading),
            const SizedBox(width: AppSpacing.medium),
            trailing!,
          ],
        );
      },
    );
  }
}

/// The semantic intent behind an [AdminStatusPill].
enum AdminPillTone { primary, success, warning, muted }

/// Small rounded label used for statuses, counts and tags.
final class AdminStatusPill extends StatelessWidget {
  const AdminStatusPill({
    required this.label,
    super.key,
    this.tone = AdminPillTone.muted,
    this.icon,
  });

  final String label;
  final AdminPillTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (tone) {
      AdminPillTone.primary => colorScheme.primary,
      AdminPillTone.success => const Color(0xFF1B8A5A),
      AdminPillTone.warning => const Color(0xFFB26A00),
      AdminPillTone.muted => colorScheme.onSurfaceVariant,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final text = Text(
            label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: color),
          );

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: color),
                const SizedBox(width: AppSpacing.xSmall),
              ],
              if (constraints.hasBoundedWidth) Flexible(child: text) else text,
            ],
          );
        },
      ),
    );
  }
}

/// Banner explaining that a page is still a layout preview.
final class AdminPrototypeBanner extends StatelessWidget {
  const AdminPrototypeBanner({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.construction,
            size: AppIconSizes.medium,
            color: colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label ?? l10n.interactivePrototype,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.prototypeNotice,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular initials avatar that does not depend on a network image.
final class AdminAvatar extends StatelessWidget {
  const AdminAvatar({required this.name, super.key, this.size = 44});

  final String name;
  final double size;

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2);
    final buffer = StringBuffer();
    for (final part in parts) {
      final runes = part.runes;
      if (runes.isNotEmpty) {
        buffer.write(String.fromCharCode(runes.first).toUpperCase());
      }
    }
    final value = buffer.toString();
    return value.isEmpty ? '?' : value;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.tertiary],
        ),
      ),
      child: Text(
        _initials,
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: colorScheme.onPrimary, fontSize: size * 0.34),
      ),
    );
  }
}

/// Label/value row used by detail cards.
final class AdminDetailRow extends StatelessWidget {
  const AdminDetailRow({
    required this.label,
    required this.value,
    super.key,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppIconSizes.small,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.small),
          ],
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
