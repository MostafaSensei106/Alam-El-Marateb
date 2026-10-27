import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../main/navigation/admin_module.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../sample/accounting_sample_operations.dart';
import '../shared/accounting_shared.dart';

/// Checks list (`GET|POST checks`, `POST checks/{id}/status`).
final class ChecksView extends HookWidget {
  const ChecksView({
    required this.section,
    required this.onCreate,
    required this.onOpen,
    super.key,
  });

  final AdminSubSection section;
  final VoidCallback onCreate;
  final ValueChanged<CheckRow> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final checks = accountingChecks(l10n);
    final status = useState<CheckStatus?>(null);

    final scoped = status.value == null
        ? checks
        : checks
              .where((check) => check.status == status.value)
              .toList(growable: false);

    final list = useAdminRecordList<CheckRow>(
      items: scoped,
      searchText: (check) =>
          '${check.id} ${check.party ?? ''} '
          '${accountingDirectionLabel(l10n, check.direction)} '
          '${accountingCheckStatusLabel(l10n, check.status)}',
    );

    final incoming = _sum(checks, CheckDirection.incoming);
    final outgoing = _sum(checks, CheckDirection.outgoing);
    final dueSoon = checks.where(_isDueSoon).length;

    return AdminWorkspaceScaffold(
      title: section.title,
      icon: section.icon,
      sectionId: section.id,
      list: list,
      onCreate: onCreate,
      searchHint: l10n.accountingSearchChecks,
      metrics: [
        AdminMetric(
          label: l10n.accountingMetricChecks,
          value: adminGroupDigits(checks.length),
          icon: LucideIcons.scrollText,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingMetricIncoming,
          value: adminFormatAmount(context, incoming),
          icon: LucideIcons.arrowDownLeft,
          tone: AdminPillTone.success,
        ),
        AdminMetric(
          label: l10n.accountingMetricOutgoing,
          value: adminFormatAmount(context, outgoing),
          icon: LucideIcons.arrowUpRight,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.accountingMetricDueSoon,
          value: adminGroupDigits(dueSoon),
          icon: LucideIcons.calendarClock,
          tone: dueSoon == 0 ? AdminPillTone.success : AdminPillTone.primary,
        ),
      ],
      filters: AdminFilterChips<CheckStatus?>(
        options: [
          AdminFilterOption(
            value: null,
            label: l10n.adminFilterAll,
            count: checks.length,
          ),
          for (final value in CheckStatus.values)
            AdminFilterOption(
              value: value,
              label: accountingCheckStatusLabel(l10n, value),
              count: checks.where((check) => check.status == value).length,
            ),
        ],
        selected: status.value,
        onSelected: (value) => status.value = value,
      ),
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.accountingReference, flex: 2),
          AdminTableColumn(
            label: l10n.accountingParty,
            flex: 2,
            hideBelow: 560,
          ),
          AdminTableColumn(label: l10n.accountingDirection, hideBelow: 720),
          AdminTableColumn(label: l10n.accountingDueDate, hideBelow: 880),
          AdminTableColumn(label: l10n.accountingStatus, hideBelow: 1040),
          AdminTableColumn(label: l10n.accountingAmount, alignEnd: true),
        ],
        rows: [
          for (final check in list.visible)
            AdminTableRow([
              Text(check.id, style: textTheme.bodyMedium),
              Text(
                check.party ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                accountingDirectionLabel(l10n, check.direction),
                style: textTheme.bodySmall,
              ),
              Text(
                check.dueDate == null
                    ? '—'
                    : accountingDateLabel(context, check.dueDate!),
                style: textTheme.bodySmall,
              ),
              AdminStatusPill(
                label: accountingCheckStatusLabel(l10n, check.status),
                tone: accountingCheckStatusTone(check.status),
              ),
              Text(
                adminFormatAmount(context, check.amount),
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium,
              ),
            ], onTap: () => onOpen(check)),
        ],
      ),
    );
  }

  double _sum(List<CheckRow> checks, CheckDirection direction) => checks
      .where((check) => check.direction == direction)
      .fold<double>(0, (sum, check) => sum + check.amount);

  /// Held checks falling due within the next two weeks of the reference date.
  bool _isDueSoon(CheckRow check) {
    final due = check.dueDate;
    if (due == null || check.status != CheckStatus.held) return false;
    final days = due.difference(accountingReferenceDate).inDays;
    return days >= 0 && days <= 14;
  }
}
