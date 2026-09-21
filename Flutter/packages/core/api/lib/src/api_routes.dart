/// Single source of truth for backend paths.
///
/// Dart port of the backend `core/router/*Routes.kt`. Routes stay
/// version-agnostic; the `/api/v1` prefix is composed here — constants
/// only, never hardcoded strings (Hadidi-Win `ApiRoutes` rule).
abstract final class ApiVersion {
  static const v1 = 'v1';
  static const current = v1;
  static const v1Prefix = '/api/v1';
}

abstract final class AuthRoutes {
  static const base = '/api/v1/auth';
  static const register = '$base/register';
  static const login = '$base/login';
  static const refresh = '$base/refresh';
  static const forgotPassword = '$base/forgot-password';
  static const resetPassword = '$base/reset-password';
  static const changePassword = '$base/change-password';
  static const me = '$base/me';
}

abstract final class IdentityAdminRoutes {
  static const base = '/api/v1/identity';
  static const branches = '$base/branches';
  static const branchById = '$base/branches/{id}';
  static const users = '$base/access/users';
  static const roles = '$base/access/roles';
  static const vehicles = '$base/fleet/vehicles';
}

abstract final class CatalogAdminRoutes {
  static const base = '/api/v1/catalog';
  static const products = '$base/products';
  static const productById = '$base/products/{id}';
  static const categories = '$base/categories';
  static const attributes = '$base/attributes';
  static const presets = '$base/presets';
  static const quickCreate = '$base/products/quick-create';
  static const searchReindex = '$base/search/reindex';
  static const brands = '$base/brands';
  static const brackets = '$base/operating-brackets';
}

abstract final class CatalogStoreRoutes {
  static const base = '/api/v1/catalog/public';
  static const products = '$base/products';
  static const productBySlug = '$base/products/{slug}';
  static const productVariants = '$base/products/{id}/variants';
  static const compare = '$base/products/compare';
  static const featured = '$base/products/featured';
  static const search = '$base/products/search';
  static const suggest = '$base/products/suggest';
  static const categories = '$base/categories';
  static const productReviews = '$base/products/{slug}/reviews';
  static const productImages = '$base/products/{slug}/images';
  static const customQuote = '$base/products/{slug}/custom-quote';
  static const brands = '$base/brands';
  static const quiz = '$base/quiz';
  static const quizRecommend = '$base/quiz/recommend';
}

abstract final class ShopRoutes {
  static const cart = '/api/v1/shop/cart';
  static const cartItems = '$cart/items';
  static const cartMerge = '$cart/merge';
  static const cartClear = '$cart/clear';
  static const checkout = '/api/v1/shop/checkout';
  static const estimateShipping = '$checkout/estimate-shipping';
  static const placeOrder = '$checkout/place-order';
  static const pricePreview = '$checkout/price-preview';
  static const paymentCallback = '$checkout/payment-callback/{gateway}';
  static const orders = '/api/v1/shop/orders';
  static const orderById = '$orders/{orderId}';
  static const trackOrder = '$orders/track/{trackingNumber}';
  static const trackLocation = '$orders/track/{trackingNumber}/location';
}

abstract final class SalesPosRoutes {
  static const base = '/api/v1/sales/pos';
  static const scan = '$base/scan/{barcode}';
  static const draftOrder = '$base/orders/draft';
  static const completeDraft = '$base/orders/{orderId}/complete';
  static const completeSale = '$base/complete-sale';
  static const placeOrder = '$base/place-order';
  static const customOrder = '$base/custom-order';
  static const receipt = '$base/orders/{orderId}/receipt';
  static const invoicePdf = '$base/orders/{orderId}/invoice-pdf';
  static const requestReturn = '$base/orders/{orderId}/return';
  static const shiftCurrent = '$base/drawer/shift/current';
  static const shiftOpen = '$base/drawer/shift/open';
  static const shiftClose = '$base/drawer/shift/close';
  static const shiftDrop = '$base/drawer/shift/drop';
  static const reservations = '$base/reservations';
  static const reservationById = '$base/reservations/{id}';
  static const reservationPay = '$base/reservations/{id}/pay';
  static const reservationFulfill = '$base/reservations/{id}/fulfill';
  static const reservationCancel = '$base/reservations/{id}/cancel';
  static const orderList = '/api/v1/sales/orders';
  static const orderById = '$orderList/{orderId}';
  static const payBalance = '$orderList/{orderId}/pay-balance';
}

abstract final class PromotionRoutes {
  static const base = '/api/v1/sales/promotions';
  static const byId = '$base/{id}';
  static const toggle = '$base/{id}/toggle';
}

abstract final class InventoryAdminRoutes {
  static const base = '/api/v1/inventory';
  static const warehouses = '$base/warehouses';
  static const warehouseById = '$base/warehouses/{warehouseId}';
  static const stocks = '$base/stocks';
  static const lowStockAlerts = '$base/stocks/low-alerts';
  static const setThreshold = '$base/stocks/threshold';
  static const transfers = '$base/transfers';
  static const transferById = '$base/transfers/{transferId}';
  static const transferApprove = '$base/transfers/{transferId}/approve';
  static const audits = '$base/audits';
  static const auditById = '$base/audits/{auditId}';
  static const auditReconcile = '$base/audits/{auditId}/reconcile';
}

abstract final class WarehouseOpsRoutes {
  static const base = '/api/v1/warehouse';
  static const stockLookup = '$base/stocks/lookup/{barcodeOrSku}';
  static const stockAdjustment = '$base/stocks/adjustment';
  static const transfersPending = '$base/transfers/pending';
  static const transferConfirm =
      '$base/transfers/{transferId}/confirm-receipt';
  static const auditCount = '$base/audits/{auditId}/count';
}

abstract final class PurchasingRoutes {
  static const base = '/api/v1/purchasing';
  static const suppliers = '$base/suppliers';
  static const supplierById = '$base/suppliers/{id}';
  static const purchaseOrders = '$base/purchase-orders';
  static const purchaseOrderById = '$base/purchase-orders/{id}';
  static const receiveGoods = '$base/purchase-orders/{id}/receive';
  static const supplierPayments = '$base/supplier-payments';
}

abstract final class CrmAdminRoutes {
  static const base = '/api/v1/crm';
  static const customers = '$base/customers';
  static const warranties = '$base/warranties';
  static const warrantyBySerial = '$base/warranties/{serialNumber}';
  static const scheduleInspection = '$base/claims/{claimId}/inspection';
  static const resolveReplace = '$base/claims/{claimId}/replace';
  static const resolveRepair = '$base/claims/{claimId}/repair';
  static const reviewModerate = '$base/reviews/{id}/moderate';
}

abstract final class PortalRoutes {
  static const base = '/api/v1/portal';
  static const profile = '$base/profile';
  static const addresses = '$base/addresses';
  static const addressById = '$base/addresses/{addressId}';
  static const favorites = '$base/favorites';
  static const favoriteByProduct = '$base/favorites/{productId}';
  static const warrantyRegister = '$base/warranties/register';
  static const warrantyVerify = '$base/warranties/verify/{serialNumber}';
  static const myWarranties = '$base/warranties';
  static const warrantyClaims = '$base/warranties/claims';
  static const reviews = '$base/reviews';
  static const myReviews = '$base/reviews/mine';
  static const loyalty = '$base/loyalty';
  static const loyaltyLedger = '$base/loyalty/ledger';
  static const loyaltyQuote = '$base/loyalty/quote';
}

abstract final class DeliveryRoutes {
  static const base = '/api/v1/delivery';
  static const myTrips = '$base/my-trips';
  static const tripStops = '$base/trips/{tripId}/stops';
  static const stopStatus = '$base/stops/{stopId}/status';
  static const confirmDeliver = '$base/orders/{orderId}';
  static const reportFailed = '$base/orders/{orderId}/failed';
  static const trips = '$base/trips';
  static const tripDispatch = '$base/trips/{tripId}/dispatch';
  static const tripCancel = '$base/trips/{tripId}/cancel';
  static const tripComplete = '$base/trips/{tripId}/complete';
  static const pushLocation = '$base/trips/{tripId}/location';
  static const pinStop = '$base/stops/{stopId}/pin';
  static const optimizeTrip = '$base/trips/{tripId}/optimize';
  static const rateDriver = '$base/orders/{orderId}/rate';
}

abstract final class EstimatorRoutes {
  static const base = '/api/v1/estimator';
  static const catalog = '$base/catalog';
  static const quote = '$base/quote';
  static const spin = '$base/spin';
  static const spinCampaigns = '$base/spin/campaigns';
  static const spinToggle = '$base/spin/campaigns/{id}/toggle';
  static const spinPrize = '$base/spin/campaigns/{campaignId}/prizes';
  static const spinPrizeById = '$base/spin/prizes/{id}';
}
