import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../constants/app_config.dart';
import '../../extensions/extensions.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.message,
    this.title,
    this.icon = LucideIcons.alertTriangle,
    super.key,
  });

  final String message;
  final String? title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppConfig.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 60, color: color.error),
              const SizedBox(height: 16),
            ],
            Text(
              title ?? context.localeKeys.error,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
