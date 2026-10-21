import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';

/// Bespoke inventory screens.
///
/// The generic section workspace only has room for four short cells, while the
/// inventory is organised around warehouses, stock balances, transfers, stock
/// counts and expiry batches. Every tab composes the shared detail kit so the
/// tables, filter chips and metric cards stay identical to the other modules
/// while the columns match the inventory domain.
final class InventoryWorkspace extends StatelessWidget {
  const InventoryWorkspace({required this.section, super.key});

  /// Sections handled by this workspace. Everything else keeps the generic
  /// sample-data workspace.
  static const Set<String> sectionIds = {
    'inventory.warehouses',
    'inventory.stocks',
    'inventory.transfers',
    'inventory.audits',
    'inventory.batches',
  };

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) => switch (section.id) {
    'inventory.warehouses' => _WarehousesTab(section: section),
    'inventory.stocks' => _StocksTab(section: section),
    'inventory.transfers' => _TransfersTab(section: section),
    'inventory.audits' => _AuditsTab(section: section),
    'inventory.batches' => _BatchesTab(section: section),
    _ => _WarehousesTab(section: section),
  };
}

void _showSampleAction(BuildContext context) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger.showSnackBar(
    SnackBar(content: Text(context.localeKeys.adminSampleActionMessage)),
  );
}

String _dateLabel(BuildContext context, DateTime date) =>
    MaterialLocalizations.of(context).formatMediumDate(date);

String _signed(int value) => value > 0 ? '+$value' : '$value';

// ---------------------------------------------------------------------------
// Sample records
// ---------------------------------------------------------------------------

final class _Warehouse {
  const _Warehouse({
    required this.id,
    required this.name,
    required this.manager,
    required this.capacity,
    required this.units,
    required this.products,
    required this.lowStock,
  });

  final String id;
  final String name;
  final String manager;
  final int capacity;
  final int units;
  final int products;
  final int lowStock;
}

final class _StockRow {
  const _StockRow({
    required this.product,
    required this.sku,
    required this.warehouseId,
    required this.onHand,
    required this.reorder,
    required this.price,
  });

  final String product;
  final String sku;
  final String warehouseId;
  final int onHand;
  final int reorder;
  final int price;

  _StockState get state {
    if (onHand <= 0) return _StockState.out;
    if (onHand < reorder) return _StockState.low;
    return _StockState.healthy;
  }

  int get value => price * onHand;
}

enum _StockState { healthy, low, out }

final class _Transfer {
  const _Transfer({
    required this.reference,
    required this.fromId,
    required this.toId,
    required this.units,
    required this.state,
    required this.date,
  });

  final String reference;
  final String fromId;
  final String toId;
  final int units;
  final _TransferState state;
  final DateTime date;
}

enum _TransferState { draft, transit, received }

final class _Audit {
  const _Audit({
    required this.reference,
    required this.warehouseId,
    required this.counter,
    required this.counted,
    required this.variance,
    required this.state,
    required this.date,
  });

  final String reference;
  final String warehouseId;
  final String counter;
  final int counted;
  final int variance;
  final _AuditState state;
  final DateTime date;
}

enum _AuditState { scheduled, counting, closed }

final class _Batch {
  const _Batch({
    required this.code,
    required this.product,
    required this.warehouseId,
    required this.quantity,
    required this.unitCost,
    required this.expiry,
  });

  final String code;
  final String product;
  final String warehouseId;
  final int quantity;
  final int unitCost;
  final DateTime expiry;

  int get daysLeft => expiry.difference(_today).inDays;

  int get value => unitCost * quantity;

  _BatchState get state {
    if (daysLeft < 0) return _BatchState.expired;
    if (daysLeft <= 60) return _BatchState.expiring;
    return _BatchState.valid;
  }
}

enum _BatchState { valid, expiring, expired }

final _today = DateTime(2026, 10, 21);

String _warehouseName(AppLocalizations l10n, String id) => switch (id) {
  'tanta' => l10n.warehouseTanta,
  'cairo' => l10n.warehouseCairo,
  'alex' => l10n.warehouseAlex,
  'mansoura' => l10n.warehouseMansoura,
  _ => id,
};

List<_Warehouse> _warehouses(AppLocalizations l10n) => [
  _Warehouse(
    id: 'tanta',
    name: l10n.warehouseTanta,
    manager: l10n.customer1,
    capacity: 12000,
    units: 8400,
    products: 184,
    lowStock: 6,
  ),
  _Warehouse(
    id: 'cairo',
    name: l10n.warehouseCairo,
    manager: l10n.customer2,
    capacity: 9000,
    units: 6100,
    products: 152,
    lowStock: 4,
  ),
  _Warehouse(
    id: 'alex',
    name: l10n.warehouseAlex,
    manager: l10n.customer3,
    capacity: 6000,
    units: 4200,
    products: 96,
    lowStock: 3,
  ),
  _Warehouse(
    id: 'mansoura',
    name: l10n.warehouseMansoura,
    manager: l10n.customer4,
    capacity: 4500,
    units: 1800,
    products: 61,
    lowStock: 1,
  ),
];

List<_StockRow> _stocks(AppLocalizations l10n) => [
  _StockRow(
    product: l10n.product1,
    sku: 'MAT-1601',
    warehouseId: 'tanta',
    onHand: 24,
    reorder: 10,
    price: 6450,
  ),
  _StockRow(
    product: l10n.product2,
    sku: 'MAT-1802',
    warehouseId: 'cairo',
    onHand: 8,
    reorder: 12,
    price: 9250,
  ),
  _StockRow(
    product: l10n.product3,
    sku: 'MAT-1503',
    warehouseId: 'tanta',
    onHand: 0,
    reorder: 6,
    price: 7800,
  ),
  _StockRow(
    product: l10n.product4,
    sku: 'MAT-1204',
    warehouseId: 'alex',
    onHand: 15,
    reorder: 8,
    price: 4500,
  ),
  _StockRow(
    product: l10n.product5,
    sku: 'PIL-5070',
    warehouseId: 'mansoura',
    onHand: 42,
    reorder: 20,
    price: 850,
  ),
  _StockRow(
    product: l10n.product6,
    sku: 'PIL-MEM',
    warehouseId: 'cairo',
    onHand: 6,
    reorder: 10,
    price: 690,
  ),
  _StockRow(
    product: l10n.product7,
    sku: 'BAS-1601',
    warehouseId: 'tanta',
    onHand: 11,
    reorder: 6,
    price: 5300,
  ),
  _StockRow(
    product: l10n.product8,
    sku: 'BAS-1802',
    warehouseId: 'alex',
    onHand: 4,
    reorder: 8,
    price: 6800,
  ),
  _StockRow(
    product: l10n.product9,
    sku: 'ACC-PRO',
    warehouseId: 'mansoura',
    onHand: 60,
    reorder: 25,
    price: 1200,
  ),
  _StockRow(
    product: l10n.product10,
    sku: 'ACC-SHE',
    warehouseId: 'cairo',
    onHand: 0,
    reorder: 15,
    price: 950,
  ),
  _StockRow(
    product: l10n.product11,
    sku: 'MAT-OVAL',
    warehouseId: 'tanta',
    onHand: 3,
    reorder: 5,
    price: 12500,
  ),
  _StockRow(
    product: l10n.product12,
    sku: 'MAT-HTL',
    warehouseId: 'cairo',
    onHand: 18,
    reorder: 10,
    price: 11200,
  ),
];

List<_Transfer> _transfers() => [
  _Transfer(
    reference: 'TR-1041',
    fromId: 'tanta',
    toId: 'cairo',
    units: 120,
    state: _TransferState.transit,
    date: DateTime(2026, 10, 18),
  ),
  _Transfer(
    reference: 'TR-1040',
    fromId: 'cairo',
    toId: 'alex',
    units: 60,
    state: _TransferState.draft,
    date: DateTime(2026, 10, 17),
  ),
  _Transfer(
    reference: 'TR-1039',
    fromId: 'alex',
    toId: 'tanta',
    units: 40,
    state: _TransferState.received,
    date: DateTime(2026, 10, 12),
  ),
  _Transfer(
    reference: 'TR-1038',
    fromId: 'mansoura',
    toId: 'cairo',
    units: 90,
    state: _TransferState.received,
    date: DateTime(2026, 10, 8),
  ),
  _Transfer(
    reference: 'TR-1037',
    fromId: 'tanta',
    toId: 'mansoura',
    units: 25,
    state: _TransferState.received,
    date: DateTime(2026, 10),
  ),
  _Transfer(
    reference: 'TR-1036',
    fromId: 'cairo',
    toId: 'tanta',
    units: 140,
    state: _TransferState.transit,
    date: DateTime(2026, 10, 19),
  ),
];

List<_Audit> _audits(AppLocalizations l10n) => [
  _Audit(
    reference: 'AU-204',
    warehouseId: 'tanta',
    counter: l10n.customer5,
    counted: 1180,
    variance: -6,
    state: _AuditState.counting,
    date: DateTime(2026, 10, 20),
  ),
  _Audit(
    reference: 'AU-203',
    warehouseId: 'cairo',
    counter: l10n.customer6,
    counted: 940,
    variance: 3,
    state: _AuditState.scheduled,
    date: DateTime(2026, 10, 23),
  ),
  _Audit(
    reference: 'AU-202',
    warehouseId: 'alex',
    counter: l10n.customer7,
    counted: 620,
    variance: -2,
    state: _AuditState.closed,
    date: DateTime(2026, 10, 11),
  ),
  _Audit(
    reference: 'AU-201',
    warehouseId: 'mansoura',
    counter: l10n.customer8,
    counted: 410,
    variance: 0,
    state: _AuditState.closed,
    date: DateTime(2026, 10, 4),
  ),
  _Audit(
    reference: 'AU-200',
    warehouseId: 'tanta',
    counter: l10n.customer9,
    counted: 1200,
    variance: 5,
    state: _AuditState.closed,
    date: DateTime(2026, 9, 27),
  ),
];

List<_Batch> _batches(AppLocalizations l10n) => [
  _Batch(
    code: 'BAT-7781',
    product: l10n.product1,
    warehouseId: 'tanta',
    quantity: 120,
    unitCost: 6450,
    expiry: DateTime(2027, 3, 15),
  ),
  _Batch(
    code: 'BAT-7780',
    product: l10n.product5,
    warehouseId: 'mansoura',
    quantity: 240,
    unitCost: 850,
    expiry: DateTime(2026, 11, 2),
  ),
  _Batch(
    code: 'BAT-7779',
    product: l10n.product9,
    warehouseId: 'mansoura',
    quantity: 80,
    unitCost: 1200,
    expiry: DateTime(2026, 12, 20),
  ),
  _Batch(
    code: 'BAT-7778',
    product: l10n.product2,
    warehouseId: 'cairo',
    quantity: 18,
    unitCost: 9250,
    expiry: DateTime(2026, 10, 5),
  ),
  _Batch(
    code: 'BAT-7777',
    product: l10n.product7,
    warehouseId: 'tanta',
    quantity: 36,
    unitCost: 5300,
    expiry: DateTime(2027, 6),
  ),
  _Batch(
    code: 'BAT-7776',
    product: l10n.product11,
    warehouseId: 'tanta',
    quantity: 6,
    unitCost: 12500,
    expiry: DateTime(2027, 1, 18),
  ),
  _Batch(
    code: 'BAT-7775',
    product: l10n.product12,
    warehouseId: 'cairo',
    quantity: 24,
    unitCost: 11200,
    expiry: DateTime(2026, 11, 28),
  ),
  _Batch(
    code: 'BAT-7774',
    product: l10n.product4,
    warehouseId: 'alex',
    quantity: 48,
    unitCost: 4500,
    expiry: DateTime(2027, 2, 14),
  ),
  _Batch(
    code: 'BAT-7773',
    product: l10n.product8,
    warehouseId: 'alex',
    quantity: 12,
    unitCost: 6800,
    expiry: DateTime(2026, 9, 30),
  ),
  _Batch(
    code: 'BAT-7772',
    product: l10n.product6,
    warehouseId: 'cairo',
    quantity: 30,
    unitCost: 690,
    expiry: DateTime(2027, 4, 22),
  ),
];

// ---------------------------------------------------------------------------
// Labels
// ---------------------------------------------------------------------------

String _stockStateLabel(AppLocalizations l10n, _StockState state) =>
    switch (state) {
      _StockState.healthy => l10n.catalogStockIn,
      _StockState.low => l10n.catalogStockLow,
      _StockState.out => l10n.catalogStockOut,
    };

AdminPillTone _stockStateTone(_StockState state) => switch (state) {
  _StockState.healthy => AdminPillTone.success,
  _StockState.low => AdminPillTone.warning,
  _StockState.out => AdminPillTone.primary,
};

String _transferStateLabel(AppLocalizations l10n, _TransferState state) =>
    switch (state) {
      _TransferState.draft => l10n.inventoryTransferDraft,
      _TransferState.transit => l10n.inventoryTransferTransit,
      _TransferState.received => l10n.inventoryTransferReceived,
    };

AdminPillTone _transferStateTone(_TransferState state) => switch (state) {
  _TransferState.draft => AdminPillTone.muted,
  _TransferState.transit => AdminPillTone.primary,
  _TransferState.received => AdminPillTone.success,
};

String _auditStateLabel(AppLocalizations l10n, _AuditState state) =>
    switch (state) {
      _AuditState.scheduled => l10n.inventoryAuditScheduled,
      _AuditState.counting => l10n.inventoryAuditCounting,
      _AuditState.closed => l10n.inventoryAuditClosed,
    };

AdminPillTone _auditStateTone(_AuditState state) => switch (state) {
  _AuditState.scheduled => AdminPillTone.muted,
  _AuditState.counting => AdminPillTone.primary,
  _AuditState.closed => AdminPillTone.success,
};

String _batchStateLabel(AppLocalizations l10n, _BatchState state) =>
    switch (state) {
      _BatchState.valid => l10n.inventoryBatchValid,
      _BatchState.expiring => l10n.inventoryBatchExpiring,
      _BatchState.expired => l10n.inventoryBatchExpired,
    };

AdminPillTone _batchStateTone(_BatchState state) => switch (state) {
  _BatchState.valid => AdminPillTone.success,
  _BatchState.expiring => AdminPillTone.warning,
  _BatchState.expired => AdminPillTone.primary,
};

String _daysLabel(AppLocalizations l10n, _Batch batch) => batch.daysLeft < 0
    ? l10n.inventoryDaysAgo(-batch.daysLeft)
    : l10n.inventoryDaysLeft(batch.daysLeft);

// ---------------------------------------------------------------------------
// Warehouses
// ---------------------------------------------------------------------------

final class _WarehousesTab extends HookWidget {
  const _WarehousesTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final warehouses = _warehouses(l10n);
    final list = useAdminRecordList<_Warehouse>(
      items: warehouses,
      searchText: (warehouse) => '${warehouse.name} ${warehouse.manager}',
    );

    final products = warehouses.fold<int>(
      0,
      (sum, warehouse) => sum + warehouse.products,
    );
    final units = warehouses.fold<int>(
      0,
      (sum, warehouse) => sum + warehouse.units,
    );
    final capacity = warehouses.fold<int>(
      0,
      (sum, warehouse) => sum + warehouse.capacity,
    );

    return AdminWorkspaceScaffold(
      title: l10n.inventoryTabWarehouses,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.inventorySearchWarehouses,
      metrics: [
        AdminMetric(
          label: l10n.inventoryMetricWarehouses,
          value: adminGroupDigits(warehouses.length),
          icon: LucideIcons.warehouse,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.inventoryMetricProducts,
          value: adminGroupDigits(products),
          icon: LucideIcons.package,
        ),
        AdminMetric(
          label: l10n.inventoryMetricUnitsOnHand,
          value: adminGroupDigits(units),
          icon: LucideIcons.boxes,
        ),
        AdminMetric(
          label: l10n.inventoryMetricCapacityUsed,
          value: adminFormatPercent(capacity == 0 ? 0 : units / capacity),
          icon: LucideIcons.trendingUp,
          tone: AdminPillTone.success,
        ),
      ],
      list: list,
      body: AdminCardGrid(
        children: [
          for (final (index, warehouse) in list.visible.indexed)
            _WarehouseCard(warehouse: warehouse, seed: index),
        ],
      ),
    );
  }
}

final class _WarehouseCard extends StatelessWidget {
  const _WarehouseCard({required this.warehouse, required this.seed});

  final _Warehouse warehouse;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ratio = warehouse.capacity == 0
        ? 0.0
        : warehouse.units / warehouse.capacity;
    final percent = (ratio * 100).round();
    final tone = ratio >= 0.85 ? AdminPillTone.warning : AdminPillTone.success;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AdminProductThumb(
                seed: seed,
                icon: LucideIcons.warehouse,
                size: 38,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warehouse.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      warehouse.manager,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              AdminStatusPill(
                label: l10n.inventoryCapacityUsed(percent),
                tone: tone,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.inventoryCapacityRatio(
                    adminGroupDigits(warehouse.units),
                    adminGroupDigits(warehouse.capacity),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Text(
                adminFormatPercent(ratio),
                style: textTheme.bodySmall?.copyWith(
                  color: adminToneColor(colorScheme, tone),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xSmall),
          AdminMeterBar(value: ratio, color: adminToneColor(colorScheme, tone)),
          const SizedBox(height: AppSpacing.medium),
          Wrap(
            spacing: AppSpacing.large,
            runSpacing: AppSpacing.small,
            children: [
              _WarehouseStat(
                icon: LucideIcons.package,
                label: l10n.inventoryProductsCount(warehouse.products),
              ),
              _WarehouseStat(
                icon: LucideIcons.circleAlert,
                label: l10n.inventoryLowStockItems(warehouse.lowStock),
                tone: warehouse.lowStock > 0 ? AdminPillTone.warning : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _WarehouseStat extends StatelessWidget {
  const _WarehouseStat({required this.icon, required this.label, this.tone});

  final IconData icon;
  final String label;
  final AdminPillTone? tone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = tone == null
        ? colorScheme.onSurfaceVariant
        : adminToneColor(colorScheme, tone!);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppIconSizes.small, color: color),
        const SizedBox(width: AppSpacing.xSmall),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stock balances
// ---------------------------------------------------------------------------

final class _StocksTab extends HookWidget {
  const _StocksTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final rows = _stocks(l10n);
    final warehouses = _warehouses(l10n);
    final selectedWarehouse = useState<String>('');

    final scoped = selectedWarehouse.value.isEmpty
        ? rows
        : rows
              .where((row) => row.warehouseId == selectedWarehouse.value)
              .toList(growable: false);

    final list = useAdminRecordList<_StockRow>(
      items: scoped,
      searchText: (row) =>
          '${row.product} ${row.sku} ${_warehouseName(l10n, row.warehouseId)}',
    );

    final low = rows.where((row) => row.state == _StockState.low).length;
    final out = rows.where((row) => row.state == _StockState.out).length;
    final value = rows.fold<int>(0, (sum, row) => sum + row.value);
    final reorderValue = rows
        .where((row) => row.onHand < row.reorder)
        .fold<int>(
          0,
          (sum, row) => sum + (row.reorder - row.onHand) * row.price,
        );

    return AdminWorkspaceScaffold(
      title: l10n.inventoryTabStocks,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.inventorySearchStocks,
      metrics: [
        AdminMetric(
          label: l10n.inventoryMetricSkus,
          value: adminGroupDigits(rows.length),
          icon: LucideIcons.package,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.inventoryMetricLowStock,
          value: adminGroupDigits(low),
          icon: LucideIcons.circleAlert,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.inventoryMetricOutOfStock,
          value: adminGroupDigits(out),
          icon: LucideIcons.boxes,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.inventoryMetricStockValue,
          value: adminFormatAmount(context, value),
          icon: LucideIcons.banknote,
          tone: AdminPillTone.success,
          hint:
              '${l10n.inventoryMetricReorderValue} '
              '${adminFormatAmount(context, reorderValue)}',
        ),
      ],
      filters: AdminFilterChips<String>(
        options: [
          AdminFilterOption(
            value: '',
            label: l10n.adminFilterAll,
            count: rows.length,
          ),
          for (final warehouse in warehouses)
            AdminFilterOption(
              value: warehouse.id,
              label: warehouse.name,
              count: rows
                  .where((row) => row.warehouseId == warehouse.id)
                  .length,
            ),
        ],
        selected: selectedWarehouse.value,
        onSelected: (value) => selectedWarehouse.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.inventoryColProduct, flex: 3),
          AdminTableColumn(label: l10n.inventoryColSku, hideBelow: 620),
          AdminTableColumn(label: l10n.inventoryColWarehouse, hideBelow: 780),
          AdminTableColumn(label: l10n.inventoryColOnHand, alignEnd: true),
          AdminTableColumn(
            label: l10n.inventoryColReorder,
            alignEnd: true,
            hideBelow: 560,
          ),
          AdminTableColumn(
            label: l10n.inventoryColValue,
            alignEnd: true,
            flex: 2,
            hideBelow: 860,
          ),
          AdminTableColumn(label: l10n.inventoryColState, hideBelow: 480),
        ],
        rows: [
          for (final row in list.visible)
            AdminTableRow(onTap: () => _showSampleAction(context), [
              Text(
                row.product,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              Text(row.sku, style: textTheme.bodySmall),
              Text(
                _warehouseName(l10n, row.warehouseId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(adminGroupDigits(row.onHand), style: textTheme.bodyMedium),
              Text(adminGroupDigits(row.reorder), style: textTheme.bodySmall),
              Text(
                adminFormatAmount(context, row.value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              AdminStatusPill(
                label: _stockStateLabel(l10n, row.state),
                tone: _stockStateTone(row.state),
              ),
            ]),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transfers
// ---------------------------------------------------------------------------

final class _TransfersTab extends HookWidget {
  const _TransfersTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final transfers = _transfers();
    final selectedState = useState<_TransferState?>(null);

    final scoped = selectedState.value == null
        ? transfers
        : transfers
              .where((transfer) => transfer.state == selectedState.value)
              .toList(growable: false);

    final list = useAdminRecordList<_Transfer>(
      items: scoped,
      searchText: (transfer) =>
          '${transfer.reference} ${_warehouseName(l10n, transfer.fromId)} '
          '${_warehouseName(l10n, transfer.toId)}',
    );

    final pending = transfers
        .where((transfer) => transfer.state != _TransferState.received)
        .length;
    final inTransit = transfers
        .where((transfer) => transfer.state == _TransferState.transit)
        .fold<int>(0, (sum, transfer) => sum + transfer.units);
    final received = transfers
        .where((transfer) => transfer.state == _TransferState.received)
        .length;
    final lastDate = transfers.fold<DateTime>(
      transfers.first.date,
      (latest, transfer) =>
          transfer.date.isAfter(latest) ? transfer.date : latest,
    );

    return AdminWorkspaceScaffold(
      title: l10n.inventoryTabTransfers,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.inventorySearchTransfers,
      notice: AdminPlannedNotice(body: l10n.inventoryPlannedTransfersBody),
      metrics: [
        AdminMetric(
          label: l10n.inventoryMetricPendingTransfers,
          value: adminGroupDigits(pending),
          icon: LucideIcons.arrowLeftRight,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.inventoryMetricUnitsInTransit,
          value: adminGroupDigits(inTransit),
          icon: LucideIcons.truck,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.inventoryMetricReceivedTransfers,
          value: adminGroupDigits(received),
          icon: LucideIcons.check,
          tone: AdminPillTone.success,
        ),
        AdminMetric(
          label: l10n.inventoryMetricLastTransfer,
          value: _dateLabel(context, lastDate),
          icon: LucideIcons.calendar,
        ),
      ],
      filters: AdminFilterChips<_TransferState?>(
        options: [
          AdminFilterOption(
            value: null,
            label: l10n.adminFilterAll,
            count: transfers.length,
          ),
          AdminFilterOption(
            value: _TransferState.draft,
            label: l10n.inventoryTransferDraft,
            count: transfers
                .where((transfer) => transfer.state == _TransferState.draft)
                .length,
          ),
          AdminFilterOption(
            value: _TransferState.transit,
            label: l10n.inventoryTransferTransit,
            count: transfers
                .where((transfer) => transfer.state == _TransferState.transit)
                .length,
          ),
          AdminFilterOption(
            value: _TransferState.received,
            label: l10n.inventoryTransferReceived,
            count: transfers
                .where((transfer) => transfer.state == _TransferState.received)
                .length,
          ),
        ],
        selected: selectedState.value,
        onSelected: (value) => selectedState.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.inventoryColTransfer, flex: 2),
          AdminTableColumn(
            label: l10n.inventoryColRoute,
            flex: 3,
            hideBelow: 620,
          ),
          AdminTableColumn(label: l10n.inventoryColUnits, alignEnd: true),
          AdminTableColumn(label: l10n.inventoryColDate, hideBelow: 700),
          AdminTableColumn(label: l10n.inventoryColState),
        ],
        rows: [
          for (final transfer in list.visible)
            AdminTableRow(onTap: () => _showSampleAction(context), [
              Text(transfer.reference, style: textTheme.bodyMedium),
              Text(
                '${_warehouseName(l10n, transfer.fromId)} ← '
                '${_warehouseName(l10n, transfer.toId)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                adminGroupDigits(transfer.units),
                style: textTheme.bodyMedium,
              ),
              Text(
                _dateLabel(context, transfer.date),
                style: textTheme.bodySmall,
              ),
              AdminStatusPill(
                label: _transferStateLabel(l10n, transfer.state),
                tone: _transferStateTone(transfer.state),
              ),
            ]),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stock audits
// ---------------------------------------------------------------------------

final class _AuditsTab extends HookWidget {
  const _AuditsTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final audits = _audits(l10n);
    final selectedState = useState<_AuditState?>(null);

    final scoped = selectedState.value == null
        ? audits
        : audits
              .where((audit) => audit.state == selectedState.value)
              .toList(growable: false);

    final list = useAdminRecordList<_Audit>(
      items: scoped,
      searchText: (audit) =>
          '${audit.reference} ${_warehouseName(l10n, audit.warehouseId)} '
          '${audit.counter}',
    );

    final open = audits
        .where((audit) => audit.state != _AuditState.closed)
        .toList(growable: false);
    final variance = open.fold<int>(0, (sum, audit) => sum + audit.variance);
    final closed = audits.length - open.length;
    final next = audits
        .where((audit) => audit.state != _AuditState.closed)
        .fold<DateTime>(
          audits.first.date,
          (earliest, audit) =>
              audit.date.isBefore(earliest) ? audit.date : earliest,
        );

    return AdminWorkspaceScaffold(
      title: l10n.inventoryTabAudits,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.inventorySearchAudits,
      notice: AdminPlannedNotice(body: l10n.inventoryPlannedAuditsBody),
      metrics: [
        AdminMetric(
          label: l10n.inventoryMetricOpenAudits,
          value: adminGroupDigits(open.length),
          icon: LucideIcons.clipboardCheck,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.inventoryMetricVarianceUnits,
          value: _signed(variance),
          icon: LucideIcons.circleAlert,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.inventoryMetricClosedAudits,
          value: adminGroupDigits(closed),
          icon: LucideIcons.check,
          tone: AdminPillTone.success,
        ),
        AdminMetric(
          label: l10n.inventoryMetricNextAudit,
          value: _dateLabel(context, next),
          icon: LucideIcons.calendarClock,
        ),
      ],
      filters: AdminFilterChips<_AuditState?>(
        options: [
          AdminFilterOption(
            value: null,
            label: l10n.adminFilterAll,
            count: audits.length,
          ),
          for (final state in _AuditState.values)
            AdminFilterOption(
              value: state,
              label: _auditStateLabel(l10n, state),
              count: audits.where((audit) => audit.state == state).length,
            ),
        ],
        selected: selectedState.value,
        onSelected: (value) => selectedState.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.inventoryColAudit, flex: 2),
          AdminTableColumn(label: l10n.inventoryColWarehouse, hideBelow: 620),
          AdminTableColumn(label: l10n.inventoryColCounter, hideBelow: 780),
          AdminTableColumn(label: l10n.inventoryColVariance, alignEnd: true),
          AdminTableColumn(label: l10n.inventoryColDate, hideBelow: 700),
          AdminTableColumn(label: l10n.inventoryColState),
        ],
        rows: [
          for (final audit in list.visible)
            AdminTableRow(onTap: () => _showSampleAction(context), [
              Text(audit.reference, style: textTheme.bodyMedium),
              Text(
                _warehouseName(l10n, audit.warehouseId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                audit.counter,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(_signed(audit.variance), style: textTheme.bodyMedium),
              Text(_dateLabel(context, audit.date), style: textTheme.bodySmall),
              AdminStatusPill(
                label: _auditStateLabel(l10n, audit.state),
                tone: _auditStateTone(audit.state),
              ),
            ]),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Batches and expiry
// ---------------------------------------------------------------------------

final class _BatchesTab extends HookWidget {
  const _BatchesTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final batches = _batches(l10n);
    final selectedState = useState<_BatchState?>(null);

    final scoped = selectedState.value == null
        ? batches
        : batches
              .where((batch) => batch.state == selectedState.value)
              .toList(growable: false);

    final list = useAdminRecordList<_Batch>(
      items: scoped,
      searchText: (batch) =>
          '${batch.code} ${batch.product} '
          '${_warehouseName(l10n, batch.warehouseId)}',
    );

    final expiring = batches
        .where((batch) => batch.state == _BatchState.expiring)
        .length;
    final expired = batches
        .where((batch) => batch.state == _BatchState.expired)
        .length;
    final active = batches.length - expired;
    final value = batches.fold<int>(0, (sum, batch) => sum + batch.value);

    return AdminWorkspaceScaffold(
      title: l10n.inventoryTabBatches,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.inventorySearchBatches,
      metrics: [
        AdminMetric(
          label: l10n.inventoryMetricActiveBatches,
          value: adminGroupDigits(active),
          icon: LucideIcons.layers,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.inventoryMetricExpiringSoon,
          value: adminGroupDigits(expiring),
          icon: LucideIcons.clock,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.inventoryMetricExpiredBatches,
          value: adminGroupDigits(expired),
          icon: LucideIcons.circleAlert,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.inventoryMetricBatchValue,
          value: adminFormatAmount(context, value),
          icon: LucideIcons.banknote,
          tone: AdminPillTone.success,
        ),
      ],
      filters: AdminFilterChips<_BatchState?>(
        options: [
          AdminFilterOption(
            value: null,
            label: l10n.adminFilterAll,
            count: batches.length,
          ),
          for (final state in _BatchState.values)
            AdminFilterOption(
              value: state,
              label: _batchStateLabel(l10n, state),
              count: batches.where((batch) => batch.state == state).length,
            ),
        ],
        selected: selectedState.value,
        onSelected: (value) => selectedState.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.inventoryColBatch, flex: 2),
          AdminTableColumn(
            label: l10n.inventoryColProduct,
            flex: 3,
            hideBelow: 560,
          ),
          AdminTableColumn(label: l10n.inventoryColWarehouse, hideBelow: 780),
          AdminTableColumn(label: l10n.inventoryColQuantity, alignEnd: true),
          AdminTableColumn(label: l10n.inventoryColExpiry, hideBelow: 620),
          AdminTableColumn(
            label: l10n.inventoryColDaysLeft,
            alignEnd: true,
            hideBelow: 700,
          ),
          AdminTableColumn(label: l10n.inventoryColState),
        ],
        rows: [
          for (final batch in list.visible)
            AdminTableRow(onTap: () => _showSampleAction(context), [
              Text(batch.code, style: textTheme.bodyMedium),
              Text(
                batch.product,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                _warehouseName(l10n, batch.warehouseId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                adminGroupDigits(batch.quantity),
                style: textTheme.bodyMedium,
              ),
              Text(
                _dateLabel(context, batch.expiry),
                style: textTheme.bodySmall,
              ),
              Text(_daysLabel(l10n, batch), style: textTheme.bodySmall),
              AdminStatusPill(
                label: _batchStateLabel(l10n, batch.state),
                tone: _batchStateTone(batch.state),
              ),
            ]),
        ],
      ),
    );
  }
}
