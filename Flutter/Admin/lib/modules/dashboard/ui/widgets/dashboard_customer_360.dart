import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../domain/dashboard_models.dart';
import 'dashboard_shared.dart';

/// Opens the full customer record over the dashboard.
Future<void> showDashboardCustomer360(
  BuildContext context, {
  required DashboardCustomer customer,
  required String currency,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.5),
    builder: (context) =>
        _DashboardCustomer360Dialog(customer: customer, currency: currency),
  );
}

final class _DashboardCustomer360Dialog extends StatelessWidget {
  const _DashboardCustomer360Dialog({
    required this.customer,
    required this.currency,
  });

  final DashboardCustomer customer;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(AppSpacing.large),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xLarge),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 860,
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: _CustomerHeader(customer: customer),
            ),
            Divider(
              height: 1,
              thickness: AppControlSizes.dividerThickness,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CustomerFacts(customer: customer, currency: currency),
                    const SizedBox(height: AppSpacing.xLarge),
                    AdminSectionHeading(
                      title: l10n.dashboardCustomerContact,
                      icon: LucideIcons.phone,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _ContactRow(
                      icon: LucideIcons.phone,
                      label: l10n.phone,
                      value: customer.phone,
                    ),
                    const SizedBox(height: AppSpacing.small),
                    _ContactRow(
                      icon: LucideIcons.mail,
                      label: l10n.profileEmail,
                      value: customer.email,
                    ),
                    const SizedBox(height: AppSpacing.xLarge),
                    AdminSectionHeading(
                      title: l10n.dashboardCustomerAddresses,
                      icon: LucideIcons.mapPin,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    if (customer.addresses.isEmpty)
                      _MutedLine(text: l10n.dashboardCustomerNoAddresses)
                    else
                      for (
                        var index = 0;
                        index < customer.addresses.length;
                        index++
                      ) ...[
                        if (index > 0) const SizedBox(height: AppSpacing.small),
                        _AddressTile(address: customer.addresses[index]),
                      ],
                    const SizedBox(height: AppSpacing.xLarge),
                    AdminSectionHeading(
                      title: l10n.dashboardCustomerRecentOrders,
                      icon: LucideIcons.receipt,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    if (customer.orderHistory.isEmpty)
                      _MutedLine(text: l10n.dashboardCustomerNoOrders)
                    else
                      DashboardTable(
                        columns: [
                          DashboardTableColumn(
                            label: l10n.dashboardOrder,
                            flex: 2,
                          ),
                          DashboardTableColumn(
                            label: l10n.dashboardOrderDate,
                            flex: 2,
                          ),
                          DashboardTableColumn(
                            label: l10n.dashboardItems,
                            align: AlignmentDirectional.centerEnd,
                          ),
                          DashboardTableColumn(
                            label: l10n.dashboardTotal,
                            flex: 2,
                            align: AlignmentDirectional.centerEnd,
                          ),
                          DashboardTableColumn(
                            label: l10n.wireframeTableStatus,
                            flex: 2,
                            align: AlignmentDirectional.centerEnd,
                          ),
                        ],
                        rows: [
                          for (final order in customer.orderHistory)
                            DashboardTableRow([
                              DashboardTableCell(
                                order.reference,
                                secondary: order.channel,
                              ),
                              DashboardTableCell(order.date),
                              DashboardTableCell(dashboardInteger(order.items)),
                              DashboardTableCell(
                                dashboardMoney(order.total, currency),
                              ),
                              DashboardTableCell(
                                order.status.name,
                                child: AdminStatusPill(
                                  label: l10n.dashboardOrderStatus(
                                    order.status,
                                  ),
                                  tone: l10n.dashboardOrderTone(order.status),
                                ),
                              ),
                            ]),
                        ],
                      ),
                    const SizedBox(height: AppSpacing.xLarge),
                    AdminSectionHeading(
                      title: l10n.dashboardCustomerWarranties,
                      icon: LucideIcons.wrench,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    if (customer.claims.isEmpty)
                      _MutedLine(text: l10n.dashboardCustomerNoClaims)
                    else
                      DashboardTable(
                        columns: [
                          DashboardTableColumn(
                            label: l10n.dashboardProduct,
                            flex: 3,
                          ),
                          DashboardTableColumn(
                            label: l10n.formFieldDate,
                            flex: 2,
                          ),
                          DashboardTableColumn(
                            label: l10n.dashboardWarrantyExpiry,
                            flex: 2,
                          ),
                          DashboardTableColumn(
                            label: l10n.wireframeTableStatus,
                            flex: 2,
                            align: AlignmentDirectional.centerEnd,
                          ),
                          DashboardTableColumn(
                            label: l10n.dashboardIssue,
                            flex: 3,
                          ),
                        ],
                        rows: [
                          for (final claim in customer.claims)
                            DashboardTableRow([
                              DashboardTableCell(claim.product),
                              DashboardTableCell(claim.purchased),
                              DashboardTableCell(claim.expires),
                              DashboardTableCell(
                                claim.status.name,
                                child: AdminStatusPill(
                                  label: l10n.dashboardClaimLabel(claim.status),
                                  tone: l10n.dashboardClaimTone(claim.status),
                                ),
                              ),
                              DashboardTableCell(claim.issue),
                            ]),
                        ],
                      ),
                    const SizedBox(height: AppSpacing.xLarge),
                    AdminSectionHeading(
                      title: l10n.dashboardCustomerNotes,
                      icon: LucideIcons.scrollText,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppRadii.large),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            LucideIcons.scrollText,
                            size: AppIconSizes.small,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(
                            child: Text(
                              customer.notes,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _CustomerHeader extends StatelessWidget {
  const _CustomerHeader({required this.customer});

  final DashboardCustomer customer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        final avatarSize = compact ? 44.0 : 56.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminAvatar(name: customer.name, size: avatarSize),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${customer.id} · '
                    '${l10n.dashboardCustomerSince(customer.since)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              tooltip: l10n.dashboardClose,
              icon: const Icon(LucideIcons.x, size: AppIconSizes.small),
            ),
          ],
        );
      },
    );
  }
}

final class _CustomerFacts extends StatelessWidget {
  const _CustomerFacts({required this.customer, required this.currency});

  final DashboardCustomer customer;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 640
            ? 4
            : width >= 330
            ? 2
            : 1;
        const spacing = AppSpacing.medium;
        final itemWidth = (width - spacing * (columns - 1)) / columns;

        final facts = <Widget>[
          DashboardFact(
            label: l10n.dashboardCustomerSpend,
            value: dashboardMoney(customer.totalSpend, currency),
            icon: LucideIcons.banknote,
          ),
          DashboardFact(
            label: l10n.dashboardCustomerAvgOrder,
            value: dashboardMoney(customer.averageOrder, currency),
            icon: LucideIcons.receipt,
          ),
          DashboardFact(
            label: l10n.dashboardOrders,
            value: dashboardInteger(customer.orders),
            icon: LucideIcons.shoppingBag,
          ),
          DashboardFact(
            label: l10n.dashboardCustomerPoints,
            value: dashboardInteger(customer.loyaltyPoints),
            icon: LucideIcons.sparkles,
          ),
          DashboardFact(
            label: l10n.dashboardCustomerTier,
            value: l10n.dashboardTierLabel(customer.tier),
            icon: LucideIcons.crown,
          ),
          DashboardFact(
            label: l10n.dashboardCustomerRfm,
            value: l10n.dashboardRfmLabel(customer.segment),
            icon: LucideIcons.usersRound,
          ),
          DashboardFact(
            label: l10n.dashboardCustomerPreferred,
            value: customer.preferredChannel,
            icon: LucideIcons.messageCircle,
          ),
          DashboardFact(
            label: l10n.dashboardPreferredBranch,
            value: customer.branch,
            icon: LucideIcons.store,
          ),
        ];

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final fact in facts) SizedBox(width: itemWidth, child: fact),
          ],
        );
      },
    );
  }
}

final class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: AppIconSizes.small, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.small),
        SizedBox(
          width: 96,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

final class _AddressTile extends StatelessWidget {
  const _AddressTile({required this.address});

  final CustomerAddress address;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.mapPin,
            size: AppIconSizes.small,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address.line,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '${address.city} · ${address.phone}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

final class _MutedLine extends StatelessWidget {
  const _MutedLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}
