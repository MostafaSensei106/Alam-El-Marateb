import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/navigation/admin_module.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_sample_operations.dart';
import '../shared/accounting_shared.dart';

/// Financial reports tab.
///
/// Contract: `GET reports/profit-loss?from&to`, `GET reports/balance-sheet?to`
/// and `GET reports/tax?from&to`.
final class ReportsTab extends StatelessWidget {
  const ReportsTab({required this.section, super.key});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final profitLoss = accountingProfitLoss();
    final balanceSheet = accountingBalanceSheet();
    final tax = accountingTaxReport();

    return AdminWorkspaceScaffold(
      title: section.title,
      icon: section.icon,
      sectionId: section.id,
      metrics: [
        AdminMetric(
          label: l10n.accountingMetricRevenue,
          value: adminFormatAmount(context, profitLoss.revenue),
          icon: LucideIcons.trendingUp,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingMetricNetProfit,
          value: adminFormatAmount(context, profitLoss.netProfit),
          icon: LucideIcons.wallet,
          tone: profitLoss.netProfit >= 0
              ? AdminPillTone.success
              : AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.accountingMetricVat,
          value: adminFormatAmount(context, tax.vatPortion),
          icon: LucideIcons.percent,
          tone: AdminPillTone.warning,
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReportCard(
            title: l10n.accountingReportProfitLoss,
            icon: LucideIcons.trendingUp,
            subtitle: accountingDateRangeLabel(
              context,
              profitLoss.from,
              profitLoss.to,
            ),
            rows: [
              (
                l10n.accountingMetricRevenue,
                adminFormatAmount(context, profitLoss.revenue),
                LucideIcons.trendingUp,
              ),
              (
                l10n.accountingMetricCogs,
                adminFormatAmount(context, profitLoss.cogs),
                LucideIcons.package,
              ),
              (
                l10n.accountingReportGrossProfit,
                adminFormatAmount(context, profitLoss.grossProfit),
                LucideIcons.calculator,
              ),
              (
                l10n.accountingMetricExpenses,
                adminFormatAmount(context, profitLoss.expenses),
                LucideIcons.receipt,
              ),
              (
                l10n.accountingMetricVat,
                adminFormatAmount(context, profitLoss.vatPortion),
                LucideIcons.percent,
              ),
              (
                l10n.accountingMetricNetProfit,
                adminFormatAmount(context, profitLoss.netProfit),
                LucideIcons.wallet,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          _ReportCard(
            title: l10n.accountingReportBalanceSheet,
            icon: LucideIcons.scale,
            subtitle:
                '${l10n.accountingReportAsOf} '
                '${accountingDateLabel(context, balanceSheet.asOf)}',
            rows: [
              (
                l10n.accountingMetricAssets,
                adminFormatAmount(context, balanceSheet.assets),
                LucideIcons.building2,
              ),
              (
                l10n.accountingMetricLiabilities,
                adminFormatAmount(context, balanceSheet.liabilities),
                LucideIcons.creditCard,
              ),
              (
                l10n.accountingMetricEquity,
                adminFormatAmount(context, balanceSheet.equity),
                LucideIcons.pieChart,
              ),
              (
                l10n.accountingBalanceSheetEquation,
                balanceSheet.balanced
                    ? l10n.accountingBalanced
                    : l10n.accountingUnbalanced,
                LucideIcons.check,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          _ReportCard(
            title: l10n.accountingReportTax,
            icon: LucideIcons.percent,
            subtitle: accountingDateRangeLabel(context, tax.from, tax.to),
            rows: [
              (
                l10n.accountingReportRevenueInclusive,
                adminFormatAmount(context, tax.revenueInclusive),
                LucideIcons.trendingUp,
              ),
              (
                l10n.accountingMetricVat,
                adminFormatAmount(context, tax.vatPortion),
                LucideIcons.percent,
              ),
              (
                l10n.accountingPeriod,
                accountingDateRangeLabel(context, tax.from, tax.to),
                LucideIcons.calendarRange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One report block: a heading plus its read-only figures.
final class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.icon,
    required this.rows,
    this.subtitle,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final List<(String, String, IconData)> rows;

  @override
  Widget build(BuildContext context) => AdminSurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminSectionHeading(title: title, subtitle: subtitle, icon: icon),
        const SizedBox(height: AppSpacing.small),
        for (final row in rows)
          AdminDetailRow(label: row.$1, value: row.$2, icon: row.$3),
      ],
    ),
  );
}
