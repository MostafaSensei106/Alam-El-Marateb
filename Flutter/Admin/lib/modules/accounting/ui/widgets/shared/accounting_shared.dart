/// Small helpers shared by every accounting screen.
///
/// They only translate sample records into the labels, tones and date strings
/// the shared detail kit expects, so the tabs stay free of duplicated switch
/// statements.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';

/// Placeholder action used by every sample button until the wiring lands.
void accountingShowSampleAction(BuildContext context) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(context.localeKeys.adminSampleActionMessage)),
    );
}

/// `2026-10-21` rendered with the active locale.
String accountingDateLabel(BuildContext context, DateTime date) =>
    MaterialLocalizations.of(context).formatMediumDate(date);

/// `from – to` used by the report headers.
String accountingDateRangeLabel(
  BuildContext context,
  DateTime from,
  DateTime to,
) =>
    '${accountingDateLabel(context, from)} – ${accountingDateLabel(context, to)}';

/// Directional "back" button rendered inside a workspace header.
Widget accountingBackAction(BuildContext context, VoidCallback onBack) {
  final isRtl = Directionality.of(context) == TextDirection.rtl;

  return TextButton.icon(
    onPressed: onBack,
    icon: Icon(
      isRtl ? LucideIcons.arrowRight : LucideIcons.arrowLeft,
      size: AppIconSizes.small,
    ),
    label: Text(context.localeKeys.accountingBack),
  );
}

/// Segmented switch used to swap a tab between two list views.
final class AccountingViewSwitch<T> extends StatelessWidget {
  const AccountingViewSwitch({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<AdminFilterOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: AdminFilterChips<T>(
      options: options,
      selected: selected,
      onSelected: onSelected,
    ),
  );
}

// ---------------------------------------------------------------------------
// Tab view modes
// ---------------------------------------------------------------------------

/// Which of the two journal views is on screen.
enum JournalViewMode { entries, ledger }

/// Which of the two treasury views is on screen.
enum TreasuryViewMode { treasuries, transfers }

String accountingJournalViewLabel(
  AppLocalizations l10n,
  JournalViewMode mode,
) => switch (mode) {
  JournalViewMode.entries => l10n.accountingViewEntries,
  JournalViewMode.ledger => l10n.accountingViewLedger,
};

String accountingTreasuryViewLabel(
  AppLocalizations l10n,
  TreasuryViewMode mode,
) => switch (mode) {
  TreasuryViewMode.treasuries => l10n.accountingViewTreasuries,
  TreasuryViewMode.transfers => l10n.accountingViewTransfers,
};

// ---------------------------------------------------------------------------
// Enum labels and tones
// ---------------------------------------------------------------------------

String accountingAccountTypeLabel(AppLocalizations l10n, AccountType type) =>
    switch (type) {
      AccountType.asset => l10n.accountingTypeAsset,
      AccountType.liability => l10n.accountingTypeLiability,
      AccountType.equity => l10n.accountingTypeEquity,
      AccountType.revenue => l10n.accountingTypeRevenue,
      AccountType.expense => l10n.accountingTypeExpense,
    };

AdminPillTone accountingAccountTypeTone(AccountType type) => switch (type) {
  AccountType.asset => AdminPillTone.primary,
  AccountType.liability => AdminPillTone.warning,
  AccountType.equity => AdminPillTone.success,
  AccountType.revenue => AdminPillTone.success,
  AccountType.expense => AdminPillTone.warning,
};

String accountingSourceLabel(AppLocalizations l10n, JournalSource source) =>
    switch (source) {
      JournalSource.manual => l10n.accountingSourceManual,
      JournalSource.sales => l10n.accountingSourceSales,
      JournalSource.purchasing => l10n.accountingSourcePurchasing,
      JournalSource.expense => l10n.accountingSourceExpense,
      JournalSource.transfer => l10n.accountingSourceTransfer,
    };

AdminPillTone accountingSourceTone(JournalSource source) => switch (source) {
  JournalSource.manual => AdminPillTone.muted,
  JournalSource.sales => AdminPillTone.success,
  JournalSource.purchasing => AdminPillTone.primary,
  JournalSource.expense => AdminPillTone.warning,
  JournalSource.transfer => AdminPillTone.primary,
};

String accountingCategoryLabel(AppLocalizations l10n, ExpenseCategory value) =>
    switch (value) {
      ExpenseCategory.rent => l10n.accountingCategoryRent,
      ExpenseCategory.salaries => l10n.accountingCategorySalaries,
      ExpenseCategory.utilities => l10n.accountingCategoryUtilities,
      ExpenseCategory.marketing => l10n.accountingCategoryMarketing,
      ExpenseCategory.maintenance => l10n.accountingCategoryMaintenance,
      ExpenseCategory.transport => l10n.accountingCategoryTransport,
      ExpenseCategory.supplies => l10n.accountingCategorySupplies,
    };

String accountingDirectionLabel(
  AppLocalizations l10n,
  CheckDirection direction,
) =>
    switch (direction) {
      CheckDirection.incoming => l10n.accountingDirectionIn,
      CheckDirection.outgoing => l10n.accountingDirectionOut,
    };

String accountingCheckStatusLabel(AppLocalizations l10n, CheckStatus status) =>
    switch (status) {
      CheckStatus.held => l10n.accountingStatusHeld,
      CheckStatus.cashed => l10n.accountingStatusCashed,
      CheckStatus.bounced => l10n.accountingStatusBounced,
      CheckStatus.returned => l10n.accountingStatusReturned,
    };

AdminPillTone accountingCheckStatusTone(CheckStatus status) => switch (status) {
  CheckStatus.held => AdminPillTone.primary,
  CheckStatus.cashed => AdminPillTone.success,
  CheckStatus.bounced => AdminPillTone.warning,
  CheckStatus.returned => AdminPillTone.muted,
};

/// Approval state of an [ExpenseRow].
String accountingApprovalLabel(AppLocalizations l10n, ExpenseRow expense) =>
    expense.approved
    ? l10n.accountingApprovedBy
    : l10n.accountingApprovalPending;

AdminPillTone accountingApprovalTone(ExpenseRow expense) =>
    expense.approved ? AdminPillTone.success : AdminPillTone.warning;
