import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../domain/dashboard_models.dart';
import 'dashboard_shared.dart';

/// Searchable list of the customers with the highest lifetime spend.
final class DashboardTopCustomersCard extends HookWidget {
  const DashboardTopCustomersCard({
    required this.customers,
    required this.currency,
    required this.onOpenCustomer,
    super.key,
  });

  final List<DashboardCustomer> customers;
  final String currency;
  final ValueChanged<DashboardCustomer> onOpenCustomer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final page = useState(0);
    final pageSize = useState(4);
    final query = useState('');
    final search = useTextEditingController();

    final ranked = [...customers]
      ..sort((a, b) => b.totalSpend.compareTo(a.totalSpend));
    final filtered = query.value.trim().isEmpty
        ? ranked
        : ranked.where((customer) => customer.matches(query.value)).toList();
    final pageCount = math.max(1, (filtered.length / pageSize.value).ceil());
    final currentPage = math.min(page.value, pageCount - 1);
    final start = currentPage * pageSize.value;
    final visible = filtered.skip(start).take(pageSize.value).toList();

    void resetSearch() {
      search.clear();
      query.value = '';
      page.value = 0;
    }

    return DashboardSection(
      title: l10n.dashboardTopCustomers,
      subtitle: l10n.dashboardTopCustomersHint,
      icon: LucideIcons.crown,
      trailing: AdminStatusPill(
        label: '${dashboardInteger(filtered.length)} ${l10n.dashboardCustomers}',
        tone: AdminPillTone.primary,
        icon: LucideIcons.usersRound,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardSearchField(
            controller: search,
            hint: l10n.dashboardCustomerSearch,
            showClear: query.value.isNotEmpty,
            onChanged: (value) {
              query.value = value;
              page.value = 0;
            },
            onClear: resetSearch,
          ),
          const SizedBox(height: AppSpacing.medium),
          if (visible.isEmpty)
            DashboardEmptyState(
              icon: LucideIcons.usersRound,
              title: l10n.sectionNoResultsTitle,
              message: l10n.sectionNoResultsMessage,
              action: OutlinedButton.icon(
                onPressed: resetSearch,
                icon: const Icon(
                  LucideIcons.x,
                  size: AppIconSizes.small,
                ),
                label: Text(l10n.sectionClearSearch),
              ),
            )
          else ...[
            DashboardTable(
              columns: [
                DashboardTableColumn(label: l10n.dashboardCustomer, flex: 4),
                DashboardTableColumn(
                  label: l10n.dashboardCustomerContact,
                  flex: 3,
                ),
                DashboardTableColumn(
                  label: l10n.dashboardOrders,
                  flex: 1,
                  align: AlignmentDirectional.centerEnd,
                ),
                DashboardTableColumn(
                  label: l10n.dashboardCustomerSpend,
                  flex: 2,
                  align: AlignmentDirectional.centerEnd,
                ),
                DashboardTableColumn(
                  label: l10n.dashboardCustomerTier,
                  flex: 2,
                  align: AlignmentDirectional.centerEnd,
                ),
              ],
              rows: [
                for (final customer in visible)
                  DashboardTableRow([
                    DashboardTableCell(
                      customer.name,
                      secondary: customer.id,
                    ),
                    DashboardTableCell(
                      customer.phone,
                      secondary: customer.branch,
                    ),
                    DashboardTableCell(dashboardInteger(customer.orders)),
                    DashboardTableCell(
                      dashboardMoney(customer.totalSpend, currency),
                    ),
                    DashboardTableCell(
                      customer.tier.name,
                      child: AdminStatusPill(
                        label: l10n.dashboardTierLabel(customer.tier),
                        tone: AdminPillTone.primary,
                        icon: LucideIcons.crown,
                      ),
                    ),
                  ]),
              ],
              onRowTap: (index) => onOpenCustomer(visible[index]),
            ),
            const SizedBox(height: AppSpacing.medium),
            DashboardPagination(
              page: currentPage,
              pageCount: pageCount,
              pageSize: pageSize.value,
              total: filtered.length,
              pageSizeOptions: const [4, 8, 12],
              onPageChanged: (value) => page.value = value,
              onPageSizeChanged: (value) {
                pageSize.value = value;
                page.value = 0;
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Latest orders across every branch, with a shortcut to the buyer profile.
final class DashboardRecentOrdersCard extends HookWidget {
  const DashboardRecentOrdersCard({
    required this.orders,
    required this.currency,
    required this.onOpenCustomer,
    super.key,
  });

  final List<RecentOrder> orders;
  final String currency;
  final ValueChanged<String> onOpenCustomer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final page = useState(0);
    final pageSize = useState(5);

    final pageCount = math.max(1, (orders.length / pageSize.value).ceil());
    final currentPage = math.min(page.value, pageCount - 1);
    final start = currentPage * pageSize.value;
    final visible = orders.skip(start).take(pageSize.value).toList();

    return DashboardSection(
      title: l10n.dashboardRecentOrders,
      subtitle: l10n.dashboardRecentOrdersHint,
      icon: LucideIcons.receipt,
      trailing: AdminStatusPill(
        label: l10n.dashboardOrdersCount(dashboardInteger(orders.length)),
        tone: AdminPillTone.primary,
        icon: LucideIcons.shoppingBag,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (visible.isEmpty)
            DashboardEmptyState(
              icon: LucideIcons.receipt,
              title: l10n.sectionEmptyTitle,
              message: l10n.dashboardEmpty,
            )
          else ...[
            DashboardTable(
              columns: [
                DashboardTableColumn(label: l10n.dashboardOrder, flex: 2),
                DashboardTableColumn(label: l10n.dashboardCustomer, flex: 3),
                DashboardTableColumn(label: l10n.dashboardOrderDate, flex: 2),
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
                for (final order in visible)
                  DashboardTableRow([
                    DashboardTableCell(
                      order.reference,
                      secondary: order.channel,
                    ),
                    DashboardTableCell(
                      order.customerName,
                      secondary: order.branch,
                    ),
                    DashboardTableCell(order.date),
                    DashboardTableCell(
                      dashboardMoney(order.total, currency),
                    ),
                    DashboardTableCell(
                      order.status.name,
                      child: AdminStatusPill(
                        label: l10n.dashboardOrderStatus(order.status),
                        tone: l10n.dashboardOrderTone(order.status),
                      ),
                    ),
                  ]),
              ],
              onRowTap: (index) => onOpenCustomer(visible[index].customerId),
            ),
            const SizedBox(height: AppSpacing.medium),
            DashboardPagination(
              page: currentPage,
              pageCount: pageCount,
              pageSize: pageSize.value,
              total: orders.length,
              pageSizeOptions: const [5, 10, 20],
              onPageChanged: (value) => page.value = value,
              onPageSizeChanged: (value) {
                pageSize.value = value;
                page.value = 0;
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Questions recorded by the sales floor, with the outcome and note.
final class DashboardInquiriesCard extends HookWidget {
  const DashboardInquiriesCard({required this.inquiries, super.key});

  final List<CustomerInquiry> inquiries;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final page = useState(0);
    final pageSize = useState(5);

    final pageCount = math.max(1, (inquiries.length / pageSize.value).ceil());
    final currentPage = math.min(page.value, pageCount - 1);
    final start = currentPage * pageSize.value;
    final visible = inquiries.skip(start).take(pageSize.value).toList();

    return DashboardSection(
      title: l10n.dashboardInquiries,
      subtitle: l10n.dashboardInquiriesHint,
      icon: LucideIcons.messageCircleQuestion,
      trailing: AdminStatusPill(
        label: l10n.dashboardInquiriesCount(
          dashboardInteger(inquiries.length),
        ),
        tone: AdminPillTone.primary,
        icon: LucideIcons.inbox,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (visible.isEmpty)
            DashboardEmptyState(
              icon: LucideIcons.messageCircleQuestion,
              title: l10n.sectionEmptyTitle,
              message: l10n.dashboardEmpty,
            )
          else ...[
            DashboardTable(
              columns: [
                DashboardTableColumn(label: l10n.dashboardCustomer, flex: 3),
                DashboardTableColumn(label: l10n.dashboardProduct, flex: 3),
                DashboardTableColumn(label: l10n.formFieldNotes, flex: 3),
                DashboardTableColumn(
                  label: l10n.wireframeTableStatus,
                  flex: 2,
                  align: AlignmentDirectional.centerEnd,
                ),
                DashboardTableColumn(
                  label: l10n.dashboardOrderDate,
                  flex: 2,
                  align: AlignmentDirectional.centerEnd,
                ),
              ],
              rows: [
                for (final inquiry in visible)
                  DashboardTableRow([
                    DashboardTableCell(
                      inquiry.customer,
                      secondary: inquiry.phone,
                    ),
                    DashboardTableCell(
                      inquiry.product,
                      secondary: inquiry.branch,
                    ),
                    DashboardTableCell(inquiry.note),
                    DashboardTableCell(
                      inquiry.outcome.name,
                      child: AdminStatusPill(
                        label: l10n.dashboardInquiryLabel(inquiry.outcome),
                        tone: l10n.dashboardInquiryTone(inquiry.outcome),
                      ),
                    ),
                    DashboardTableCell(inquiry.at),
                  ]),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            DashboardPagination(
              page: currentPage,
              pageCount: pageCount,
              pageSize: pageSize.value,
              total: inquiries.length,
              pageSizeOptions: const [5, 10, 15],
              onPageChanged: (value) => page.value = value,
              onPageSizeChanged: (value) {
                pageSize.value = value;
                page.value = 0;
              },
            ),
          ],
        ],
      ),
    );
  }
}
