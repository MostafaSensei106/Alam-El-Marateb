import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/navigation/admin_identity.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_account_dialog.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../../main/ui/widgets/admin_preferences.dart';

/// The signed-in administrator's profile, security controls and permissions.
final class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final twoFactorEnabled = useState(false);

    final accountCard = _AccountCard(
      onEdit: () => _notify(context, l10n.profileEditNotReady),
    );
    final permissionsCard = _PermissionsCard();
    final securityCard = _SecurityCard(
      twoFactorEnabled: twoFactorEnabled.value,
      onToggleTwoFactor: (value) {
        twoFactorEnabled.value = value;
        _notify(
          context,
          value ? l10n.profileTwoFactorOn : l10n.profileTwoFactorOff,
        );
      },
    );
    final signOutCard = _SignOutCard(
      onSignOut: () => unawaited(_confirmSignOut(context)),
    );

    return AdminPageFrame(
      children: [
        AdminPageHeader(
          icon: LucideIcons.user,
          title: l10n.profileTitle,
          description: l10n.profileDescription,
          badge: l10n.adminRole,
        ),
        const SizedBox(height: AppSpacing.xLarge),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1000) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        accountCard,
                        const SizedBox(height: AppSpacing.large),
                        permissionsCard,
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xLarge),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        securityCard,
                        const SizedBox(height: AppSpacing.large),
                        signOutCard,
                      ],
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                accountCard,
                const SizedBox(height: AppSpacing.large),
                securityCard,
                const SizedBox(height: AppSpacing.large),
                permissionsCard,
                const SizedBox(height: AppSpacing.large),
                signOutCard,
              ],
            );
          },
        ),
      ],
    );
  }
}

final class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.profileAccountDetails,
            icon: LucideIcons.idCard,
          ),
          const SizedBox(height: AppSpacing.large),
          LayoutBuilder(
            builder: (context, constraints) {
              final identity = Row(
                children: [
                  AdminAvatar(name: l10n.adminDisplayName, size: 64),
                  const SizedBox(width: AppSpacing.large),
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
                      ],
                    ),
                  ),
                ],
              );
              final editButton = FilledButton.tonalIcon(
                onPressed: onEdit,
                icon: const Icon(LucideIcons.pencil, size: AppIconSizes.small),
                label: Text(l10n.profileEdit),
              );

              if (constraints.maxWidth < 520) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    identity,
                    const SizedBox(height: AppSpacing.medium),
                    editButton,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: identity),
                  const SizedBox(width: AppSpacing.medium),
                  editButton,
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.large),
          Divider(height: 1, color: colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.medium),
          AdminDetailRow(
            label: l10n.profileFullName,
            value: l10n.adminDisplayName,
            icon: LucideIcons.user,
          ),
          AdminDetailRow(
            label: l10n.profileJobTitle,
            value: l10n.adminRole,
            icon: LucideIcons.badgeCheck,
          ),
          AdminDetailRow(
            label: l10n.profileEmail,
            value: AdminIdentity.email,
            icon: LucideIcons.mail,
          ),
          AdminDetailRow(
            label: l10n.profilePhone,
            value: AdminIdentity.phone,
            icon: LucideIcons.phone,
          ),
          AdminDetailRow(
            label: l10n.profileBranch,
            value: l10n.profileBranchValue,
            icon: LucideIcons.store,
          ),
          AdminDetailRow(
            label: l10n.profileMemberSince,
            value: l10n.profileMemberSinceValue,
            icon: LucideIcons.calendarDays,
          ),
        ],
      ),
    );
  }
}

final class _SecurityCard extends StatelessWidget {
  const _SecurityCard({
    required this.twoFactorEnabled,
    required this.onToggleTwoFactor,
  });

  final bool twoFactorEnabled;
  final ValueChanged<bool> onToggleTwoFactor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.profileSecurity,
            icon: LucideIcons.shieldCheck,
          ),
          const SizedBox(height: AppSpacing.large),
          AdminPreferenceRow(
            icon: LucideIcons.lock,
            label: l10n.profileChangePassword,
            description: l10n.profileChangePasswordDescription,
            controlWidth: 170,
            control: OutlinedButton(
              onPressed: () => _notify(context, l10n.profilePasswordNotReady),
              child: Text(l10n.profileChangePassword),
            ),
          ),
          Divider(
            height: AppSpacing.xLarge,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          AdminPreferenceRow(
            icon: LucideIcons.shieldCheck,
            label: l10n.profileTwoFactor,
            description: l10n.profileTwoFactorDescription,
            controlWidth: 70,
            control: Switch.adaptive(
              value: twoFactorEnabled,
              onChanged: onToggleTwoFactor,
            ),
          ),
          Divider(
            height: AppSpacing.xLarge,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          AdminPreferenceRow(
            icon: LucideIcons.monitorSmartphone,
            label: l10n.profileSessions,
            description: l10n.profileSessionsDescription,
            controlWidth: 170,
            control: OutlinedButton(
              onPressed: () => _notify(context, l10n.profileSessionsCleared),
              child: Text(l10n.profileSessions),
            ),
          ),
        ],
      ),
    );
  }
}

final class _PermissionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeading(
            title: l10n.profilePermissions,
            icon: LucideIcons.keyRound,
            trailing: AdminStatusPill(
              label: l10n.profilePermissionAll,
              tone: AdminPillTone.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            l10n.profilePermissionHint,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.large),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              for (final module in AdminModules.all(l10n))
                AdminStatusPill(label: module.label, icon: module.icon),
            ],
          ),
        ],
      ),
    );
  }
}

final class _SignOutCard extends StatelessWidget {
  const _SignOutCard({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    return AdminSurfaceCard(
      color: colorScheme.errorContainer.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.logOut,
                size: AppIconSizes.medium,
                color: colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Text(
                  l10n.profileSignOutDevice,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          FilledButton.icon(
            onPressed: onSignOut,
            icon: const Icon(LucideIcons.logOut, size: AppIconSizes.small),
            label: Text(l10n.profileSignOutDevice),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _confirmSignOut(BuildContext context) async {
  final l10n = context.localeKeys;
  final shouldSignOut = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.profileSignOutDevice),
      content: Text(l10n.profileSessionsDescription),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.confirm),
        ),
      ],
    ),
  );

  if (!(shouldSignOut ?? false) || !context.mounted) return;
  await performAdminSignOut(context);
}

void _notify(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
