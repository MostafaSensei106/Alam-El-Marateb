import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../core/widgets/inputs/text_form_field/text_form_field_component.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';

/// Bespoke catalogue screens.
///
/// The generic section workspace only has room for four short cells, while the
/// catalogue is organised around products, categories, attributes, price lists
/// and a square-metre calculator. Each tab composes the shared detail kit so
/// the tables, filter chips and metric cards stay identical to the other
/// modules while the columns match the catalogue domain.
final class CatalogWorkspace extends StatelessWidget {
  const CatalogWorkspace({required this.section, super.key});

  static const Set<String> sectionIds = {
    'catalog.products',
    'catalog.categories',
    'catalog.attributes',
    'catalog.price-sheets',
    'catalog.meter-pricing',
  };

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) => switch (section.id) {
    'catalog.products' => _ProductsTab(section: section),
    'catalog.categories' => _CategoriesTab(section: section),
    'catalog.attributes' => _AttributesTab(section: section),
    'catalog.price-sheets' => _PriceSheetsTab(section: section),
    'catalog.meter-pricing' => _MeterPricingTab(section: section),
    _ => const SizedBox.shrink(),
  };
}

// ---------------------------------------------------------------------------
// Sample data
// ---------------------------------------------------------------------------

enum _StockState { inStock, low, out }

final class _CatalogProduct {
  const _CatalogProduct({
    required this.name,
    required this.sku,
    required this.categoryId,
    required this.price,
    required this.stock,
  });

  final String name;
  final String sku;
  final String categoryId;
  final int price;
  final int stock;

  _StockState get stockState {
    if (stock <= 0) return _StockState.out;
    if (stock < 10) return _StockState.low;
    return _StockState.inStock;
  }
}

final class _CatalogCategory {
  const _CatalogCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}

final class _CatalogAttribute {
  const _CatalogAttribute({
    required this.name,
    required this.values,
    required this.usage,
    required this.isRequired,
  });

  final String name;
  final List<String> values;
  final int usage;
  final bool isRequired;
}

final class _PriceEntry {
  const _PriceEntry({
    required this.product,
    required this.priceList,
    required this.channel,
    required this.price,
    required this.margin,
  });

  final String product;
  final String priceList;
  final String channel;
  final int price;
  final int margin;
}

List<_CatalogProduct> _catalogProducts(AppLocalizations l10n) => [
  _CatalogProduct(
    name: l10n.product1,
    sku: 'MAT-1601',
    categoryId: 'mattress',
    price: 6450,
    stock: 24,
  ),
  _CatalogProduct(
    name: l10n.product2,
    sku: 'MAT-1802',
    categoryId: 'mattress',
    price: 9250,
    stock: 8,
  ),
  _CatalogProduct(
    name: l10n.product3,
    sku: 'MAT-1503',
    categoryId: 'mattress',
    price: 7800,
    stock: 0,
  ),
  _CatalogProduct(
    name: l10n.product4,
    sku: 'MAT-1204',
    categoryId: 'mattress',
    price: 4500,
    stock: 15,
  ),
  _CatalogProduct(
    name: l10n.product5,
    sku: 'PIL-5070',
    categoryId: 'pillow',
    price: 850,
    stock: 42,
  ),
  _CatalogProduct(
    name: l10n.product6,
    sku: 'PIL-MEM',
    categoryId: 'pillow',
    price: 690,
    stock: 6,
  ),
  _CatalogProduct(
    name: l10n.product7,
    sku: 'BAS-1601',
    categoryId: 'base',
    price: 5300,
    stock: 11,
  ),
  _CatalogProduct(
    name: l10n.product8,
    sku: 'BAS-1802',
    categoryId: 'base',
    price: 6800,
    stock: 4,
  ),
  _CatalogProduct(
    name: l10n.product9,
    sku: 'ACC-PRO',
    categoryId: 'accessory',
    price: 1200,
    stock: 60,
  ),
  _CatalogProduct(
    name: l10n.product10,
    sku: 'ACC-SHE',
    categoryId: 'accessory',
    price: 950,
    stock: 0,
  ),
  _CatalogProduct(
    name: l10n.product11,
    sku: 'MAT-OVAL',
    categoryId: 'mattress',
    price: 12500,
    stock: 3,
  ),
  _CatalogProduct(
    name: l10n.product12,
    sku: 'MAT-HTL',
    categoryId: 'mattress',
    price: 11200,
    stock: 18,
  ),
];

List<_CatalogCategory> _catalogCategories(AppLocalizations l10n) => [
  _CatalogCategory(
    id: 'mattress',
    name: l10n.categoryMattress,
    icon: LucideIcons.package,
  ),
  _CatalogCategory(
    id: 'pillow',
    name: l10n.categoryPillow,
    icon: LucideIcons.layers,
  ),
  _CatalogCategory(
    id: 'base',
    name: l10n.categoryBase,
    icon: LucideIcons.boxes,
  ),
  _CatalogCategory(
    id: 'accessory',
    name: l10n.categoryAccessory,
    icon: LucideIcons.tag,
  ),
];

List<_CatalogAttribute> _catalogAttributes(AppLocalizations l10n) => [
  _CatalogAttribute(
    name: l10n.catalogAttributeSize,
    values: [
      l10n.catalogValueSize1,
      l10n.catalogValueSize2,
      l10n.catalogValueSize3,
    ],
    usage: 6,
    isRequired: true,
  ),
  _CatalogAttribute(
    name: l10n.catalogAttributeColor,
    values: [
      l10n.catalogValueColor1,
      l10n.catalogValueColor2,
      l10n.catalogValueColor3,
    ],
    usage: 5,
    isRequired: true,
  ),
  _CatalogAttribute(
    name: l10n.catalogAttributeMaterial,
    values: [
      l10n.catalogValueMaterial1,
      l10n.catalogValueMaterial2,
      l10n.catalogValueMaterial3,
    ],
    usage: 8,
    isRequired: true,
  ),
  _CatalogAttribute(
    name: l10n.catalogAttributeFirmness,
    values: [
      l10n.catalogValueFirmness1,
      l10n.catalogValueFirmness2,
      l10n.catalogValueFirmness3,
    ],
    usage: 4,
    isRequired: false,
  ),
  _CatalogAttribute(
    name: l10n.catalogAttributeWarranty,
    values: [l10n.catalogValueWarranty1, l10n.catalogValueWarranty2],
    usage: 12,
    isRequired: false,
  ),
];

List<_PriceEntry> _priceEntries(AppLocalizations l10n) => [
  _PriceEntry(
    product: l10n.product1,
    priceList: l10n.catalogPriceListRetail,
    channel: l10n.catalogChannelShowroom,
    price: 6450,
    margin: 22,
  ),
  _PriceEntry(
    product: l10n.product2,
    priceList: l10n.catalogPriceListRetail,
    channel: l10n.catalogChannelShowroom,
    price: 9250,
    margin: 24,
  ),
  _PriceEntry(
    product: l10n.product1,
    priceList: l10n.catalogPriceListWholesale,
    channel: l10n.catalogChannelWholesale,
    price: 5600,
    margin: 12,
  ),
  _PriceEntry(
    product: l10n.product3,
    priceList: l10n.catalogPriceListOnline,
    channel: l10n.catalogChannelWeb,
    price: 8100,
    margin: 18,
  ),
  _PriceEntry(
    product: l10n.product5,
    priceList: l10n.catalogPriceListOnline,
    channel: l10n.catalogChannelWeb,
    price: 890,
    margin: 15,
  ),
  _PriceEntry(
    product: l10n.product7,
    priceList: l10n.catalogPriceListWholesale,
    channel: l10n.catalogChannelWholesale,
    price: 4700,
    margin: 10,
  ),
  _PriceEntry(
    product: l10n.product11,
    priceList: l10n.catalogPriceListRetail,
    channel: l10n.catalogChannelShowroom,
    price: 12500,
    margin: 26,
  ),
  _PriceEntry(
    product: l10n.product12,
    priceList: l10n.catalogPriceListWholesale,
    channel: l10n.catalogChannelWholesale,
    price: 9400,
    margin: 14,
  ),
  _PriceEntry(
    product: l10n.product9,
    priceList: l10n.catalogPriceListOnline,
    channel: l10n.catalogChannelWeb,
    price: 1290,
    margin: 20,
  ),
];

String _categoryLabel(AppLocalizations l10n, String categoryId) =>
    switch (categoryId) {
      'mattress' => l10n.categoryMattress,
      'pillow' => l10n.categoryPillow,
      'base' => l10n.categoryBase,
      'accessory' => l10n.categoryAccessory,
      _ => categoryId,
    };

String _stockLabel(AppLocalizations l10n, _StockState state) =>
    switch (state) {
      _StockState.inStock => l10n.catalogStockIn,
      _StockState.low => l10n.catalogStockLow,
      _StockState.out => l10n.catalogStockOut,
    };

AdminPillTone _stockTone(_StockState state) => switch (state) {
  _StockState.inStock => AdminPillTone.success,
  _StockState.low || _StockState.out => AdminPillTone.warning,
};

void _showSampleAction(BuildContext context) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger.showSnackBar(
    SnackBar(content: Text(context.localeKeys.adminSampleActionMessage)),
  );
}

// ---------------------------------------------------------------------------
// Products
// ---------------------------------------------------------------------------

final class _ProductsTab extends HookWidget {
  const _ProductsTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final products = _catalogProducts(l10n);
    final selectedCategory = useState<String>('');

    final scoped = selectedCategory.value.isEmpty
        ? products
        : products
              .where((product) => product.categoryId == selectedCategory.value)
              .toList(growable: false);

    final list = useAdminRecordList<_CatalogProduct>(
      items: scoped,
      searchText: (product) =>
          '${product.name} ${product.sku} ${_categoryLabel(l10n, product.categoryId)}',
    );

    final lowStock = products
        .where((product) => product.stockState == _StockState.low)
        .length;
    final averagePrice = products.isEmpty
        ? 0
        : products.fold<int>(0, (sum, product) => sum + product.price) ~/
              products.length;
    final stockValue = products.fold<int>(
      0,
      (sum, product) => sum + product.price * product.stock,
    );

    final categoryOptions = [
      AdminFilterOption(
        value: '',
        label: l10n.adminFilterAll,
        count: products.length,
      ),
      for (final category in _catalogCategories(l10n))
        AdminFilterOption(
          value: category.id,
          label: category.name,
          count: products
              .where((product) => product.categoryId == category.id)
              .length,
        ),
    ];

    return AdminWorkspaceScaffold(
      title: l10n.catalogTabProducts,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.catalogSearchProducts,
      metrics: [
        AdminMetric(
          label: l10n.catalogMetricProducts,
          value: adminGroupDigits(products.length),
          icon: LucideIcons.package,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.catalogMetricLowStock,
          value: adminGroupDigits(lowStock),
          icon: LucideIcons.circleAlert,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.catalogMetricAveragePrice,
          value: adminFormatAmount(context, averagePrice),
          icon: LucideIcons.tag,
        ),
        AdminMetric(
          label: l10n.catalogMetricStockValue,
          value: adminFormatAmount(context, stockValue),
          icon: LucideIcons.boxes,
          tone: AdminPillTone.success,
        ),
      ],
      filters: AdminFilterChips<String>(
        options: categoryOptions,
        selected: selectedCategory.value,
        onSelected: (value) => selectedCategory.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.catalogColProduct, flex: 3),
          AdminTableColumn(
            label: l10n.catalogColSku,
            hideBelow: 620,
          ),
          AdminTableColumn(
            label: l10n.catalogColCategory,
            hideBelow: 780,
          ),
          AdminTableColumn(
            label: l10n.catalogColPrice,
            alignEnd: true,
            flex: 2,
          ),
          AdminTableColumn(
            label: l10n.catalogColStock,
            alignEnd: true,
            hideBelow: 420,
          ),
          AdminTableColumn(
            label: l10n.formFieldStatus,
            hideBelow: 560,
          ),
        ],
        rows: [
          for (final (index, product) in list.visible.indexed)
            AdminTableRow(
              onTap: () => _showSampleAction(context),
              [
                Row(
                  children: [
                    AdminProductThumb(seed: index, size: 34),
                    const SizedBox(width: AppSpacing.small),
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                Text(
                  product.sku,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  _categoryLabel(l10n, product.categoryId),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
                Text(
                  adminFormatAmount(context, product.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                Text(
                  adminGroupDigits(product.stock),
                  style: textTheme.bodyMedium?.copyWith(
                    color: adminToneColor(
                      colorScheme,
                      _stockTone(product.stockState),
                    ),
                  ),
                ),
                AdminStatusPill(
                  label: _stockLabel(l10n, product.stockState),
                  tone: _stockTone(product.stockState),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Categories
// ---------------------------------------------------------------------------

final class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final products = _catalogProducts(l10n);
    final categories = _catalogCategories(l10n);
    final topCategory = categories.reduce(
      (current, next) =>
          products.where((product) => product.categoryId == next.id).length >
              products
                  .where((product) => product.categoryId == current.id)
                  .length
          ? next
          : current,
    );

    return AdminWorkspaceScaffold(
      title: l10n.catalogTabCategories,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      metrics: [
        AdminMetric(
          label: l10n.catalogMetricCategories,
          value: adminGroupDigits(categories.length),
          icon: LucideIcons.layers,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.catalogMetricCategoryProducts,
          value: adminGroupDigits(products.length),
          icon: LucideIcons.package,
        ),
        AdminMetric(
          label: l10n.catalogMetricTopCategory,
          value: topCategory.name,
          hint: l10n.catalogCategoryProductsCount(
            products
                .where((product) => product.categoryId == topCategory.id)
                .length,
          ),
          icon: LucideIcons.tag,
          tone: AdminPillTone.success,
        ),
      ],
      body: AdminCardGrid(
        children: [
          for (final category in categories)
            AdminSurfaceCard(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AdminProductThumb(
                        seed: category.id.length,
                        icon: category.icon,
                        size: 36,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: Text(
                          category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    l10n.catalogCategoryProductsCount(
                      products
                          .where(
                            (product) => product.categoryId == category.id,
                          )
                          .length,
                    ),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  AdminMeterBar(
                    value:
                        products
                            .where(
                              (product) => product.categoryId == category.id,
                            )
                            .length /
                        products.length,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.catalogCategoryShareLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        adminFormatPercent(
                          products
                                  .where(
                                    (product) =>
                                        product.categoryId == category.id,
                                  )
                                  .length /
                              products.length *
                              100,
                        ),
                        style: textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Attributes
// ---------------------------------------------------------------------------

enum _RequirementFilter { all, required, optional }

final class _AttributesTab extends HookWidget {
  const _AttributesTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final attributes = _catalogAttributes(l10n);
    final selected = useState(_RequirementFilter.all);

    final scoped = switch (selected.value) {
      _RequirementFilter.all => attributes,
      _RequirementFilter.required => attributes
          .where((attribute) => attribute.isRequired)
          .toList(growable: false),
      _RequirementFilter.optional => attributes
          .where((attribute) => !attribute.isRequired)
          .toList(growable: false),
    };

    final list = useAdminRecordList<_CatalogAttribute>(
      items: scoped,
      searchText: (attribute) =>
          '${attribute.name} ${attribute.values.join(' ')}',
    );

    final valueCount = attributes.fold<int>(
      0,
      (sum, attribute) => sum + attribute.values.length,
    );
    final requiredCount = attributes
        .where((attribute) => attribute.isRequired)
        .length;

    return AdminWorkspaceScaffold(
      title: l10n.catalogTabAttributes,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.catalogSearchAttributes,
      metrics: [
        AdminMetric(
          label: l10n.catalogMetricAttributes,
          value: adminGroupDigits(attributes.length),
          icon: LucideIcons.tag,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.catalogMetricValues,
          value: adminGroupDigits(valueCount),
          icon: LucideIcons.list,
        ),
        AdminMetric(
          label: l10n.catalogMetricRequired,
          value: adminGroupDigits(requiredCount),
          icon: LucideIcons.check,
          tone: AdminPillTone.success,
        ),
      ],
      filters: AdminFilterChips<_RequirementFilter>(
        options: [
          AdminFilterOption(
            value: _RequirementFilter.all,
            label: l10n.adminFilterAll,
            count: attributes.length,
          ),
          AdminFilterOption(
            value: _RequirementFilter.required,
            label: l10n.catalogRequired,
            count: requiredCount,
          ),
          AdminFilterOption(
            value: _RequirementFilter.optional,
            label: l10n.catalogOptional,
            count: attributes.length - requiredCount,
          ),
        ],
        selected: selected.value,
        onSelected: (value) => selected.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.catalogColProduct, flex: 2),
          AdminTableColumn(label: l10n.catalogColValues, flex: 4),
          AdminTableColumn(
            label: l10n.catalogColUsage,
            alignEnd: true,
            hideBelow: 520,
          ),
          AdminTableColumn(
            label: l10n.catalogColRequirement,
            hideBelow: 640,
          ),
        ],
        rows: [
          for (final attribute in list.visible)
            AdminTableRow(
              onTap: () => _showSampleAction(context),
              [
                Text(
                  attribute.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                Wrap(
                  spacing: AppSpacing.xSmall,
                  runSpacing: AppSpacing.xSmall,
                  children: [
                    for (final value in attribute.values)
                      AdminStatusPill(label: value),
                  ],
                ),
                Text(
                  adminGroupDigits(attribute.usage),
                  style: textTheme.bodyMedium,
                ),
                AdminStatusPill(
                  label: attribute.isRequired
                      ? l10n.catalogRequired
                      : l10n.catalogOptional,
                  tone: attribute.isRequired
                      ? AdminPillTone.primary
                      : AdminPillTone.muted,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Price sheets
// ---------------------------------------------------------------------------

final class _PriceSheetsTab extends HookWidget {
  const _PriceSheetsTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final entries = _priceEntries(l10n);
    final selectedList = useState<String>('');

    final priceLists = <String>[
      l10n.catalogPriceListRetail,
      l10n.catalogPriceListWholesale,
      l10n.catalogPriceListOnline,
    ];
    final channels = entries.map((entry) => entry.channel).toSet().toList();

    final scoped = selectedList.value.isEmpty
        ? entries
        : entries
              .where((entry) => entry.priceList == selectedList.value)
              .toList(growable: false);

    final list = useAdminRecordList<_PriceEntry>(
      items: scoped,
      searchText: (entry) =>
          '${entry.product} ${entry.priceList} ${entry.channel}',
    );

    final averageMargin = entries.fold<int>(
      0,
      (sum, entry) => sum + entry.margin,
    );

    return AdminWorkspaceScaffold(
      title: l10n.catalogTabPrices,
      icon: section.icon,
      sectionId: section.id,
      onCreate: () => _showSampleAction(context),
      searchHint: l10n.catalogSearchPrices,
      metrics: [
        AdminMetric(
          label: l10n.catalogMetricPriceLists,
          value: adminGroupDigits(priceLists.length),
          icon: LucideIcons.list,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.catalogMetricChannels,
          value: adminGroupDigits(channels.length),
          icon: LucideIcons.store,
        ),
        AdminMetric(
          label: l10n.catalogMetricAverageMargin,
          value: adminFormatPercent(averageMargin / entries.length),
          icon: LucideIcons.percent,
          tone: AdminPillTone.success,
        ),
        AdminMetric(
          label: l10n.catalogMetricEntries,
          value: adminGroupDigits(entries.length),
          icon: LucideIcons.tag,
        ),
      ],
      filters: AdminFilterChips<String>(
        options: [
          AdminFilterOption(
            value: '',
            label: l10n.adminFilterAll,
            count: entries.length,
          ),
          for (final priceList in priceLists)
            AdminFilterOption(
              value: priceList,
              label: priceList,
              count: entries
                  .where((entry) => entry.priceList == priceList)
                  .length,
            ),
        ],
        selected: selectedList.value,
        onSelected: (value) => selectedList.value = value,
      ),
      list: list,
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.catalogColProduct, flex: 3),
          AdminTableColumn(label: l10n.catalogColPriceList),
          AdminTableColumn(
            label: l10n.catalogColChannel,
            hideBelow: 680,
          ),
          AdminTableColumn(
            label: l10n.catalogColPrice,
            alignEnd: true,
            flex: 2,
          ),
          AdminTableColumn(
            label: l10n.catalogColMargin,
            alignEnd: true,
            hideBelow: 780,
          ),
        ],
        rows: [
          for (final entry in list.visible)
            AdminTableRow(
              onTap: () => _showSampleAction(context),
              [
                Text(
                  entry.product,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                AdminStatusPill(label: entry.priceList),
                Text(
                  entry.channel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
                Text(
                  adminFormatAmount(context, entry.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                Text(
                  adminFormatPercent(entry.margin.toDouble()),
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Meter pricing
// ---------------------------------------------------------------------------

enum _MeterShape { rectangle, round, lShape }

final class _MeterPricingTab extends HookWidget {
  const _MeterPricingTab({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final shape = useState(_MeterShape.rectangle);
    final width = useTextEditingController(text: '160');
    final height = useTextEditingController(text: '200');
    final rate = useTextEditingController(text: '950');
    final waste = useTextEditingController(text: '5');

    final widthValue = double.tryParse(useValueListenable(width).text.trim());
    final heightValue = double.tryParse(useValueListenable(height).text.trim());
    final rateValue = double.tryParse(useValueListenable(rate).text.trim());
    final wasteValue =
        double.tryParse(useValueListenable(waste).text.trim()) ?? 0;

    final valid =
        widthValue != null &&
        widthValue > 0 &&
        heightValue != null &&
        heightValue > 0 &&
        rateValue != null &&
        rateValue > 0 &&
        wasteValue >= 0;

    final area = valid
        ? widthValue * heightValue / 10000 * _shapeFactor(shape.value)
        : 0.0;
    final basePrice = valid ? area * rateValue : 0.0;
    final wasteCost = valid ? basePrice * wasteValue / 100 : 0.0;

    final form = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeading(
            title: l10n.catalogMeterDimensions,
            icon: LucideIcons.shapes,
          ),
          const SizedBox(height: AppSpacing.medium),
          AdminFilterChips<_MeterShape>(
            options: [
              for (final option in _MeterShape.values)
                AdminFilterOption(
                  value: option,
                  label: switch (option) {
                    _MeterShape.rectangle => l10n.catalogShapeRectangle,
                    _MeterShape.round => l10n.catalogShapeRound,
                    _MeterShape.lShape => l10n.catalogShapeLShape,
                  },
                ),
            ],
            selected: shape.value,
            onSelected: (value) => shape.value = value,
          ),
          const SizedBox(height: AppSpacing.medium),
          _FieldRow(
            children: [
              _MeterField(
                controller: width,
                label: l10n.catalogMeterWidth,
              ),
              _MeterField(
                controller: height,
                label: l10n.catalogMeterHeight,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xLarge),
          AdminSectionHeading(
            title: l10n.catalogMeterPricing,
            icon: LucideIcons.calculator,
          ),
          const SizedBox(height: AppSpacing.medium),
          _FieldRow(
            children: [
              _MeterField(
                controller: rate,
                label: l10n.catalogMeterRate,
              ),
              _MeterField(
                controller: waste,
                label: l10n.catalogMeterWaste,
              ),
            ],
          ),
        ],
      ),
    );

    final estimate = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeading(
            title: l10n.catalogMeterSummary,
            subtitle: l10n.catalogMeterHint,
            icon: LucideIcons.calculator,
          ),
          const SizedBox(height: AppSpacing.medium),
          if (!valid)
            Text(
              l10n.catalogMeterInvalid,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            )
          else ...[
            _EstimateRow(
              label: l10n.catalogMeterArea,
              value:
                  '${area.toStringAsFixed(2)} ${l10n.catalogMeterUnit}',
            ),
            _EstimateRow(
              label: l10n.catalogMeterBasePrice,
              value: adminFormatAmount(context, basePrice),
            ),
            _EstimateRow(
              label: l10n.catalogMeterWasteCost,
              value: adminFormatAmount(context, wasteCost),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              l10n.catalogMeterTotal,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xSmall),
            Text(
              adminFormatAmount(context, basePrice + wasteCost),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );

    return AdminWorkspaceScaffold(
      title: l10n.catalogTabMeter,
      icon: section.icon,
      sectionId: section.id,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 880) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                form,
                const SizedBox(height: AppSpacing.medium),
                estimate,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: form),
              const SizedBox(width: AppSpacing.medium),
              Expanded(flex: 2, child: estimate),
            ],
          );
        },
      ),
    );
  }
}

double _shapeFactor(_MeterShape shape) => switch (shape) {
  _MeterShape.rectangle => 1,
  _MeterShape.round => math.pi / 4,
  _MeterShape.lShape => 1.15,
};

final class _MeterField extends StatelessWidget {
  const _MeterField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) => TextFormFieldComponent(
    controller: controller,
    label: label,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ],
  );
}

final class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 420) {
        return Column(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(height: AppSpacing.small),
              children[index],
            ],
          ],
        );
      }

      return Row(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.small),
            Expanded(child: children[index]),
          ],
        ],
      );
    },
  );
}

final class _EstimateRow extends StatelessWidget {
  const _EstimateRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xSmall),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Text(value, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
