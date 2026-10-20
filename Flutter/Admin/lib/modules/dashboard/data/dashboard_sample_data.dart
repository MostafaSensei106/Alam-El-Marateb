import '../../../../l10n/app_localizations.dart';
import '../domain/dashboard_models.dart';

/// Deterministic dashboard data shaped like the analytics API responses.
///
/// The admin app does not call the Kotlin analytics service yet, so every
/// number here is generated from the same period and branch filters the real
/// endpoints accept. Switching to HTTP later only replaces this file.
abstract final class DashboardSampleData {
  /// Filter value that keeps every branch visible.
  static const String allBranches = 'all';

  static const double _dailyRevenue = 138500;
  static const double _margin = 0.34;
  static const double _averageOrder = 2340;

  static const Map<String, double> _shares = {
    'tanta': 0.42,
    'cairo': 0.31,
    'alex': 0.17,
    'mansoura': 0.10,
  };

  static const Map<String, double> _growth = {
    'tanta': 1.8,
    'cairo': 0.9,
    'alex': -0.6,
    'mansoura': 1.1,
  };

  /// Branch options for the filter bar.
  static List<DashboardBranch> branches(AppLocalizations l10n) => [
    DashboardBranch(
      id: 'tanta',
      name: l10n.sampleBranch1,
      city: l10n.govGharbia,
    ),
    DashboardBranch(id: 'cairo', name: l10n.sampleBranch2, city: l10n.govCairo),
    DashboardBranch(
      id: 'alex',
      name: l10n.sampleBranch3,
      city: l10n.govAlexandria,
    ),
    DashboardBranch(
      id: 'mansoura',
      name: l10n.sampleBranch4,
      city: l10n.govDakahlia,
    ),
  ];

  /// Builds one full snapshot for the selected period and branch.
  static DashboardSnapshot snapshot({
    required AppLocalizations l10n,
    required DashboardPeriod period,
    required String branchId,
  }) {
    final options = branches(l10n);
    final selected = _findBranch(options, branchId);
    final share = selected == null ? 1.0 : _shares[selected.id]!;
    final branchOffset = selected == null ? 0.0 : _growth[selected.id]!;
    final currency = l10n.currencyEgp;
    final days = period.days;

    final periodGrowth = switch (period) {
      DashboardPeriod.last7 => 6.8,
      DashboardPeriod.last30 => 12.4,
      DashboardPeriod.last90 => 19.2,
    };
    final growth = periodGrowth + branchOffset;

    final revenue = _dailyRevenue * days * share;
    final profit = revenue * _margin;
    final averageOrder = _averageOrder * (1 + share * 0.06);
    final orders = (revenue / averageOrder).round();
    final customers = (orders * 0.38).round();
    final lowStock = selected == null
        ? 18
        : (18 * share * 2.1).round().clamp(2, 18).toInt();
    final pendingTransfers = selected == null
        ? 7
        : (7 * share * 2.3).round().clamp(1, 7).toInt();
    final openAudits = selected == null
        ? 3
        : (3 * share * 2.4).round().clamp(1, 3).toInt();

    final warehouses = _warehouses(l10n)
        .where((warehouse) => selected == null || warehouse.id == selected.id)
        .toList();
    final stockValue = warehouses.fold<double>(
      0,
      (total, warehouse) => total + warehouse.value,
    );
    final stockQuantity = warehouses.fold<int>(
      0,
      (total, warehouse) => total + warehouse.quantity,
    );

    return DashboardSnapshot(
      period: period,
      branchId: branchId,
      branchLabel: selected?.name ?? l10n.dashboardAllBranches,
      kpis: [
        DashboardKpi(
          id: DashboardKpiId.revenue,
          label: l10n.dashboardKpiRevenue,
          value: dashboardMoney(revenue, currency),
          changePercent: growth,
          trend: DashboardTrend.up,
          positive: true,
        ),
        DashboardKpi(
          id: DashboardKpiId.profit,
          label: l10n.dashboardKpiProfit,
          value: dashboardMoney(profit, currency),
          changePercent: growth - 1.1,
          trend: DashboardTrend.up,
          positive: true,
        ),
        DashboardKpi(
          id: DashboardKpiId.orders,
          label: l10n.dashboardKpiOrders,
          value: dashboardInteger(orders),
          changePercent: growth * 0.65,
          trend: DashboardTrend.up,
          positive: true,
        ),
        DashboardKpi(
          id: DashboardKpiId.averageOrder,
          label: l10n.dashboardKpiAverageOrder,
          value: dashboardMoney(averageOrder, currency),
          changePercent: growth * 0.28,
          trend: DashboardTrend.up,
          positive: true,
        ),
        DashboardKpi(
          id: DashboardKpiId.customers,
          label: l10n.dashboardKpiCustomers,
          value: dashboardInteger(customers),
          changePercent: growth * 0.44,
          trend: DashboardTrend.up,
          positive: true,
        ),
        DashboardKpi(
          id: DashboardKpiId.lowStock,
          label: l10n.dashboardKpiLowStock,
          value: dashboardInteger(lowStock),
          changePercent: -growth * 0.42,
          trend: DashboardTrend.down,
          positive: true,
        ),
      ],
      revenueSeries: _revenueSeries(l10n, period, revenue, profit),
      warehouses: warehouses,
      stockValue: stockValue,
      stockQuantity: stockQuantity,
      lowStockCount: lowStock,
      pendingTransfers: pendingTransfers,
      openAudits: openAudits,
      branches: _branchPerformance(l10n, options, days, selected, averageOrder),
      branchOptions: options,
      velocity: _velocity(l10n, selected),
      topProducts: _topProducts(l10n, revenue),
      rfm: _rfm(l10n),
      geo: _geo(l10n, revenue),
      inquiries: _inquiries(l10n, selected),
      topAsked: _topAsked(l10n),
      audit: _audit(l10n, currency),
      customers: _customers(l10n),
      recentOrders: _recentOrders(l10n, selected),
    );
  }

  static DashboardBranch? _findBranch(
    List<DashboardBranch> options,
    String id,
  ) {
    for (final branch in options) {
      if (branch.id == id) {
        return branch;
      }
    }
    return null;
  }

  static List<RevenuePoint> _revenueSeries(
    AppLocalizations l10n,
    DashboardPeriod period,
    double revenue,
    double profit,
  ) {
    final weights = switch (period) {
      DashboardPeriod.last7 => const <double>[
        0.86,
        0.94,
        0.78,
        1.12,
        1.04,
        1.28,
        1.21,
      ],
      DashboardPeriod.last30 => const <double>[0.92, 1.03, 0.97, 1.11, 1.18],
      DashboardPeriod.last90 => const <double>[
        0.82,
        0.88,
        0.91,
        0.95,
        0.93,
        0.98,
        1.02,
        1.00,
        1.05,
        1.09,
        1.12,
        1.16,
      ],
    };
    final weekdayLabels = <String>[
      l10n.weekdaySat,
      l10n.weekdaySun,
      l10n.weekdayMon,
      l10n.weekdayTue,
      l10n.weekdayWed,
      l10n.weekdayThu,
      l10n.weekdayFri,
    ];
    final totalWeight = weights.fold<double>(0, (sum, value) => sum + value);

    return [
      for (var index = 0; index < weights.length; index++)
        RevenuePoint(
          label: period == DashboardPeriod.last7
              ? weekdayLabels[index]
              : l10n.dashboardWeek('${index + 1}'),
          revenue: revenue / totalWeight * weights[index] / 1000,
          profit: profit / totalWeight * weights[index] / 1000,
        ),
    ];
  }

  static List<WarehouseStock> _warehouses(AppLocalizations l10n) => [
    WarehouseStock(
      id: 'tanta',
      name: l10n.warehouseTanta,
      city: l10n.govGharbia,
      quantity: 4200,
      value: 3850000,
      lowStock: 7,
    ),
    WarehouseStock(
      id: 'cairo',
      name: l10n.warehouseCairo,
      city: l10n.govCairo,
      quantity: 3100,
      value: 2940000,
      lowStock: 5,
    ),
    WarehouseStock(
      id: 'alex',
      name: l10n.warehouseAlex,
      city: l10n.govAlexandria,
      quantity: 1850,
      value: 1620000,
      lowStock: 4,
    ),
    WarehouseStock(
      id: 'mansoura',
      name: l10n.warehouseMansoura,
      city: l10n.govDakahlia,
      quantity: 1200,
      value: 980000,
      lowStock: 2,
    ),
  ];

  static List<BranchPerformance> _branchPerformance(
    AppLocalizations l10n,
    List<DashboardBranch> options,
    int days,
    DashboardBranch? selected,
    double averageOrder,
  ) {
    final allRevenue = _dailyRevenue * days;

    return [
      for (final branch in options)
        if (selected == null || selected.id == branch.id)
          BranchPerformance(
            id: branch.id,
            name: branch.name,
            city: branch.city,
            revenue: allRevenue * _shares[branch.id]!,
            profit:
                allRevenue *
                _shares[branch.id]! *
                _margin *
                (0.94 + _shares[branch.id]! * 0.14),
            orders: (allRevenue * _shares[branch.id]! / averageOrder).round(),
            share: _shares[branch.id]! * 100,
          ),
    ];
  }

  static List<VelocityRow> _velocity(
    AppLocalizations l10n,
    DashboardBranch? selected,
  ) {
    final warehouse = selected?.name ?? l10n.warehouseTanta;
    final products = [
      l10n.product1,
      l10n.product2,
      l10n.product5,
      l10n.product7,
      l10n.product9,
      l10n.product11,
    ];
    final sold = [186, 142, 260, 74, 205, 38];
    final current = [96, 54, 410, 31, 320, 6];
    final daily = [6.2, 4.7, 8.7, 2.5, 6.8, 1.3];

    return [
      for (var index = 0; index < products.length; index++)
        VelocityRow(
          variant: 'VAR-${210 + index}',
          product: products[index],
          warehouse: warehouse,
          sold30d: sold[index],
          currentQty: current[index],
          dailyAverage: daily[index],
          daysOfCover: current[index] / daily[index],
        ),
    ];
  }

  static List<TopProduct> _topProducts(AppLocalizations l10n, double revenue) {
    const shares = [0.18, 0.15, 0.12, 0.09, 0.07];
    const prices = [18500.0, 24500.0, 15200.0, 21000.0, 9800.0];
    final products = [
      (l10n.product1, l10n.categoryMattress),
      (l10n.product2, l10n.categoryMattress),
      (l10n.product3, l10n.categoryMattress),
      (l10n.product12, l10n.categoryMattress),
      (l10n.product7, l10n.categoryBase),
    ];

    return [
      for (var index = 0; index < products.length; index++)
        TopProduct(
          name: products[index].$1,
          category: products[index].$2,
          quantity: (revenue * shares[index] / prices[index]).round(),
          revenue: revenue * shares[index],
          share: shares[index] * 100,
        ),
    ];
  }

  static List<RfmSlice> _rfm(AppLocalizations l10n) => [
    const RfmSlice(
      segment: RfmSegment.champions,
      customers: 412,
      monetary: 31,
      share: 14,
    ),
    const RfmSlice(
      segment: RfmSegment.loyal,
      customers: 688,
      monetary: 24,
      share: 23,
    ),
    const RfmSlice(
      segment: RfmSegment.potential,
      customers: 534,
      monetary: 16,
      share: 18,
    ),
    const RfmSlice(
      segment: RfmSegment.newCustomers,
      customers: 720,
      monetary: 9,
      share: 25,
    ),
    const RfmSlice(
      segment: RfmSegment.atRisk,
      customers: 366,
      monetary: 13,
      share: 12,
    ),
    const RfmSlice(segment: RfmSegment.lost, customers: 218, monetary: 7, share: 8),
  ];

  static List<GeoCell> _geo(AppLocalizations l10n, double revenue) => [
    GeoCell(
      governorate: l10n.govGharbia,
      orders: 286,
      revenue: revenue * 0.27,
      share: 27,
    ),
    GeoCell(
      governorate: l10n.govCairo,
      orders: 244,
      revenue: revenue * 0.24,
      share: 24,
    ),
    GeoCell(
      governorate: l10n.govAlexandria,
      orders: 168,
      revenue: revenue * 0.16,
      share: 16,
    ),
    GeoCell(
      governorate: l10n.govDakahlia,
      orders: 132,
      revenue: revenue * 0.12,
      share: 12,
    ),
    GeoCell(
      governorate: l10n.govMenoufia,
      orders: 118,
      revenue: revenue * 0.11,
      share: 11,
    ),
    GeoCell(
      governorate: l10n.govSharqia,
      orders: 104,
      revenue: revenue * 0.10,
      share: 10,
    ),
  ];

  static List<CustomerInquiry> _inquiries(
    AppLocalizations l10n,
    DashboardBranch? selected,
  ) {
    final rows = [
      CustomerInquiry(
        id: 'INQ-4821',
        customer: l10n.customer1,
        phone: '+20 100 123 4567',
        product: l10n.product1,
        branch: l10n.sampleBranch1,
        outcome: InquiryOutcome.bought,
        note: l10n.dashboardInquiryNote1,
        at: '2026-10-20 10:42',
      ),
      CustomerInquiry(
        id: 'INQ-4820',
        customer: l10n.customer2,
        phone: '+20 101 555 8821',
        product: l10n.product2,
        branch: l10n.sampleBranch2,
        outcome: InquiryOutcome.price,
        note: l10n.dashboardInquiryNote2,
        at: '2026-10-20 10:18',
      ),
      CustomerInquiry(
        id: 'INQ-4819',
        customer: l10n.customer3,
        phone: '+20 102 774 1190',
        product: l10n.product8,
        branch: l10n.sampleBranch1,
        outcome: InquiryOutcome.justAsking,
        note: l10n.dashboardInquiryNote3,
        at: '2026-10-20 09:55',
      ),
      CustomerInquiry(
        id: 'INQ-4818',
        customer: l10n.customer4,
        phone: '+20 106 331 4478',
        product: l10n.product3,
        branch: l10n.sampleBranch3,
        outcome: InquiryOutcome.price,
        note: l10n.dashboardInquiryNote4,
        at: '2026-10-19 18:24',
      ),
      CustomerInquiry(
        id: 'INQ-4817',
        customer: l10n.customer5,
        phone: '+20 109 208 6612',
        product: l10n.product11,
        branch: l10n.sampleBranch1,
        outcome: InquiryOutcome.bought,
        note: l10n.dashboardInquiryNote5,
        at: '2026-10-19 17:03',
      ),
      CustomerInquiry(
        id: 'INQ-4816',
        customer: l10n.customer6,
        phone: '+20 111 640 9923',
        product: l10n.product12,
        branch: l10n.sampleBranch4,
        outcome: InquiryOutcome.noStock,
        note: l10n.dashboardInquiryNote6,
        at: '2026-10-19 15:47',
      ),
    ];

    if (selected == null) {
      return rows;
    }
    return rows.where((row) => row.branch == selected.name).toList();
  }

  static List<TopAskedProduct> _topAsked(AppLocalizations l10n) => [
    TopAskedProduct(
      product: l10n.product1,
      asked: 38,
      noStock: 2,
      priceAsks: 14,
    ),
    TopAskedProduct(
      product: l10n.product2,
      asked: 31,
      noStock: 1,
      priceAsks: 12,
    ),
    TopAskedProduct(
      product: l10n.product11,
      asked: 27,
      noStock: 4,
      priceAsks: 9,
    ),
    TopAskedProduct(
      product: l10n.product8,
      asked: 22,
      noStock: 0,
      priceAsks: 11,
    ),
    TopAskedProduct(
      product: l10n.product12,
      asked: 18,
      noStock: 3,
      priceAsks: 6,
    ),
  ];

  static List<AuditEvent> _audit(AppLocalizations l10n, String currency) => [
    AuditEvent(
      id: 'AUD-7712',
      action: AuditAction.transfer,
      actor: l10n.sampleEmployee1,
      entity: 'TRF-2041',
      detail: l10n.dashboardAuditTransferDetail(
        '12',
        l10n.warehouseTanta,
        l10n.warehouseCairo,
      ),
      at: '2026-10-20 10:28',
    ),
    AuditEvent(
      id: 'AUD-7711',
      action: AuditAction.priceChange,
      actor: l10n.adminDisplayName,
      entity: l10n.product2,
      detail: l10n.dashboardAuditPriceDetail(l10n.product2, '24,500', '25,900'),
      at: '2026-10-20 09:46',
    ),
    AuditEvent(
      id: 'AUD-7710',
      action: AuditAction.adjustment,
      actor: l10n.sampleEmployee2,
      entity: 'SS-160',
      detail: l10n.dashboardAuditAdjustmentDetail('SS-160', '−3'),
      at: '2026-10-20 09:12',
    ),
    AuditEvent(
      id: 'AUD-7709',
      action: AuditAction.warranty,
      actor: l10n.sampleEmployee3,
      entity: 'WC-3391',
      detail: l10n.dashboardAuditWarrantyDetail(l10n.customer1, l10n.product1),
      at: '2026-10-19 18:38',
    ),
    AuditEvent(
      id: 'AUD-7708',
      action: AuditAction.purchaseReceipt,
      actor: l10n.sampleEmployee4,
      entity: 'PO-1188',
      detail: l10n.dashboardAuditPurchaseDetail(
        l10n.supplierDeltaFoam,
        dashboardMoney(186000, currency),
      ),
      at: '2026-10-19 16:10',
    ),
    AuditEvent(
      id: 'AUD-7707',
      action: AuditAction.shiftClosed,
      actor: l10n.sampleEmployee1,
      entity: 'SHF-9042',
      detail: l10n.dashboardAuditShiftDetail(
        l10n.sampleBranch1,
        '−420 $currency',
      ),
      at: '2026-10-19 14:02',
    ),
  ];

  static List<DashboardCustomer> _customers(AppLocalizations l10n) {
    final home = l10n.addressHome;
    final work = l10n.addressWork;
    final family = l10n.addressFamily;
    final showroom = l10n.dashboardChannelShowroom;
    final whatsapp = l10n.dashboardChannelWhatsapp;
    final phoneChannel = l10n.dashboardChannelPhone;

    CustomerAddress address(String label, String line, String city) =>
        CustomerAddress(label: label, line: line, city: city, phone: '');

    CustomerOrder order(
      String reference,
      String date,
      double total,
      OrderStatus status,
      String channel,
      int items,
    ) => CustomerOrder(
      reference: reference,
      date: date,
      total: total,
      status: status,
      channel: channel,
      items: items,
    );

    WarrantyClaim claim(
      String product,
      String purchased,
      String expires,
      ClaimStatus status,
      String issue,
    ) => WarrantyClaim(
      product: product,
      purchased: purchased,
      expires: expires,
      status: status,
      issue: issue,
    );

    return [
      DashboardCustomer(
        id: 'C-1001',
        name: l10n.customer1,
        phone: '+20 100 123 4567',
        email: 'mona.abdelrahman@example.com',
        segment: RfmSegment.champions,
        tier: LoyaltyTier.platinum,
        branch: l10n.sampleBranch1,
        since: '2023-01-12',
        preferredChannel: whatsapp,
        totalSpend: 184500,
        orders: 14,
        loyaltyPoints: 3420,
        addresses: [
          address(home, l10n.addressLine1, l10n.govGharbia),
          address(work, l10n.addressLine2, l10n.govCairo),
        ],
        orderHistory: [
          order(
            'SO-10482',
            '2026-10-12',
            24800,
            OrderStatus.delivered,
            showroom,
            2,
          ),
          order(
            'SO-10311',
            '2026-08-04',
            18500,
            OrderStatus.delivered,
            whatsapp,
            1,
          ),
          order(
            'SO-10102',
            '2026-05-19',
            31200,
            OrderStatus.delivered,
            showroom,
            3,
          ),
        ],
        claims: [
          claim(
            l10n.product1,
            '2025-11-03',
            '2028-11-03',
            ClaimStatus.inspection,
            l10n.dashboardClaimIssue1,
          ),
        ],
        notes: l10n.dashboardCustomerNote1,
      ),
      DashboardCustomer(
        id: 'C-1002',
        name: l10n.customer2,
        phone: '+20 101 555 8821',
        email: 'youssef.kamal@example.com',
        segment: RfmSegment.champions,
        tier: LoyaltyTier.gold,
        branch: l10n.sampleBranch2,
        since: '2022-07-08',
        preferredChannel: phoneChannel,
        totalSpend: 268000,
        orders: 11,
        loyaltyPoints: 5120,
        addresses: [address(work, l10n.addressLine2, l10n.govCairo)],
        orderHistory: [
          order(
            'SO-10475',
            '2026-10-11',
            49000,
            OrderStatus.paid,
            phoneChannel,
            2,
          ),
          order(
            'SO-10344',
            '2026-08-22',
            73500,
            OrderStatus.delivered,
            phoneChannel,
            3,
          ),
          order(
            'SO-10089',
            '2026-04-02',
            24500,
            OrderStatus.delivered,
            showroom,
            1,
          ),
        ],
        claims: const [],
        notes: l10n.dashboardCustomerNote2,
      ),
      DashboardCustomer(
        id: 'C-1003',
        name: l10n.customer3,
        phone: '+20 102 774 1190',
        email: 'salma.fathy@example.com',
        segment: RfmSegment.loyal,
        tier: LoyaltyTier.gold,
        branch: l10n.sampleBranch1,
        since: '2023-03-21',
        preferredChannel: showroom,
        totalSpend: 96400,
        orders: 9,
        loyaltyPoints: 1980,
        addresses: [address(home, l10n.addressLine1, l10n.govGharbia)],
        orderHistory: [
          order(
            'SO-10461',
            '2026-10-09',
            15200,
            OrderStatus.delivered,
            showroom,
            1,
          ),
          order(
            'SO-10298',
            '2026-07-17',
            29600,
            OrderStatus.delivered,
            showroom,
            2,
          ),
        ],
        claims: const [],
        notes: l10n.dashboardCustomerNote3,
      ),
      DashboardCustomer(
        id: 'C-1004',
        name: l10n.customer4,
        phone: '+20 106 331 4478',
        email: 'karim.nabil@example.com',
        segment: RfmSegment.potential,
        tier: LoyaltyTier.silver,
        branch: l10n.sampleBranch3,
        since: '2024-02-14',
        preferredChannel: whatsapp,
        totalSpend: 58200,
        orders: 6,
        loyaltyPoints: 860,
        addresses: [address(home, l10n.addressLine3, l10n.govAlexandria)],
        orderHistory: [
          order(
            'SO-10452',
            '2026-10-07',
            21000,
            OrderStatus.shipping,
            whatsapp,
            1,
          ),
          order(
            'SO-10240',
            '2026-06-11',
            16900,
            OrderStatus.delivered,
            showroom,
            1,
          ),
        ],
        claims: [
          claim(
            l10n.product5,
            '2026-01-18',
            '2027-01-18',
            ClaimStatus.open,
            l10n.dashboardClaimIssue2,
          ),
        ],
        notes: l10n.dashboardCustomerNote4,
      ),
      DashboardCustomer(
        id: 'C-1005',
        name: l10n.customer5,
        phone: '+20 109 208 6612',
        email: 'hana.tarek@example.com',
        segment: RfmSegment.newCustomers,
        tier: LoyaltyTier.bronze,
        branch: l10n.sampleBranch1,
        since: '2026-09-30',
        preferredChannel: whatsapp,
        totalSpend: 24800,
        orders: 2,
        loyaltyPoints: 240,
        addresses: [address(family, l10n.addressLine1, l10n.govGharbia)],
        orderHistory: [
          order(
            'SO-10488',
            '2026-10-14',
            24800,
            OrderStatus.delivered,
            whatsapp,
            1,
          ),
        ],
        claims: const [],
        notes: l10n.dashboardCustomerNote3,
      ),
      DashboardCustomer(
        id: 'C-1006',
        name: l10n.customer6,
        phone: '+20 111 640 9923',
        email: 'omar.sherif@example.com',
        segment: RfmSegment.atRisk,
        tier: LoyaltyTier.silver,
        branch: l10n.sampleBranch4,
        since: '2022-11-05',
        preferredChannel: phoneChannel,
        totalSpend: 71900,
        orders: 7,
        loyaltyPoints: 1120,
        addresses: [address(home, l10n.addressLine4, l10n.govDakahlia)],
        orderHistory: [
          order(
            'SO-10388',
            '2026-09-02',
            19600,
            OrderStatus.delivered,
            phoneChannel,
            1,
          ),
          order(
            'SO-10174',
            '2026-03-28',
            29400,
            OrderStatus.cancelled,
            phoneChannel,
            2,
          ),
        ],
        claims: [
          claim(
            l10n.product1,
            '2024-06-12',
            '2027-06-12',
            ClaimStatus.resolved,
            l10n.dashboardClaimIssue4,
          ),
        ],
        notes: l10n.dashboardCustomerNote4,
      ),
      DashboardCustomer(
        id: 'C-1007',
        name: l10n.customer7,
        phone: '+20 112 884 3305',
        email: 'nour.adel@example.com',
        segment: RfmSegment.loyal,
        tier: LoyaltyTier.gold,
        branch: l10n.sampleBranch2,
        since: '2023-05-17',
        preferredChannel: showroom,
        totalSpend: 112300,
        orders: 10,
        loyaltyPoints: 2410,
        addresses: [address(home, l10n.addressLine2, l10n.govCairo)],
        orderHistory: [
          order('SO-10470', '2026-10-10', 18500, OrderStatus.paid, showroom, 1),
          order(
            'SO-10301',
            '2026-07-23',
            42000,
            OrderStatus.delivered,
            showroom,
            2,
          ),
        ],
        claims: const [],
        notes: l10n.dashboardCustomerNote3,
      ),
      DashboardCustomer(
        id: 'C-1008',
        name: l10n.customer8,
        phone: '+20 114 220 7748',
        email: 'ahmed.fathy@example.com',
        segment: RfmSegment.champions,
        tier: LoyaltyTier.platinum,
        branch: l10n.sampleBranch3,
        since: '2021-10-01',
        preferredChannel: phoneChannel,
        totalSpend: 312000,
        orders: 18,
        loyaltyPoints: 6400,
        addresses: [
          address(work, l10n.addressLine3, l10n.govAlexandria),
          address(family, l10n.addressLine1, l10n.govGharbia),
        ],
        orderHistory: [
          order(
            'SO-10480',
            '2026-10-13',
            90000,
            OrderStatus.paid,
            phoneChannel,
            4,
          ),
          order(
            'SO-10355',
            '2026-08-29',
            63000,
            OrderStatus.delivered,
            phoneChannel,
            3,
          ),
        ],
        claims: [
          claim(
            l10n.product2,
            '2026-02-20',
            '2029-02-20',
            ClaimStatus.inspection,
            l10n.dashboardClaimIssue1,
          ),
        ],
        notes: l10n.dashboardCustomerNote2,
      ),
      DashboardCustomer(
        id: 'C-1009',
        name: l10n.customer9,
        phone: '+20 115 907 2214',
        email: 'mariam.hossam@example.com',
        segment: RfmSegment.potential,
        tier: LoyaltyTier.silver,
        branch: l10n.sampleBranch1,
        since: '2024-08-09',
        preferredChannel: whatsapp,
        totalSpend: 44600,
        orders: 5,
        loyaltyPoints: 720,
        addresses: [address(home, l10n.addressLine1, l10n.govGharbia)],
        orderHistory: [
          order(
            'SO-10456',
            '2026-10-08',
            12800,
            OrderStatus.shipping,
            whatsapp,
            1,
          ),
          order(
            'SO-10266',
            '2026-06-30',
            18400,
            OrderStatus.delivered,
            whatsapp,
            1,
          ),
        ],
        claims: const [],
        notes: l10n.dashboardCustomerNote1,
      ),
      DashboardCustomer(
        id: 'C-1010',
        name: l10n.customer10,
        phone: '+20 116 445 9902',
        email: 'tamer.said@example.com',
        segment: RfmSegment.lost,
        tier: LoyaltyTier.bronze,
        branch: l10n.sampleBranch4,
        since: '2022-02-11',
        preferredChannel: showroom,
        totalSpend: 18700,
        orders: 3,
        loyaltyPoints: 180,
        addresses: [address(home, l10n.addressLine4, l10n.govDakahlia)],
        orderHistory: [
          order(
            'SO-10188',
            '2026-04-14',
            9800,
            OrderStatus.delivered,
            showroom,
            1,
          ),
        ],
        claims: [
          claim(
            l10n.product7,
            '2025-04-14',
            '2027-04-14',
            ClaimStatus.resolved,
            l10n.dashboardClaimIssue3,
          ),
        ],
        notes: l10n.dashboardCustomerNote4,
      ),
    ];
  }

  static List<RecentOrder> _recentOrders(
    AppLocalizations l10n,
    DashboardBranch? selected,
  ) {
    final orders = [
      RecentOrder(
        reference: 'SO-10488',
        customerId: 'C-1005',
        customerName: l10n.customer5,
        branch: l10n.sampleBranch1,
        channel: l10n.dashboardChannelWhatsapp,
        status: OrderStatus.delivered,
        total: 24800,
        date: '2026-10-14',
        items: 1,
      ),
      RecentOrder(
        reference: 'SO-10486',
        customerId: 'C-1008',
        customerName: l10n.customer8,
        branch: l10n.sampleBranch3,
        channel: l10n.dashboardChannelPhone,
        status: OrderStatus.shipping,
        total: 63500,
        date: '2026-10-14',
        items: 3,
      ),
      RecentOrder(
        reference: 'SO-10485',
        customerId: 'C-1002',
        customerName: l10n.customer2,
        branch: l10n.sampleBranch2,
        channel: l10n.dashboardChannelShowroom,
        status: OrderStatus.paid,
        total: 49000,
        date: '2026-10-13',
        items: 2,
      ),
      RecentOrder(
        reference: 'SO-10482',
        customerId: 'C-1001',
        customerName: l10n.customer1,
        branch: l10n.sampleBranch1,
        channel: l10n.dashboardChannelShowroom,
        status: OrderStatus.delivered,
        total: 24800,
        date: '2026-10-12',
        items: 2,
      ),
      RecentOrder(
        reference: 'SO-10475',
        customerId: 'C-1007',
        customerName: l10n.customer7,
        branch: l10n.sampleBranch2,
        channel: l10n.dashboardChannelShowroom,
        status: OrderStatus.paid,
        total: 18500,
        date: '2026-10-11',
        items: 1,
      ),
      RecentOrder(
        reference: 'SO-10461',
        customerId: 'C-1003',
        customerName: l10n.customer3,
        branch: l10n.sampleBranch1,
        channel: l10n.dashboardChannelShowroom,
        status: OrderStatus.delivered,
        total: 15200,
        date: '2026-10-09',
        items: 1,
      ),
      RecentOrder(
        reference: 'SO-10456',
        customerId: 'C-1009',
        customerName: l10n.customer9,
        branch: l10n.sampleBranch1,
        channel: l10n.dashboardChannelWhatsapp,
        status: OrderStatus.shipping,
        total: 12800,
        date: '2026-10-08',
        items: 1,
      ),
      RecentOrder(
        reference: 'SO-10452',
        customerId: 'C-1004',
        customerName: l10n.customer4,
        branch: l10n.sampleBranch3,
        channel: l10n.dashboardChannelWhatsapp,
        status: OrderStatus.shipping,
        total: 21000,
        date: '2026-10-07',
        items: 1,
      ),
    ];

    if (selected == null) {
      return orders;
    }
    return orders.where((order) => order.branch == selected.name).toList();
  }
}
