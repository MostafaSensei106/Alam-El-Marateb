import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/services/app_info/interface/base_app_info_service.dart';
import '../../../../core/utils/models/app_info_model.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';

/// Read-only summary of the installed admin build.
///
/// The data comes from the shared app-info service. The panel degrades to an
/// explanatory card when the service is not registered, which keeps widget
/// tests and preview shells usable without booting dependency injection.
final class AppInfoPanel extends StatelessWidget {
  const AppInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final info = _resolveInfo();
    if (info == null) return const _UnavailableCard();

    final l10n = context.localeKeys;
    final fallback = l10n.appInfoUnknown;
    final buildMode = info.isDebug
        ? l10n.appInfoBuildModeDebug
        : l10n.appInfoBuildModeRelease;

    final cards = <Widget>[
      _InfoCard(
        title: l10n.appInfoSectionApplication,
        subtitle: l10n.appInfoSectionApplicationHint,
        icon: LucideIcons.appWindow,
        children: [
          AdminDetailRow(
            label: l10n.appInfoAppName,
            value: _orFallback(info.appName, fallback),
            icon: LucideIcons.appWindow,
          ),
          AdminDetailRow(
            label: l10n.appInfoPackageName,
            value: _orFallback(info.packageName, fallback),
            icon: LucideIcons.package,
          ),
          AdminDetailRow(
            label: l10n.appInfoVersion,
            value: _orFallback(info.version, fallback),
            icon: LucideIcons.tag,
          ),
          AdminDetailRow(
            label: l10n.appInfoBuildNumber,
            value: _orFallback(info.buildNumber, fallback),
            icon: LucideIcons.hash,
          ),
          AdminDetailRow(
            label: l10n.appInfoBuildMode,
            value: buildMode,
            icon: info.isDebug ? LucideIcons.bug : LucideIcons.badgeCheck,
          ),
        ],
      ),
      _InfoCard(
        title: l10n.appInfoSectionRuntime,
        subtitle: l10n.appInfoSectionRuntimeHint,
        icon: LucideIcons.cpu,
        children: [
          AdminDetailRow(
            label: l10n.appInfoOperatingSystem,
            value: _orFallback(info.operatingSystemName, fallback),
            icon: LucideIcons.monitorSmartphone,
          ),
          AdminDetailRow(
            label: l10n.appInfoOperatingSystemVersion,
            value: _orFallback(info.operatingSystemVersion, fallback),
            icon: LucideIcons.cpu,
          ),
          AdminDetailRow(
            label: l10n.appInfoFlutterVersion,
            value: _orFallback(info.flutterVersion, fallback),
            icon: LucideIcons.code,
          ),
          AdminDetailRow(
            label: l10n.appInfoFlutterChannel,
            value: _orFallback(info.flutterChanal, fallback),
            icon: LucideIcons.gitBranch,
          ),
          AdminDetailRow(
            label: l10n.appInfoDartVersion,
            value: _orFallback(info.dartVersion, fallback),
            icon: LucideIcons.code,
          ),
          AdminDetailRow(
            label: l10n.appInfoDartChannel,
            value: _orFallback(info.dartChanal, fallback),
            icon: LucideIcons.gitBranch,
          ),
        ],
      ),
      _InfoCard(
        title: l10n.appInfoSectionDistribution,
        subtitle: l10n.appInfoSectionDistributionHint,
        icon: LucideIcons.store,
        children: [
          AdminDetailRow(
            label: l10n.appInfoInstallDate,
            value: _formatTimestamp(context, info.installDate, fallback),
            icon: LucideIcons.calendarDays,
          ),
          AdminDetailRow(
            label: l10n.appInfoUpdateDate,
            value: _formatTimestamp(context, info.updateTime, fallback),
            icon: LucideIcons.refreshCw,
          ),
          AdminDetailRow(
            label: l10n.appInfoInstaller,
            value: _orFallback(info.installerStore, fallback),
            icon: LucideIcons.store,
          ),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryCard(
          info: info,
          onCopy: () => unawaited(_copyDetails(context, info)),
        ),
        const SizedBox(height: AppSpacing.large),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = AppSpacing.large;
            final columns = constraints.maxWidth >= 1040
                ? 3
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            final cardWidth =
                (constraints.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final card in cards)
                  SizedBox(width: cardWidth, child: card),
              ],
            );
          },
        ),
      ],
    );
  }
}

AppInfoModel? _resolveInfo() {
  if (!getIt.isRegistered<BaseAppInfoService>()) return null;

  try {
    return getIt<BaseAppInfoService>().getAppDetails();
  } on Object {
    return null;
  }
}

String _orFallback(String? value, String fallback) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? fallback : trimmed;
}

String _formatTimestamp(
  BuildContext context,
  DateTime? timestamp,
  String fallback,
) {
  if (timestamp == null) return fallback;

  final localizations = MaterialLocalizations.of(context);
  final local = timestamp.toLocal();
  final date = localizations.formatMediumDate(local);
  final time = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: true,
  );

  return '$date · $time';
}

String _detailsText(BuildContext context, AppInfoModel info) {
  final l10n = context.localeKeys;
  final fallback = l10n.appInfoUnknown;
  final buildMode = info.isDebug
      ? l10n.appInfoBuildModeDebug
      : l10n.appInfoBuildModeRelease;

  return [
    '${l10n.appInfoAppName}: ${_orFallback(info.appName, fallback)}',
    '${l10n.appInfoPackageName}: ${_orFallback(info.packageName, fallback)}',
    '${l10n.appInfoVersion}: ${_orFallback(info.version, fallback)}',
    '${l10n.appInfoBuildNumber}: ${_orFallback(info.buildNumber, fallback)}',
    '${l10n.appInfoBuildMode}: $buildMode',
    '${l10n.appInfoOperatingSystem}: '
        '${_orFallback(info.operatingSystemName, fallback)}',
    '${l10n.appInfoOperatingSystemVersion}: '
        '${_orFallback(info.operatingSystemVersion, fallback)}',
    '${l10n.appInfoFlutterVersion}: '
        '${_orFallback(info.flutterVersion, fallback)}',
    '${l10n.appInfoFlutterChannel}: '
        '${_orFallback(info.flutterChanal, fallback)}',
    '${l10n.appInfoDartVersion}: ${_orFallback(info.dartVersion, fallback)}',
    '${l10n.appInfoDartChannel}: ${_orFallback(info.dartChanal, fallback)}',
    '${l10n.appInfoInstallDate}: '
        '${_formatTimestamp(context, info.installDate, fallback)}',
    '${l10n.appInfoUpdateDate}: '
        '${_formatTimestamp(context, info.updateTime, fallback)}',
    '${l10n.appInfoInstaller}: '
        '${_orFallback(info.installerStore, fallback)}',
  ].join('\n');
}

Future<void> _copyDetails(BuildContext context, AppInfoModel info) async {
  final l10n = context.localeKeys;
  final text = _detailsText(context, info);
  final messenger = ScaffoldMessenger.of(context);

  await Clipboard.setData(ClipboardData(text: text));
  if (!messenger.mounted) return;

  messenger.showSnackBar(SnackBar(content: Text(l10n.appInfoCopied)));
}

final class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.info, required this.onCopy});

  final AppInfoModel info;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final identity = Row(
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppRadii.large),
          ),
          child: Icon(
            LucideIcons.appWindow,
            size: AppIconSizes.large,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.large),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.appName,
                style: textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                info.packageName,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    final copyButton = OutlinedButton.icon(
      onPressed: onCopy,
      icon: const Icon(
        LucideIcons.clipboardCopy,
        size: AppIconSizes.small,
      ),
      label: Text(l10n.appInfoCopy),
    );

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 560) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    identity,
                    const SizedBox(height: AppSpacing.medium),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: copyButton,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: identity),
                  const SizedBox(width: AppSpacing.medium),
                  copyButton,
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.large),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              AdminStatusPill(
                label: '${l10n.appInfoVersion} ${info.version}',
                tone: AdminPillTone.primary,
                icon: LucideIcons.tag,
              ),
              AdminStatusPill(
                label: '${l10n.appInfoBuildNumber} ${info.buildNumber}',
                icon: LucideIcons.hash,
              ),
              AdminStatusPill(
                label: info.isDebug
                    ? l10n.appInfoBuildModeDebug
                    : l10n.appInfoBuildModeRelease,
                tone: info.isDebug
                    ? AdminPillTone.warning
                    : AdminPillTone.success,
                icon: info.isDebug ? LucideIcons.bug : LucideIcons.badgeCheck,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(title: title, subtitle: subtitle, icon: icon),
          const SizedBox(height: AppSpacing.medium),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppSpacing.small),
          ...children,
        ],
      ),
    );
  }
}

final class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.circleAlert,
            size: AppIconSizes.medium,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appInfoUnavailableTitle,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                Text(
                  l10n.appInfoUnavailableBody,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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
