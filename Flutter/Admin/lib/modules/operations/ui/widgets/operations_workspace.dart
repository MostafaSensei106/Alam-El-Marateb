import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../domain/operations_models.dart';
import '../../domain/operations_seed.dart';

/// Bespoke operations screens.
///
/// The generic section workspace only has room for four short cells, while
/// operations is organised around tasks, a branch-load board and customer
/// holds. Each tab composes the shared detail kit so the tables, filter chips
/// and metric cards stay identical to the other modules while the columns
/// match the real workflow.
final class OperationsWorkspace extends StatelessWidget {
  const OperationsWorkspace({required this.section, super.key});

  /// Sections rendered by this workspace instead of the generic skeleton.
  static const Set<String> sectionIds = {
    'operations.tasks',
    'operations.branches',
    'operations.holds',
  };

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) => switch (section.id) {
    'operations.branches' => _BranchesTab(section: section),
    'operations.holds' => _HoldsTab(section: section),
    _ => _TasksTab(section: section),
  };
}

// ---------------------------------------------------------------------------
// Labels and tones
// ---------------------------------------------------------------------------

String _taskStatusLabel(AppLocalizations l10n, OpsTaskStatus status) =>
    switch (status) {
      OpsTaskStatus.open => l10n.opsStatusOpen,
      OpsTaskStatus.inProgress => l10n.opsStatusInProgress,
      OpsTaskStatus.blocked => l10n.opsStatusBlocked,
      OpsTaskStatus.done => l10n.opsStatusDone,
    };

AdminPillTone _taskStatusTone(OpsTaskStatus status) => switch (status) {
  OpsTaskStatus.open => AdminPillTone.muted,
  OpsTaskStatus.inProgress => AdminPillTone.primary,
  OpsTaskStatus.blocked => AdminPillTone.warning,
  OpsTaskStatus.done => AdminPillTone.success,
};

String _priorityLabel(AppLocalizations l10n, OpsPriority priority) =>
    switch (priority) {
      OpsPriority.low => l10n.opsPriorityLow,
      OpsPriority.normal => l10n.opsPriorityNormal,
      OpsPriority.high => l10n.opsPriorityHigh,
      OpsPriority.urgent => l10n.opsPriorityUrgent,
    };

AdminPillTone _priorityTone(OpsPriority priority) => switch (priority) {
  OpsPriority.low || OpsPriority.normal => AdminPillTone.muted,
  OpsPriority.high => AdminPillTone.primary,
  OpsPriority.urgent => AdminPillTone.warning,
};

String _holdStatusLabel(AppLocalizations l10n, OpsHoldStatus status) =>
    switch (status) {
      OpsHoldStatus.waiting => l10n.opsHoldWaiting,
      OpsHoldStatus.arrived => l10n.opsHoldArrived,
      OpsHoldStatus.ready => l10n.opsHoldReady,
      OpsHoldStatus.cancelled => l10n.opsHoldCancelled,
    };

AdminPillTone _holdStatusTone(OpsHoldStatus status) => switch (status) {
  OpsHoldStatus.waiting => AdminPillTone.warning,
  OpsHoldStatus.arrived => AdminPillTone.primary,
  OpsHoldStatus.ready => AdminPillTone.success,
  OpsHoldStatus.cancelled => AdminPillTone.muted,
};

String _holdTypeLabel(AppLocalizations l10n, OpsHoldType type) =>
    switch (type) {
      OpsHoldType.stock => l10n.opsHoldStockItem,
      OpsHoldType.custom => l10n.opsHoldCustomSize,
    };

/// Relative due label anchored to [opsReferenceDate].
String _dueLabel(BuildContext context, OpsTask task) {
  final l10n = context.localeKeys;

  if (task.isDone) {
    return MaterialLocalizations.of(context).formatMediumDate(task.due);
  }

  final days = opsDateOnly(task.due)
      .difference(opsDateOnly(opsReferenceDate))
      .inDays;

  if (task.isDueToday(opsReferenceDate)) return l10n.opsDueToday;
  if (days == 1) return l10n.opsDueTomorrow;
  if (days < 0) return l10n.opsDaysOverdue(days.abs());

  return l10n.opsDaysLeft(days);
}

AdminPillTone _dueTone(OpsTask task) {
  if (task.isDone) return AdminPillTone.muted;
  if (task.isOverdue(opsReferenceDate)) return AdminPillTone.warning;
  if (task.isDueToday(opsReferenceDate)) return AdminPillTone.primary;

  return AdminPillTone.muted;
}

/// Relative label for when a held item is expected in store.
String _expectedLabel(BuildContext context, OpsHold hold) {
  final l10n = context.localeKeys;

  if (!hold.isWaiting) {
    return MaterialLocalizations.of(context).formatMediumDate(hold.expected);
  }

  final days = opsDateOnly(hold.expected)
      .difference(opsDateOnly(opsReferenceDate))
      .inDays;

  if (days == 0) return l10n.opsExpectedToday;
  if (days < 0) return l10n.opsDaysOverdue(days.abs());

  return l10n.opsDaysLeft(days);
}

AdminPillTone _expectedTone(OpsHold hold) {
  if (!hold.isWaiting) return AdminPillTone.muted;

  final days = opsDateOnly(hold.expected)
      .difference(opsDateOnly(opsReferenceDate))
      .inDays;

  if (days < 0) return AdminPillTone.warning;
  if (days == 0) return AdminPillTone.primary;

  return AdminPillTone.muted;
}

double _ratio(int value, int total) => total == 0 ? 0 : value / total;

void _showSampleAction(BuildContext context) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger.showSnackBar(
    SnackBar(content: Text(context.localeKeys.adminSampleActionMessage)),
  );
}

// ---------------------------------------------------------------------------
// Tasks
// ---------------------------------------------------------------------------

final class _TasksTab extends HookWidget {
  const _TasksTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final tasks = OperationsSeed.tasks(l10n);
    final selectedBranch = useState<String>('');

    final scoped = selectedBranch.value.isEmpty
        ? tasks
        : tasks
              .where((task) => task.branchIds.contains(selectedBranch.value))
              .toList(growable: false);

    final list = useAdminRecordList<OpsTask>(
      items: scoped,
      searchText: (task) => [
        task.id,
        task.title,
        task.context,
        opsAssigneeLabel(l10n, task),
        task.branchIds.map((id) => opsBranchName(l10n, id)).join(' '),
        _priorityLabel(l10n, task.priority),
        _taskStatusLabel(l10n, task.status),
      ].join(' '),
    );

    final open = tasks.where((task) => !task.isDone).length;
    final dueToday = tasks
        .where((task) => task.isDueToday(opsReferenceDate))
        .length;
    final overdue = tasks
        .where((task) => task.isOverdue(opsReferenceDate))
        .length;
    final blocked = tasks
        .where((task) => task.status == OpsTaskStatus.blocked)
        .length;

    final branchOptions = [
      AdminFilterOption(
        value: '',
        label: l10n.adminFilterAll,
        count: tasks.length,
      ),
      for (final branchId in OperationsSeed.branchIds)
        AdminFilterOption(
          value: branchId,
          label: opsBranchName(l10n, branchId),
          count: tasks
              .where((task) => task.branchIds.contains(branchId))
              .length,
        ),
    ];

    return AdminWorkspaceScaffold(
      title: l10n.opsTabTasks,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.opsSearchTasks,
      metrics: [
        AdminMetric(
          label: l10n.opsMetricOpenTasks,
          value: adminGroupDigits(open),
          icon: LucideIcons.listChecks,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.opsMetricDueToday,
          value: adminGroupDigits(dueToday),
          icon: LucideIcons.calendarDays,
        ),
        AdminMetric(
          label: l10n.opsMetricOverdue,
          value: adminGroupDigits(overdue),
          icon: LucideIcons.circleAlert,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.opsMetricBlocked,
          value: adminGroupDigits(blocked),
          icon: LucideIcons.clock,
          tone: AdminPillTone.warning,
        ),
      ],
      filters: AdminFilterChips<String>(
        options: branchOptions,
        selected: selectedBranch.value,
        onSelected: (value) => selectedBranch.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.opsColTask, flex: 3),
          AdminTableColumn(label: l10n.opsColAssignee, flex: 2, hideBelow: 700),
          AdminTableColumn(label: l10n.opsColBranch, flex: 2, hideBelow: 980),
          AdminTableColumn(label: l10n.opsColPriority, hideBelow: 640),
          AdminTableColumn(label: l10n.opsColDue),
          AdminTableColumn(
            label: l10n.opsColChecklist,
            flex: 2,
            hideBelow: 780,
          ),
          AdminTableColumn(label: l10n.opsColStatus, hideBelow: 520),
        ],
        rows: [
          for (final task in list.visible)
            AdminTableRow(onTap: () => _showSampleAction(context), [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    task.context,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                opsAssigneeLabel(l10n, task),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                task.branchIds.map((id) => opsBranchName(l10n, id)).join('، '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              AdminStatusPill(
                label: _priorityLabel(l10n, task.priority),
                tone: _priorityTone(task.priority),
              ),
              Text(
                _dueLabel(context, task),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: adminToneColor(colorScheme, _dueTone(task)),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.opsTaskChecklistProgress(
                      task.doneSteps,
                      task.checklist.length,
                    ),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  AdminMeterBar(
                    value: task.completion,
                    height: 4,
                    color: adminToneColor(
                      colorScheme,
                      task.isDone
                          ? AdminPillTone.success
                          : AdminPillTone.primary,
                    ),
                  ),
                ],
              ),
              AdminStatusPill(
                label: _taskStatusLabel(l10n, task.status),
                tone: _taskStatusTone(task.status),
              ),
            ]),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Branch load
// ---------------------------------------------------------------------------

final class _BranchesTab extends HookWidget {
  const _BranchesTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final branches = OperationsSeed.branches(l10n);
    final tasks = OperationsSeed.tasks(l10n);
    final holds = OperationsSeed.holds(l10n);

    final list = useAdminRecordList<OpsBranch>(
      items: branches,
      searchText: (branch) => '${branch.name} ${branch.manager}',
      initialPageSize: 8,
    );

    final open = tasks.where((task) => !task.isDone).length;
    final overdue = tasks
        .where((task) => task.isOverdue(opsReferenceDate))
        .length;
    final waitingHolds = holds.where((hold) => hold.isWaiting).length;

    return AdminWorkspaceScaffold(
      title: l10n.opsTabBranches,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.opsSearchBranches,
      metrics: [
        AdminMetric(
          label: l10n.opsMetricBranches,
          value: adminGroupDigits(branches.length),
          icon: LucideIcons.building2,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.opsMetricBranchOpen,
          value: adminGroupDigits(open),
          icon: LucideIcons.listChecks,
        ),
        AdminMetric(
          label: l10n.opsMetricBranchOverdue,
          value: adminGroupDigits(overdue),
          icon: LucideIcons.circleAlert,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.opsMetricBranchHolds,
          value: adminGroupDigits(waitingHolds),
          icon: LucideIcons.packageCheck,
          tone: AdminPillTone.success,
        ),
      ],
      list: list,
      body: AdminCardGrid(
        children: [
          for (final branch in list.visible)
            _BranchCard(branch: branch, tasks: tasks, holds: holds),
        ],
      ),
    );
  }
}

final class _BranchCard extends StatelessWidget {
  const _BranchCard({
    required this.branch,
    required this.tasks,
    required this.holds,
  });

  final OpsBranch branch;
  final List<OpsTask> tasks;
  final List<OpsHold> holds;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final branchTasks = tasks
        .where((task) => task.branchIds.contains(branch.id))
        .toList(growable: false);
    final open = branchTasks.where((task) => !task.isDone).length;
    final overdue = branchTasks
        .where((task) => task.isOverdue(opsReferenceDate))
        .length;
    final done = branchTasks.length - open;
    final waitingHolds = holds
        .where((hold) => hold.branchId == branch.id && hold.isWaiting)
        .length;
    final load = _ratio(open, branch.team);
    final completion = _ratio(done, branchTasks.length);

    final (loadLabel, loadTone) = switch (load) {
      >= 0.5 => (l10n.opsBranchOverloaded, AdminPillTone.warning),
      >= 0.3 => (l10n.opsBranchBusy, AdminPillTone.primary),
      _ => (l10n.opsBranchOnTrack, AdminPillTone.success),
    };

    final tone = adminToneColor(colorScheme, loadTone);

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.small),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.small),
                ),
                child: Icon(
                  LucideIcons.building2,
                  size: AppIconSizes.small,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                    Text(
                      '${l10n.opsBranchManager} · ${branch.manager}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AdminStatusPill(label: loadLabel, tone: loadTone),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.opsBranchCompletion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                adminFormatPercent(completion * 100),
                style: textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          AdminMeterBar(
            value: completion,
            color: adminToneColor(colorScheme, AdminPillTone.success),
          ),
          const SizedBox(height: AppSpacing.small),
          AdminMeterBar(value: load / 0.75, color: tone),
          const SizedBox(height: AppSpacing.medium),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              AdminStatusPill(
                label: l10n.opsBranchOpenTasks(open),
                icon: LucideIcons.listChecks,
              ),
              AdminStatusPill(
                label: l10n.opsBranchOverdueTasks(overdue),
                tone: overdue == 0
                    ? AdminPillTone.muted
                    : AdminPillTone.warning,
                icon: LucideIcons.circleAlert,
              ),
              AdminStatusPill(
                label: l10n.opsBranchHolds(waitingHolds),
                icon: LucideIcons.packageCheck,
              ),
              AdminStatusPill(
                label: l10n.opsBranchTeam(branch.team),
                icon: LucideIcons.users,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Customer holds
// ---------------------------------------------------------------------------

final class _HoldsTab extends HookWidget {
  const _HoldsTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final holds = OperationsSeed.holds(l10n);
    final selectedBranch = useState<String>('');

    final scoped = selectedBranch.value.isEmpty
        ? holds
        : holds
              .where((hold) => hold.branchId == selectedBranch.value)
              .toList(growable: false);

    final list = useAdminRecordList<OpsHold>(
      items: scoped,
      searchText: (hold) => [
        hold.id,
        hold.customer,
        hold.item,
        opsBranchName(l10n, hold.branchId),
        _holdTypeLabel(l10n, hold.type),
        _holdStatusLabel(l10n, hold.status),
      ].join(' '),
    );

    final today = opsDateOnly(opsReferenceDate);
    final waiting = holds.where((hold) => hold.isWaiting).length;
    final arriving = holds
        .where(
          (hold) =>
              hold.isWaiting &&
              !opsDateOnly(hold.expected).isBefore(today) &&
              opsDateOnly(hold.expected).difference(today).inDays <= 7,
        )
        .length;
    final deposits = holds
        .where((hold) => hold.status != OpsHoldStatus.cancelled)
        .fold<int>(0, (sum, hold) => sum + hold.deposit);
    final ready = holds
        .where((hold) => hold.status == OpsHoldStatus.ready)
        .length;

    final branchOptions = [
      AdminFilterOption(
        value: '',
        label: l10n.adminFilterAll,
        count: holds.length,
      ),
      for (final branchId in OperationsSeed.branchIds)
        AdminFilterOption(
          value: branchId,
          label: opsBranchName(l10n, branchId),
          count: holds.where((hold) => hold.branchId == branchId).length,
        ),
    ];

    return AdminWorkspaceScaffold(
      title: l10n.opsTabHolds,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.opsSearchHolds,
      notice: AdminPlannedNotice(
        title: l10n.opsPlannedHoldsTitle,
        body: l10n.opsPlannedHoldsBody,
      ),
      metrics: [
        AdminMetric(
          label: l10n.opsMetricWaiting,
          value: adminGroupDigits(waiting),
          icon: LucideIcons.clock,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.opsMetricArriving,
          value: adminGroupDigits(arriving),
          icon: LucideIcons.calendarDays,
        ),
        AdminMetric(
          label: l10n.opsMetricDeposits,
          value: adminFormatAmount(context, deposits),
          icon: LucideIcons.package,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.opsMetricReady,
          value: adminGroupDigits(ready),
          icon: LucideIcons.check,
          tone: AdminPillTone.success,
        ),
      ],
      filters: AdminFilterChips<String>(
        options: branchOptions,
        selected: selectedBranch.value,
        onSelected: (value) => selectedBranch.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.opsColCustomer, flex: 2),
          AdminTableColumn(label: l10n.opsColItem, flex: 3),
          AdminTableColumn(label: l10n.opsColBranch, flex: 2, hideBelow: 880),
          AdminTableColumn(label: l10n.formFieldStatus, hideBelow: 700),
          AdminTableColumn(
            label: l10n.opsColDeposit,
            alignEnd: true,
            hideBelow: 620,
          ),
          AdminTableColumn(label: l10n.opsColExpected),
          AdminTableColumn(label: l10n.opsColStatus, hideBelow: 480),
        ],
        rows: [
          for (final hold in list.visible)
            AdminTableRow(onTap: () => _showSampleAction(context), [
              Text(
                hold.customer,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hold.item,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  if (hold.type == OpsHoldType.custom &&
                      hold.sizeWidth != null &&
                      hold.sizeLength != null)
                    Text(
                      l10n.opsSizeCustom(hold.sizeWidth!, hold.sizeLength!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              Text(
                opsBranchName(l10n, hold.branchId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                _holdTypeLabel(l10n, hold.type),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                adminFormatAmount(context, hold.deposit),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              Text(
                _expectedLabel(context, hold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: adminToneColor(colorScheme, _expectedTone(hold)),
                ),
              ),
              AdminStatusPill(
                label: _holdStatusLabel(l10n, hold.status),
                tone: _holdStatusTone(hold.status),
              ),
            ]),
        ],
      ),
    );
  }
}
