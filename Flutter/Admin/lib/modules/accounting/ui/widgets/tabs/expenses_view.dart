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

/// Expenses list (`GET|POST expenses`).
final class ExpensesView extends HookWidget {
  const ExpensesView({
    required this.section,
    required this.onCreate,
    required this.onOpen,
    super.key,
  });

  final AdminSubSection section;
  final VoidCallback onCreate;
  final ValueChanged<ExpenseRow> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final expenses = accountingExpenses(l10n);
    final category = useState<ExpenseCategory?>(null);

    final scoped = category.value == null
        ? expenses
        : expenses
              .where((expense) => expense.category == category.value)
              .toList(growable: false);

    final list = useAdminRecordList<ExpenseRow>(
      items: scoped,
      searchText: (expense) =>
          '${expense.id} '
          '${accountingCategoryLabel(l10n, expense.category)} '
          '${accountingBranchName(l10n, expense.branchId) ?? ''} '
          '${expense.approvedBy ?? ''}',
    );

    final total = expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    final pending = expenses.where((expense) => !expense.approved).length;

    return AdminWorkspaceScaffold(
      title: section.title,
      icon: section.icon,
      sectionId: section.id,
      list: list,
      onCreate: onCreate,
      searchHint: l10n.accountingSearchExpenses,
      metrics: [
        AdminMetric(
          label: l10n.accountingMetricExpenses,
          value: adminGroupDigits(expenses.length),
          icon: LucideIcons.receipt,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingTotal,
          value: adminFormatAmount(context, total),
          icon: LucideIcons.banknote,
          tone: AdminPillTone.success,
        ),
        AdminMetric(
          label: l10n.accountingMetricPendingReview,
          value: adminGroupDigits(pending),
          icon: LucideIcons.clock,
          tone: pending == 0 ? AdminPillTone.success : AdminPillTone.warning,
        ),
      ],
      filters: AdminFilterChips<ExpenseCategory?>(
        options: [
          AdminFilterOption(
            value: null,
            label: l10n.adminFilterAll,
            count: expenses.length,
          ),
          for (final value in ExpenseCategory.values)
            AdminFilterOption(
              value: value,
              label: accountingCategoryLabel(l10n, value),
              count: expenses.where((item) => item.category == value).length,
            ),
        ],
        selected: category.value,
        onSelected: (value) => category.value = value,
      ),
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.accountingReference, flex: 2),
          AdminTableColumn(label: l10n.accountingCategory, flex: 2),
          AdminTableColumn(label: l10n.accountingBranch, hideBelow: 560),
          AdminTableColumn(label: l10n.accountingReceipt, hideBelow: 720),
          AdminTableColumn(label: l10n.accountingStatus, hideBelow: 880),
          AdminTableColumn(label: l10n.accountingAmount, alignEnd: true),
        ],
        rows: [
          for (final expense in list.visible)
            AdminTableRow([
              Text(expense.id, style: textTheme.bodyMedium),
              Text(
                accountingCategoryLabel(l10n, expense.category),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              Text(
                accountingBranchName(l10n, expense.branchId) ??
                    l10n.adminFilterAll,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              AdminStatusPill(
                label: expense.hasReceipt
                    ? l10n.accountingReceiptAttached
                    : l10n.accountingNoReceipt,
                tone: expense.hasReceipt
                    ? AdminPillTone.success
                    : AdminPillTone.muted,
              ),
              AdminStatusPill(
                label: accountingApprovalLabel(l10n, expense),
                tone: accountingApprovalTone(expense),
              ),
              Text(
                adminFormatAmount(context, expense.amount),
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium,
              ),
            ], onTap: () => onOpen(expense)),
        ],
      ),
    );
  }
}
