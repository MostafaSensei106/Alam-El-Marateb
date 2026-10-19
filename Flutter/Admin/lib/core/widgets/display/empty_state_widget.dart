import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/extensions.dart';

/// Unified empty-state presentation used by every list-backed screen.
///
/// Compact and centered: a small tinted icon medallion, a screen-specific
/// [title], an optional explanatory [subtitle], and an optional [action].
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title,
    this.subtitle,
    this.icon = LucideIcons.search,
    this.action,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color.primary),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
