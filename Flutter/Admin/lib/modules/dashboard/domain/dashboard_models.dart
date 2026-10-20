/// Time window selected in the dashboard filter bar.
enum DashboardPeriod { last7, last30, last90 }

extension DashboardPeriodInfo on DashboardPeriod {
  /// Number of days covered by the period.
  int get days => switch (this) {
    DashboardPeriod.last7 => 7,
    DashboardPeriod.last30 => 30,
    DashboardPeriod.last90 => 90,
  };
}

/// Direction of a KPI change.
enum DashboardTrend { up, down, flat }

/// Stable identity for each headline KPI.
enum DashboardKpiId {
  revenue,
  profit,
  orders,
  averageOrder,
  customers,
  lowStock,
}

/// RFM customer bucket returned by the analytics service.
enum RfmSegment { champions, loyal, potential, newCustomers, atRisk, lost }

/// Outcome recorded for a sales-floor product question.
enum InquiryOutcome { bought, price, noStock, justAsking }

/// Lifecycle of a warranty claim.
enum ClaimStatus { open, inspection, resolved }

/// Kind of movement recorded in the stock and sales audit trail.
enum AuditAction {
  transfer,
  adjustment,
  priceChange,
  shiftClosed,
  warranty,
  purchaseReceipt,
}

/// Order lifecycle used by recent orders and the customer profile.
enum OrderStatus { paid, pending, shipping, delivered, cancelled }

/// Loyalty programme tier.
enum LoyaltyTier { bronze, silver, gold, platinum }

/// One headline number rendered in the KPI grid.
final class DashboardKpi {
  const DashboardKpi({
    required this.id,
    required this.label,
    required this.value,
    required this.changePercent,
    required this.trend,
    required this.positive,
  });

  final DashboardKpiId id;
  final String label;
  final String value;
  final double changePercent;
  final DashboardTrend trend;

  /// Whether the movement is good for the business (falling low stock is good).
  final bool positive;
}

/// Revenue and profit for one chart bucket.
final class RevenuePoint {
  const RevenuePoint({
    required this.label,
    required this.revenue,
    required this.profit,
  });

  final String label;
  final double revenue;
  final double profit;
}

/// Stock and valuation held by one warehouse.
final class WarehouseStock {
  const WarehouseStock({
    required this.id,
    required this.name,
    required this.city,
    required this.quantity,
    required this.value,
    required this.lowStock,
  });

  final String id;
  final String name;
  final String city;
  final int quantity;
  final double value;
  final int lowStock;
}

/// Sales performance for one branch.
final class BranchPerformance {
  const BranchPerformance({
    required this.id,
    required this.name,
    required this.city,
    required this.revenue,
    required this.profit,
    required this.orders,
    required this.share,
  });

  final String id;
  final String name;
  final String city;
  final double revenue;
  final double profit;
  final int orders;
  final double share;
}

/// Turnover speed for one product variant in a warehouse.
final class VelocityRow {
  const VelocityRow({
    required this.variant,
    required this.product,
    required this.warehouse,
    required this.sold30d,
    required this.currentQty,
    required this.dailyAverage,
    required this.daysOfCover,
  });

  final String variant;
  final String product;
  final String warehouse;
  final int sold30d;
  final int currentQty;
  final double dailyAverage;
  final double daysOfCover;
}

/// Best-selling product for the selected period.
final class TopProduct {
  const TopProduct({
    required this.name,
    required this.category,
    required this.quantity,
    required this.revenue,
    required this.share,
  });

  final String name;
  final String category;
  final int quantity;
  final double revenue;
  final double share;
}

/// Delivery demand for one governorate.
final class GeoCell {
  const GeoCell({
    required this.governorate,
    required this.orders,
    required this.revenue,
    required this.share,
  });

  final String governorate;
  final int orders;
  final double revenue;
  final double share;
}

/// One RFM bucket and its share of the customer base.
final class RfmSlice {
  const RfmSlice({
    required this.segment,
    required this.customers,
    required this.monetary,
    required this.share,
  });

  final RfmSegment segment;
  final int customers;
  final double monetary;
  final double share;
}

/// A product question captured by the sales floor.
final class CustomerInquiry {
  const CustomerInquiry({
    required this.id,
    required this.customer,
    required this.phone,
    required this.product,
    required this.branch,
    required this.outcome,
    required this.note,
    required this.at,
  });

  final String id;
  final String customer;
  final String phone;
  final String product;
  final String branch;
  final InquiryOutcome outcome;
  final String note;
  final String at;
}

/// Aggregate of the most asked products and the sales they represent.
final class TopAskedProduct {
  const TopAskedProduct({
    required this.product,
    required this.asked,
    required this.noStock,
    required this.priceAsks,
  });

  final String product;
  final int asked;
  final int noStock;
  final int priceAsks;
}

/// One entry in the stock and sales audit trail.
final class AuditEvent {
  const AuditEvent({
    required this.id,
    required this.action,
    required this.actor,
    required this.entity,
    required this.detail,
    required this.at,
  });

  final String id;
  final AuditAction action;
  final String actor;
  final String entity;
  final String detail;
  final String at;
}

/// Order shown on the customer profile.
final class CustomerOrder {
  const CustomerOrder({
    required this.reference,
    required this.date,
    required this.total,
    required this.status,
    required this.channel,
    required this.items,
  });

  final String reference;
  final String date;
  final double total;
  final OrderStatus status;
  final String channel;
  final int items;
}

/// Warranty or claim recorded against a customer.
final class WarrantyClaim {
  const WarrantyClaim({
    required this.product,
    required this.purchased,
    required this.expires,
    required this.status,
    required this.issue,
  });

  final String product;
  final String purchased;
  final String expires;
  final ClaimStatus status;
  final String issue;
}

/// Saved delivery address for a customer.
final class CustomerAddress {
  const CustomerAddress({
    required this.label,
    required this.line,
    required this.city,
    required this.phone,
  });

  final String label;
  final String line;
  final String city;
  final String phone;
}

/// Full customer record opened from the top-customers table.
final class DashboardCustomer {
  const DashboardCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.segment,
    required this.tier,
    required this.branch,
    required this.since,
    required this.preferredChannel,
    required this.totalSpend,
    required this.orders,
    required this.loyaltyPoints,
    required this.addresses,
    required this.orderHistory,
    required this.claims,
    required this.notes,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final RfmSegment segment;
  final LoyaltyTier tier;
  final String branch;
  final String since;
  final String preferredChannel;
  final double totalSpend;
  final int orders;
  final int loyaltyPoints;
  final List<CustomerAddress> addresses;
  final List<CustomerOrder> orderHistory;
  final List<WarrantyClaim> claims;
  final String notes;

  /// Average value of the orders on record.
  double get averageOrder => orders == 0 ? 0 : totalSpend / orders;

  /// Quick search over the fields the counter uses.
  bool matches(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return true;
    }
    return name.toLowerCase().contains(needle) ||
        phone.replaceAll(' ', '').contains(needle.replaceAll(' ', '')) ||
        id.toLowerCase().contains(needle);
  }
}

/// Latest order across all branches.
final class RecentOrder {
  const RecentOrder({
    required this.reference,
    required this.customerId,
    required this.customerName,
    required this.branch,
    required this.channel,
    required this.status,
    required this.total,
    required this.date,
    required this.items,
  });

  final String reference;
  final String customerId;
  final String customerName;
  final String branch;
  final String channel;
  final OrderStatus status;
  final double total;
  final String date;
  final int items;
}

/// Branch option shown in the dashboard filter.
final class DashboardBranch {
  const DashboardBranch({
    required this.id,
    required this.name,
    required this.city,
  });

  final String id;
  final String name;
  final String city;
}

/// Everything the dashboard needs for one period and branch filter.
final class DashboardSnapshot {
  const DashboardSnapshot({
    required this.period,
    required this.branchId,
    required this.branchLabel,
    required this.kpis,
    required this.revenueSeries,
    required this.warehouses,
    required this.stockValue,
    required this.stockQuantity,
    required this.lowStockCount,
    required this.pendingTransfers,
    required this.openAudits,
    required this.branches,
    required this.branchOptions,
    required this.velocity,
    required this.topProducts,
    required this.rfm,
    required this.geo,
    required this.inquiries,
    required this.topAsked,
    required this.audit,
    required this.customers,
    required this.recentOrders,
  });

  final DashboardPeriod period;
  final String branchId;
  final String branchLabel;
  final List<DashboardKpi> kpis;
  final List<RevenuePoint> revenueSeries;
  final List<WarehouseStock> warehouses;
  final double stockValue;
  final int stockQuantity;
  final int lowStockCount;
  final int pendingTransfers;
  final int openAudits;
  final List<BranchPerformance> branches;
  final List<DashboardBranch> branchOptions;
  final List<VelocityRow> velocity;
  final List<TopProduct> topProducts;
  final List<RfmSlice> rfm;
  final List<GeoCell> geo;
  final List<CustomerInquiry> inquiries;
  final List<TopAskedProduct> topAsked;
  final List<AuditEvent> audit;
  final List<DashboardCustomer> customers;
  final List<RecentOrder> recentOrders;
}

/// Groups thousands with commas without pulling in `intl` for number display.
String dashboardInteger(num value) {
  final rounded = value.round();
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[index]);
  }
  return rounded < 0 ? '-$buffer' : buffer.toString();
}

/// Currency value using the localized currency label.
String dashboardMoney(num value, String currency) =>
    '${dashboardInteger(value)} $currency';

/// Percent value with one decimal place.
String dashboardPercent(num value) => '${value.toStringAsFixed(1)}%';

/// Value with one decimal place.
String dashboardDecimal(num value) => value.toStringAsFixed(1);

/// Signed percentage used by the KPI change line.
String dashboardDelta(double value) {
  final sign = value > 0
      ? '+'
      : value < 0
      ? '−'
      : '';
  return '$sign${value.abs().toStringAsFixed(1)}%';
}
