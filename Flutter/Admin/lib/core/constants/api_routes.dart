/// HTTP routes exposed by the Alamelmarateb ERP backend.
///
/// This file only contains endpoints used by the Admin backoffice app.
/// Customer storefront (`/catalog/public/**`), shop checkout (`/shop/**`),
/// and self-service portal (`/portal/**`) routes are intentionally excluded,
/// along with public-only actions such as registration, analytics event
/// ingestion, and customer quote/spin plays.
///
/// Every constant is a full URL pointing at the local backend
/// (`http://localhost:8080`) and follows the `/api/v1` prefix.
///
/// Dynamic segments are written as `{param}` placeholders:
///
/// ```dart
/// final url = ApiRoutes.withPathParams(
///   ApiRoutes.catalogProductById,
///   {'productId': productId},
/// );
/// ```
///
/// Query parameters are documented per route but intentionally left out of
/// the constants; pass them through `RequestOptions.queryParameters`.
///
/// Every `/api` request needs `X-Api-Client` and `X-Api-Key` headers
/// (see `ApiHeader`), and authenticated routes need a Bearer token.
final class ApiRoutes {
  ApiRoutes._();

  /// Backend origin used for local development.
  static const String apiBaseURL = 'http://192.168.1.16:8080';

  /// Versioned API prefix as a full URL.
  static const String apiV1 = '$apiBaseURL/api/v1';

  /// Versioned API prefix as a path, useful when matching request paths.
  static const String apiV1Path = '/api/v1';

  // ─────────────────────────────── Auth ───────────────────────────────

  static const String authLogin = '$apiV1/auth/login';

  /// Path-only login route, used to skip the 401 refresh flow.
  static const String authLoginPath = '$apiV1Path/auth/login';

  static const String authRefresh = '$apiV1/auth/refresh';
  static const String authMe = '$apiV1/auth/me';
  static const String authForgotPassword = '$apiV1/auth/forgot-password';
  static const String authResetPassword = '$apiV1/auth/reset-password';
  static const String authChangePassword = '$apiV1/auth/change-password';

  // ────────────────────────── Catalog management ──────────────────────

  static const String catalogCategories = '$apiV1/catalog/categories';
  static const String catalogCategoryCreate = '$apiV1/catalog/categories';
  static const String catalogCategoryById =
      '$apiV1/catalog/categories/{categoryId}';
  static const String catalogCategoryUpdate =
      '$apiV1/catalog/categories/{categoryId}';
  static const String catalogCategoryPatch =
      '$apiV1/catalog/categories/{categoryId}';
  static const String catalogCategoryDelete =
      '$apiV1/catalog/categories/{categoryId}';
  static const String catalogCategoryAttributesBind =
      '$apiV1/catalog/categories/{categoryId}/attributes';

  static const String catalogProducts = '$apiV1/catalog/products';
  static const String catalogProductCreate = '$apiV1/catalog/products';
  static const String catalogProductQuickCreate =
      '$apiV1/catalog/products/quick-create';
  static const String catalogProductById =
      '$apiV1/catalog/products/{productId}';
  static const String catalogProductUpdate =
      '$apiV1/catalog/products/{productId}';
  static const String catalogProductDelete =
      '$apiV1/catalog/products/{productId}';
  static const String catalogProductImagesUpload =
      '$apiV1/catalog/products/{productId}/images';
  static const String catalogProductFromPreset =
      '$apiV1/catalog/products/from-preset/{presetId}';
  static const String catalogProductQaAnswer =
      '$apiV1/catalog/products/qa/{questionId}/answer';
  static const String catalogProductsSearchReindex =
      '$apiV1/catalog/products/search/reindex';

  static const String catalogProductMeterPrices =
      '$apiV1/catalog/products/{productId}/meter-prices';
  static const String catalogProductMeterPriceCreate =
      '$apiV1/catalog/products/{productId}/meter-prices';
  static const String catalogMeterPriceDelete =
      '$apiV1/catalog/meter-prices/{meterPriceId}';

  static const String catalogImageDelete = '$apiV1/catalog/images/{imageId}';

  static const String catalogOperatingBrackets =
      '$apiV1/catalog/operating-brackets';
  static const String catalogOperatingBracketCreate =
      '$apiV1/catalog/operating-brackets';
  static const String catalogOperatingBracketUpdate =
      '$apiV1/catalog/operating-brackets/{bracketId}';
  static const String catalogOperatingBracketDelete =
      '$apiV1/catalog/operating-brackets/{bracketId}';

  static const String catalogAttributes = '$apiV1/catalog/attributes';
  static const String catalogAttributeCreate = '$apiV1/catalog/attributes';
  static const String catalogAttributeById =
      '$apiV1/catalog/attributes/{attributeId}';
  static const String catalogAttributeDelete =
      '$apiV1/catalog/attributes/{attributeId}';
  static const String catalogAttributeOptionCreate =
      '$apiV1/catalog/attributes/{attributeId}/options';

  static const String catalogPresets = '$apiV1/catalog/presets';

  static const String catalogBrands = '$apiV1/catalog/brands';
  static const String catalogBrandCreate = '$apiV1/catalog/brands';
  static const String catalogBrandUpdate = '$apiV1/catalog/brands/{brandId}';
  static const String catalogBrandDelete = '$apiV1/catalog/brands/{brandId}';

  static const String catalogVariantAttributes =
      '$apiV1/catalog/variants/{variantId}/attributes';

  /// Query: `supplierId`.
  static const String catalogPriceSheets = '$apiV1/catalog/price-sheets';
  static const String catalogPriceSheetCreate = '$apiV1/catalog/price-sheets';
  static const String catalogPriceSheetById =
      '$apiV1/catalog/price-sheets/{priceSheetId}';
  static const String catalogPriceSheetApply =
      '$apiV1/catalog/price-sheets/{priceSheetId}/apply';

  /// Query: `variantId`, `channel`.
  static const String catalogSellingPrices = '$apiV1/catalog/selling-prices';
  static const String catalogSellingPriceCreate =
      '$apiV1/catalog/selling-prices';

  // ───────────────────────────── Inventory ────────────────────────────

  static const String inventoryWarehouses = '$apiV1/inventory/warehouses';
  static const String inventoryWarehouseCreate = '$apiV1/inventory/warehouses';
  static const String inventoryWarehouseById =
      '$apiV1/inventory/warehouses/{warehouseId}';
  static const String inventoryWarehouseUpdate =
      '$apiV1/inventory/warehouses/{warehouseId}';

  /// Query: `warehouseId`.
  static const String inventoryStocks = '$apiV1/inventory/stocks';
  static const String inventoryStocksLowAlerts =
      '$apiV1/inventory/stocks/low-alerts';
  static const String inventoryStockThreshold =
      '$apiV1/inventory/stocks/threshold';

  static const String inventoryTransfers = '$apiV1/inventory/transfers';
  static const String inventoryTransferById =
      '$apiV1/inventory/transfers/{transferId}';
  static const String inventoryTransferDispatch =
      '$apiV1/inventory/transfers/{transferId}/dispatch';
  static const String inventoryTransferApprove =
      '$apiV1/inventory/transfers/{transferId}/approve';

  static const String inventoryAudits = '$apiV1/inventory/audits';
  static const String inventoryAuditReconcile =
      '$apiV1/inventory/audits/{auditId}/reconcile';

  /// Query: `warehouseId`, `variantId`.
  static const String inventoryBatches = '$apiV1/inventory/batches';

  /// Query: `warehouseId`.
  static const String inventoryBatchesValuation =
      '$apiV1/inventory/batches/valuation';

  // ──────────────────────── Warehouse operations ──────────────────────

  /// Query: `warehouseId`.
  static const String warehouseStockLookup =
      '$apiV1/warehouse/stocks/lookup/{sku}';
  static const String warehouseStockAdjustment =
      '$apiV1/warehouse/stocks/adjustment';

  /// Query: `warehouseId`.
  static const String warehousePendingTransfers =
      '$apiV1/warehouse/transfers/pending';
  static const String warehouseTransferConfirmReceipt =
      '$apiV1/warehouse/transfers/{transferId}/confirm-receipt';
  static const String warehouseAuditCount =
      '$apiV1/warehouse/audits/{auditId}/count';

  // ──────────────────────────── Sales & POS ───────────────────────────

  static const String salesPosCompleteSale = '$apiV1/sales/pos/complete-sale';
  static const String salesPosPlaceOrder = '$apiV1/sales/pos/place-order';
  static const String salesPosOrderDraft = '$apiV1/sales/pos/orders/draft';

  /// `{sku}` may be a barcode or a SKU.
  static const String salesPosScan = '$apiV1/sales/pos/scan/{sku}';

  static const String salesPosOrderReturn =
      '$apiV1/sales/pos/orders/{orderId}/return';
  static const String salesPosOrderComplete =
      '$apiV1/sales/pos/orders/{orderId}/complete';
  static const String salesPosOrderReceipt =
      '$apiV1/sales/pos/orders/{orderId}/receipt';
  static const String salesPosOrderInvoicePdf =
      '$apiV1/sales/pos/orders/{orderId}/invoice-pdf';

  static const String salesPosShiftOpen = '$apiV1/sales/pos/drawer/shift/open';
  static const String salesPosShiftDrop = '$apiV1/sales/pos/drawer/shift/drop';
  static const String salesPosShiftClose =
      '$apiV1/sales/pos/drawer/shift/close';
  static const String salesPosShiftCurrent =
      '$apiV1/sales/pos/drawer/shift/current';

  static const String salesPosCustomOrder = '$apiV1/sales/pos/custom-order';
  static const String salesPosReservations = '$apiV1/sales/pos/reservations';
  static const String salesPosReservationById =
      '$apiV1/sales/pos/reservations/{reservationId}';
  static const String salesPosReservationPay =
      '$apiV1/sales/pos/reservations/{reservationId}/pay';
  static const String salesPosReservationFulfill =
      '$apiV1/sales/pos/reservations/{reservationId}/fulfill';

  static const String salesOrderConfirmPayment =
      '$apiV1/sales/orders/{orderId}/confirm-payment';
  static const String salesOrderApproveReturn =
      '$apiV1/sales/orders/{orderId}/approve-return';
  static const String salesOrderCancel = '$apiV1/sales/orders/{orderId}/cancel';
  static const String salesOrderPayBalance =
      '$apiV1/sales/orders/{orderId}/pay-balance';

  static const String salesPromotions = '$apiV1/sales/promotions';
  static const String salesPromotionToggle =
      '$apiV1/sales/promotions/{promotionId}/toggle';

  // ─────────────────────────────── CRM ────────────────────────────────

  static const String crmWarrantyRegister = '$apiV1/crm/warranties/register';
  static const String crmWarrantyById = '$apiV1/crm/warranties/{warrantyId}';
  static const String crmWarrantyClaims =
      '$apiV1/crm/warranties/{warrantyId}/claims';
  static const String crmClaimInspection =
      '$apiV1/crm/claims/{claimId}/inspection';
  static const String crmClaimResolve = '$apiV1/crm/claims/{claimId}/resolve';
  static const String crmClaimClose = '$apiV1/crm/claims/{claimId}/close';
  static const String crmReviewModerate =
      '$apiV1/crm/reviews/{reviewId}/moderate';

  // ───────────────────────── Identity (admin) ─────────────────────────

  static const String identityBranches = '$apiV1/identity/branches';
  static const String identityBranchCreate = '$apiV1/identity/branches';
  static const String identityBranchToggle =
      '$apiV1/identity/branches/{branchId}/toggle';

  static const String identityRoles = '$apiV1/identity/access/roles';
  static const String identityUsers = '$apiV1/identity/access/users';
  static const String identityUserCreate = '$apiV1/identity/access/users';
  static const String identityUserRolesSet =
      '$apiV1/identity/access/users/{userId}/roles';
  static const String identityUserToggle =
      '$apiV1/identity/access/users/{userId}/toggle';

  static const String identityVehicles = '$apiV1/identity/fleet/vehicles';
  static const String identityVehicleCreate = '$apiV1/identity/fleet/vehicles';
  static const String identityVehicleById =
      '$apiV1/identity/fleet/vehicles/{vehicleId}';
  static const String identityVehicleUpdate =
      '$apiV1/identity/fleet/vehicles/{vehicleId}';
  static const String identityVehicleDelete =
      '$apiV1/identity/fleet/vehicles/{vehicleId}';

  // ──────────────────────────── Purchasing ────────────────────────────

  static const String purchasingSuppliers = '$apiV1/purchasing/suppliers';
  static const String purchasingSupplierCreate = '$apiV1/purchasing/suppliers';
  static const String purchasingSupplierById =
      '$apiV1/purchasing/suppliers/{supplierId}';
  static const String purchasingSupplierUpdate =
      '$apiV1/purchasing/suppliers/{supplierId}';
  static const String purchasingSupplierStatement =
      '$apiV1/purchasing/suppliers/{supplierId}/statement';

  static const String purchasingPurchaseOrders =
      '$apiV1/purchasing/purchase-orders';
  static const String purchasingPurchaseOrderCreate =
      '$apiV1/purchasing/purchase-orders';
  static const String purchasingPurchaseOrderById =
      '$apiV1/purchasing/purchase-orders/{orderId}';
  static const String purchasingPurchaseOrderSend =
      '$apiV1/purchasing/purchase-orders/{orderId}';

  /// Also used to receive into a shipment (creates cost layers).
  static const String purchasingPurchaseOrderReceive =
      '$apiV1/purchasing/purchase-orders/{orderId}/receive';

  static const String purchasingSupplierPayments =
      '$apiV1/purchasing/supplier-payments';
  static const String purchasingShipments = '$apiV1/purchasing/shipments';
  static const String purchasingSupplierInvoices =
      '$apiV1/purchasing/supplier-invoices';
  static const String purchasingSupplierInvoiceAllocate =
      '$apiV1/purchasing/supplier-invoices/{sinvoiceId}/allocate';
  static const String purchasingSupplierInvoicePay =
      '$apiV1/purchasing/supplier-invoices/{sinvoiceId}/pay';

  static const String purchasingLandedCosts =
      '$apiV1/purchasing/shipments/{shipmentId}/landed-costs';
  static const String purchasingLandedCostCreate =
      '$apiV1/purchasing/shipments/{shipmentId}/landed-costs';
  static const String purchasingLandedCostFinalize =
      '$apiV1/purchasing/landed-costs/{landedCostId}/finalize';

  // ───────────────────────────── Delivery ─────────────────────────────

  static const String deliveryTrips = '$apiV1/delivery/trips';
  static const String deliveryMyTrips = '$apiV1/delivery/my-trips';
  static const String deliveryTripStops =
      '$apiV1/delivery/trips/{tripId}/stops';
  static const String deliveryTripDispatch =
      '$apiV1/delivery/trips/{tripId}/dispatch';
  static const String deliveryTripCancel =
      '$apiV1/delivery/trips/{tripId}/cancel';
  static const String deliveryTripComplete =
      '$apiV1/delivery/trips/{tripId}/complete';
  static const String deliveryTripOptimize =
      '$apiV1/delivery/trips/{tripId}/optimize';
  static const String deliveryTripLocation =
      '$apiV1/delivery/trips/{tripId}/location';

  static const String deliveryOrderConfirm = '$apiV1/delivery/orders/{orderId}';
  static const String deliveryOrderFailed =
      '$apiV1/delivery/orders/{orderId}/failed';

  static const String deliveryStopStatus =
      '$apiV1/delivery/stops/{stopId}/status';
  static const String deliveryStopPin = '$apiV1/delivery/stops/{stopId}/pin';

  // ──────────────────────────────── HR ────────────────────────────────

  static const String hrEmployees = '$apiV1/hr/employees';
  static const String hrEmployeeCreate = '$apiV1/hr/employees';
  static const String hrEmployeeById = '$apiV1/hr/employees/{employeeId}';

  static const String hrLeaves = '$apiV1/hr/leaves';
  static const String hrLeaveCreate = '$apiV1/hr/leaves';
  static const String hrLeaveAction = '$apiV1/hr/leaves/{leaveId}/action';

  static const String hrPayrollCalculate = '$apiV1/hr/payroll/calculate';
  static const String hrPayrollApprove =
      '$apiV1/hr/payroll/{payrollId}/approve';
  static const String hrPayrollExportExcel =
      '$apiV1/hr/payroll/{payrollId}/export-excel';

  static const String hrCommissionRules = '$apiV1/hr/commissions/rules';
  static const String hrCommissionRuleCreate = '$apiV1/hr/commissions/rules';
  static const String hrAdvances = '$apiV1/hr/advances';
  static const String hrAdvanceCreate = '$apiV1/hr/advances';
  static const String hrDeductions = '$apiV1/hr/deductions';

  static const String meLeaveRequest = '$apiV1/me/leaves/request';
  static const String mePayslips = '$apiV1/me/payslips';
  static const String meCommissions = '$apiV1/me/commissions';

  // ───────────────────────────── Accounting ───────────────────────────

  static const String accountingChartOfAccounts =
      '$apiV1/accounting/chart-of-accounts';
  static const String accountingAccountCreate =
      '$apiV1/accounting/chart-of-accounts';
  static const String accountingAccountByCode =
      '$apiV1/accounting/chart-of-accounts/{accountCode}';

  static const String accountingJournalEntries =
      '$apiV1/accounting/journal-entries';
  static const String accountingJournalEntryCreate =
      '$apiV1/accounting/journal-entries';
  static const String accountingJournalEntryById =
      '$apiV1/accounting/journal-entries/{journalId}';

  /// Query: `accountCode`.
  static const String accountingGeneralLedger =
      '$apiV1/accounting/general-ledger';

  static const String accountingTreasuries = '$apiV1/accounting/treasuries';
  static const String accountingTreasuryCreate = '$apiV1/accounting/treasuries';
  static const String accountingTreasuryTransfer =
      '$apiV1/accounting/treasuries/transfers';

  static const String accountingExpenses = '$apiV1/accounting/expenses';
  static const String accountingExpenseCreate = '$apiV1/accounting/expenses';

  static const String accountingChecks = '$apiV1/accounting/checks';
  static const String accountingCheckCreate = '$apiV1/accounting/checks';
  static const String accountingCheckStatus =
      '$apiV1/accounting/checks/{checkId}/status';

  /// Query: `from`, `to`.
  static const String accountingProfitLoss =
      '$apiV1/accounting/reports/profit-loss';

  /// Query: `from`, `to`.
  static const String accountingTaxReport = '$apiV1/accounting/reports/tax';

  /// Query: `to`.
  static const String accountingBalanceSheet =
      '$apiV1/accounting/reports/balance-sheet';

  // ───────────────────────────── Analytics ────────────────────────────

  static const String analyticsSummary = '$apiV1/analytics/summary';

  /// Query: `warehouseId`.
  static const String analyticsProductVelocity =
      '$apiV1/analytics/product-velocity';
  static const String analyticsAuditTrailTransfer =
      '$apiV1/analytics/audit-trail/transfer/{transferId}';

  /// Query: `from`, `to`.
  static const String analyticsRevenueProfit =
      '$apiV1/analytics/revenue-profit';

  /// Query: `from`, `to`.
  static const String analyticsTopProducts = '$apiV1/analytics/products/top';

  /// Query: `from`, `to`.
  static const String analyticsBranchesPerformance =
      '$apiV1/analytics/performance/branches';

  /// Query: `from`, `to`.
  static const String analyticsGeoHeatmap = '$apiV1/analytics/geo-heatmap';

  static const String analyticsInquiries = '$apiV1/analytics/inquiries';
  static const String analyticsInquiryCreate = '$apiV1/analytics/inquiries';

  /// Query: `from`.
  static const String analyticsInquiriesTopAsked =
      '$apiV1/analytics/inquiries/top-asked';

  static const String analyticsNotifications = '$apiV1/analytics/notifications';

  /// Query: `from`, `to`.
  static const String analyticsRevenue = '$apiV1/analytics/revenue';
  static const String analyticsCustomersRfm = '$apiV1/analytics/customers/rfm';

  /// Query: `from`, `to`.
  static const String analyticsSalesDrilldown =
      '$apiV1/analytics/sales-drilldown';

  // ──────────────────── Marketing (spin campaigns) ────────────────────

  static const String estimatorSpinCampaigns =
      '$apiV1/estimator/spin/campaigns';
  static const String estimatorSpinCampaignCreate =
      '$apiV1/estimator/spin/campaigns';
  static const String estimatorSpinCampaignToggle =
      '$apiV1/estimator/spin/campaigns/{campaignId}/toggle';
  static const String estimatorSpinCampaignPrizeCreate =
      '$apiV1/estimator/spin/campaigns/{campaignId}/prizes';
}
