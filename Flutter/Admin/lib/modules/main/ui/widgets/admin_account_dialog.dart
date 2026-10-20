import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/session/user_session_service.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../navigation/admin_identity.dart';
import '../../navigation/admin_module.dart';
import 'admin_page_frame.dart';
import 'admin_preferences.dart';

/// Opens the account sheet attached to the profile tile in the rail.
Future<void> showAdminAccountDialog(
  BuildContext context, {
  required ValueChanged<AdminModuleId> onSelectModule,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) =>
        _AdminAccountDialog(onSelectModule: onSelectModule),
  );
}

/// Clears the persisted session and returns to the login screen.
///
/// Both the session service and the router are optional so the helper stays
/// safe inside isolated widget tests.
Future<void> performAdminSignOut(BuildContext context) async {
  if (getIt.isRegistered<BaseUserSessionService>()) {
    await getIt<BaseUserSessionService>().clearUserSession();
  }
  if (!context.mounted) return;
  await context.router<AppRoute>().replaceTop(const LoginRoute());
}

final class _AdminAccountDialog extends StatelessWidget {
  const _AdminAccountDialog({required this.onSelectModule});

  final ValueChanged<AdminModuleId> onSelectModule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      insetPadding: const EdgeInsets.all(AppSpacing.large),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xLarge),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminAvatar(name: l10n.adminDisplayName, size: 56),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.adminDisplayName,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.adminRole,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AdminIdentity.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.cancel,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(LucideIcons.x, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xLarge),
              const AdminThemeLanguageControls(),
              const SizedBox(height: AppSpacing.large),
              Divider(color: colorScheme.outlineVariant),
              const SizedBox(height: AppSpacing.small),
              _AccountActionTile(
                icon: LucideIcons.userRound,
                label: l10n.myProfile,
                onTap: () => _openModule(context, AdminModuleId.profile),
              ),
              _AccountActionTile(
                icon: LucideIcons.settings,
                label: l10n.settingsTitle,
                onTap: () => _openModule(context, AdminModuleId.settings),
              ),
              Divider(color: colorScheme.outlineVariant),
              const SizedBox(height: AppSpacing.small),
              _AccountActionTile(
                icon: LucideIcons.logOut,
                label: l10n.signOut,
                danger: true,
                onTap: () => _confirmSignOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openModule(BuildContext context, AdminModuleId id) {
    Navigator.of(context).pop();
    onSelectModule(id);
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final l10n = context.localeKeys;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      Navigator.of(context).pop();
      await performAdminSignOut(context);
    }
  }
}

final class _AccountActionTile extends StatelessWidget {
  const _AccountActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = danger ? colorScheme.error : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.medium,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: color),
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
