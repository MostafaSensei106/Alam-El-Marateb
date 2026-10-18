import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
;

import '../../constants/app_config.dart';
import '../../extensions/extensions.dart';
import '../buttons/text_button/text_button_component.dart';

/// Unified error-state presentation used by every API-backed screen.
///
/// Compact and centered: a small tinted medallion, a [title], the human
/// [message], and a retry button wired to the screen's explicit reload.
class RetryableErrorStateWidget extends StatelessWidget {
  const RetryableErrorStateWidget({
    required this.message,
    required this.onRetry,
    this.title,
    this.icon = LucideIcons.messageCircleWarning,
    this.retryButtonText,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;
  final String? title;
  final IconData? icon;
  final String? retryButtonText;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConfig.padding,
          vertical: AppConfig.padding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.errorContainer.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color.error),
              ),
              SizedBox(height: 12),
            ],
            Text(
              title ?? context.localeKeys.error,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButtonComponent.icon(
              onPressed: onRetry,
              icon: LucideIcons.refreshCcw,
              label: retryButtonText ?? context.localeKeysetry,
            ),
          ],
        ),
      ),
    );
  }
}
