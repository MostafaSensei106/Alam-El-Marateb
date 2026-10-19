import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaisel/kaisel.dart';

import '../../core/extensions/extensions.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/cache/app_cache_config.dart';
import '../../core/utils/cache/offline_cache_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OfflineCacheProvider(
      providers: AppCacheConfig.prefetchProviders,
      child: KaiselBranchedShell.specs(
        branches: [
          KaiselBranchSpec<DashboardRoute>(
            initial: const DashboardRoot(),
            builder: (context, route) => switch (route) {
              DashboardRoot() => const _AdminSectionPage(
                title: 'Analytics & Dashboard',
                description: 'مؤشرات الأداء والتحليلات الإدارية',
                features: [
                  'ملخص المبيعات والإيرادات والأرباح',
                  'مقارنة أداء الفروع',
                  'الخريطة الحرارية للمبيعات والطلبات',
                  'المنتجات الأكثر مبيعًا وسرعة حركتها',
                  'تحليل العملاء RFM',
                ],
              ),
            },
          ),
          KaiselBranchSpec<IdentityRoute>(
            initial: const IdentityRoot(),
            builder: (context, route) => switch (route) {
              IdentityRoot() => const _AdminSectionPage(
                title: 'Identity & Access',
                description: 'الفروع والمستخدمون والصلاحيات',
                features: [
                  'إدارة الفروع والمعارض',
                  'المستخدمون والأدوار والصلاحيات',
                  'أسطول السيارات وسعات التحميل',
                ],
              ),
            },
          ),
          KaiselBranchSpec<CatalogRoute>(
            initial: const CatalogRoot(),
            builder: (context, route) => switch (route) {
              CatalogRoot() => const _AdminSectionPage(
                title: 'Catalog Management',
                description: 'المنتجات والكتالوج والتسعير',
                features: [
                  'المنتجات والصور والترجمات والمواصفات',
                  'التصنيفات والعلامات التجارية',
                  'الخصائص والسمات والخيارات',
                  'قوائم الأسعار وأسعار قنوات البيع',
                  'تسعير المتر المربع والأشكال الخاصة',
                ],
              ),
            },
          ),
          KaiselBranchSpec<InventoryRoute>(
            initial: const InventoryRoot(),
            builder: (context, route) => switch (route) {
              InventoryRoot() => const _AdminSectionPage(
                title: 'Inventory & Warehouse',
                description: 'المخازن وحركة المخزون والتكلفة',
                features: [
                  'إدارة المخازن',
                  'أرصدة المخزون وتنبيهات النواقص',
                  'التحويلات بين المخازن',
                  'الجرد والتسويات المخزنية',
                  'الدفعات وتقييم المخزون FIFO',
                ],
              ),
            },
          ),
          KaiselBranchSpec<SalesRoute>(
            initial: const SalesRoot(),
            builder: (context, route) => switch (route) {
              SalesRoot() => const _AdminSectionPage(
                title: 'Sales & POS',
                description: 'المبيعات ونقطة البيع والطلبات',
                features: [
                  'نقطة البيع والباركود والخصومات',
                  'طرق الدفع: نقدي وبطاقة وآجل',
                  'فتح الورديات وتسليم النقدية وإغلاقها',
                  'الطلبات والمرتجعات والإلغاءات',
                  'الطلبات الخاصة والحجوزات والعربون',
                  'العروض الترويجية والكوبونات',
                ],
              ),
            },
          ),
          KaiselBranchSpec<PurchasingRoute>(
            initial: const PurchasingRoot(),
            builder: (context, route) => switch (route) {
              PurchasingRoot() => const _AdminSectionPage(
                title: 'Purchasing',
                description: 'الموردون وأوامر الشراء والتكاليف',
                features: [
                  'الموردون وكشوف الحسابات',
                  'أوامر الشراء واستلام البضاعة',
                  'الشحنات والجمارك والتكاليف الإضافية',
                  'فواتير الموردين والأقساط والمدفوعات',
                ],
              ),
            },
          ),
          KaiselBranchSpec<CrmRoute>(
            initial: const CrmRoot(),
            builder: (context, route) => switch (route) {
              CrmRoot() => const _AdminSectionPage(
                title: 'Customer Relations',
                description: 'العملاء والضمان والشكاوى',
                features: [
                  'سجل الضمانات',
                  'مطالبات العملاء والمعاينات والإصلاح',
                  'مراجعة تقييمات العملاء',
                  'الاستفسارات وأسئلة المنتجات',
                ],
              ),
            },
          ),
          KaiselBranchSpec<DeliveryRoute>(
            initial: const DeliveryRoot(),
            builder: (context, route) => switch (route) {
              DeliveryRoot() => const _AdminSectionPage(
                title: 'Delivery',
                description: 'الرحلات والسائقون وتتبع التوصيل',
                features: [
                  'إنشاء رحلات الشحن وتجميع الطلبات',
                  'تعيين السائق والسيارة',
                  'تحسين خطوط السير',
                  'التتبع المباشر ونقاط التوقف',
                  'إثبات التسليم بالصور أو التوقيع',
                ],
              ),
            },
          ),
          KaiselBranchSpec<HrRoute>(
            initial: const HrRoot(),
            builder: (context, route) => switch (route) {
              HrRoot() => const _AdminSectionPage(
                title: 'Human Resources',
                description: 'الموظفون والإجازات والرواتب',
                features: [
                  'سجل الموظفين والبيانات الوظيفية',
                  'طلبات الإجازات',
                  'مسيرات الرواتب والتصدير إلى Excel',
                  'العمولات والسلف والخصومات',
                ],
              ),
            },
          ),
          KaiselBranchSpec<AccountingRoute>(
            initial: const AccountingRoot(),
            builder: (context, route) => switch (route) {
              AccountingRoot() => const _AdminSectionPage(
                title: 'Accounting & Finance',
                description: 'الحسابات والخزائن والتقارير المالية',
                features: [
                  'شجرة الحسابات',
                  'قيود اليومية ودفتر الأستاذ',
                  'الخزائن والبنوك والتحويلات المالية',
                  'المصروفات والشيكات',
                  'قائمة الدخل والميزانية والتقارير الضريبية',
                ],
              ),
            },
          ),
          KaiselBranchSpec<MarketingRoute>(
            initial: const MarketingRoot(),
            builder: (context, route) => switch (route) {
              MarketingRoot() => const _AdminSectionPage(
                title: 'Marketing',
                description: 'الحملات الترويجية',
                features: ['حملات عجلة الحظ', 'إدارة الجوائز وتفعيل الحملات'],
              ),
            },
          ),
          KaiselBranchSpec<AdminProfileRoute>(
            initial: const AdminProfileRoot(),
            builder: (context, route) => switch (route) {
              AdminProfileRoot() => const _AdminSectionPage(
                title: 'Admin Profile',
                description: 'الملف الشخصي للمدير',
                features: [
                  'بيانات الحساب الشخصي',
                  'تعديل الاسم وبيانات التواصل',
                  'تغيير كلمة المرور',
                  'مراجعة دور المستخدم وصلاحياته',
                ],
              ),
            },
          ),
          KaiselBranchSpec<AdminSettingsRoute>(
            initial: const AdminSettingsRoot(),
            builder: (context, route) => switch (route) {
              AdminSettingsRoot() => const _AdminSectionPage(
                title: 'Settings',
                description: 'إعدادات النظام والتطبيق',
                features: [
                  'اللغة والمظهر',
                  'إعدادات الإشعارات',
                  'إعدادات النظام العامة',
                ],
              ),
            },
          ),
        ],
        chromeBuilder: (context, active, branchContent, switchBranch) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: SingleChildScrollView(
                      child: NavigationRail(
                        selectedIndex: active,
                        labelType: NavigationRailLabelType.all,
                        groupAlignment: -1,
                        backgroundColor: theme.colorScheme.surface,
                        indicatorColor: theme.colorScheme.secondaryContainer,
                        onDestinationSelected: (index) {
                          unawaited(HapticFeedback.lightImpact());
                          switchBranch(index);
                        },
                        destinations: _destinations
                            .map(
                              (item) => NavigationRailDestination(
                                icon: Icon(item.icon),
                                selectedIcon: Icon(item.selectedIcon),
                                label: Text(item.label),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: context.colorScheme.outlineVariant,
                  ),
                  Expanded(child: branchContent),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RailDestination {
  const _RailDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _destinations = <_RailDestination>[
  _RailDestination(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
  ),
  _RailDestination(
    label: 'Identity',
    icon: Icons.admin_panel_settings_outlined,
    selectedIcon: Icons.admin_panel_settings,
  ),
  _RailDestination(
    label: 'Catalog',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
  ),
  _RailDestination(
    label: 'Inventory',
    icon: Icons.warehouse_outlined,
    selectedIcon: Icons.warehouse,
  ),
  _RailDestination(
    label: 'Sales',
    icon: Icons.point_of_sale_outlined,
    selectedIcon: Icons.point_of_sale,
  ),
  _RailDestination(
    label: 'Purchasing',
    icon: Icons.shopping_bag_outlined,
    selectedIcon: Icons.shopping_bag,
  ),
  _RailDestination(
    label: 'CRM',
    icon: Icons.support_agent_outlined,
    selectedIcon: Icons.support_agent,
  ),
  _RailDestination(
    label: 'Delivery',
    icon: Icons.local_shipping_outlined,
    selectedIcon: Icons.local_shipping,
  ),
  _RailDestination(
    label: 'HR',
    icon: Icons.groups_outlined,
    selectedIcon: Icons.groups,
  ),
  _RailDestination(
    label: 'Accounting',
    icon: Icons.account_balance_outlined,
    selectedIcon: Icons.account_balance,
  ),
  _RailDestination(
    label: 'Marketing',
    icon: Icons.campaign_outlined,
    selectedIcon: Icons.campaign,
  ),
  _RailDestination(
    label: 'Profile',
    icon: Icons.account_circle_outlined,
    selectedIcon: Icons.account_circle,
  ),
  _RailDestination(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];

class _AdminSectionPage extends StatelessWidget {
  const _AdminSectionPage({
    required this.title,
    required this.description,
    required this.features,
  });

  final String title;
  final String description;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        ...features.map(
          (feature) => Card(
            child: ListTile(
              leading: const Icon(Icons.arrow_forward_ios, size: 16),
              title: Text(feature),
              subtitle: const Text('سيتم إضافة الشاشة لاحقًا'),
            ),
          ),
        ),
      ],
    );
  }
}
