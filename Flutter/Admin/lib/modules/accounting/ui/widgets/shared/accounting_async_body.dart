/// Loading, failure and error surfaces shared by the accounting tabs.
///
/// Every tab owns a cubit, so the first fetch and every write can fail. These
/// widgets keep the scaffold chrome stable while the content below it swaps
/// between a progress bar, a retry panel and an inline error banner.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';

/// Progress surface used as a workspace `body` while a cubit is fetching.
final class AccountingLoadingBody extends StatelessWidget {
  const AccountingLoadingBody({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LinearProgressIndicator(minHeight: 3),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.medium),
            Text(message!, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Failure surface with the cubit message and an optional retry button.
final class AccountingFailureBody extends StatelessWidget {
  const AccountingFailureBody({
    required this.message,
    super.key,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.triangleAlert,
                size: AppIconSizes.small,
                color: colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  l10n.error,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          Text(message, style: theme.textTheme.bodySmall),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.medium),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.refreshCw, size: AppIconSizes.small),
                label: Text(l10n.retry),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Inline banner for a failed write, rendered through the scaffold `notice`.
final class AccountingErrorNotice extends StatelessWidget {
  const AccountingErrorNotice({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadii.medium),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.triangleAlert,
            size: AppIconSizes.small,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
