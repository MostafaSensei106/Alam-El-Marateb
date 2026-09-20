/**
 * ==============================================================================
 * Alam El Marateb (عالم المراتب) - Comprehensive k6 Load & Stress Testing Suite
 * ==============================================================================
 *
 * This script stress-tests the Modular Monolith backend across realistic multi-user
 * operational scenarios simultaneously:
 *
 *  1. Storefront Browsing & Search (Public Anonymous / Shopper Traffic)
 *  2. Real-Time Custom Dimension Quoting (In-memory Geometric Engine)
 *  3. E-Commerce Cart & Checkout (Idempotent Orders + Shipping Estimates)
 *  4. High-Throughput POS Cashier Sales (Barcode Scanning + Shift Cash Sales)
 *  5. Driver Fleet Telemetry (High-Frequency GPS Coordinate Streaming)
 *  6. Executive Analytics Queries (Aggregations over Real-Time Daily Sales Facts)
 *
 * ------------------------------------------------------------------------------
 * How to Run:
 * ------------------------------------------------------------------------------
 *
 * 1. Default Multi-Scenario Load Test (Ramps up to ~150 concurrent VUs):
 *    k6 run load-all.ts
 *
 * 2. Custom Target Host / Port:
 *    k6 run -e BASE_URL=http://localhost:8080 load-all.ts
 *
 * 3. Quick Smoke Test (Low VUs & Duration):
 *    k6 run -e PROFILE=smoke load-all.ts
 *
 * 4. Maximum Stress / Spike Test (Up to 500 VUs):
 *    k6 run -e PROFILE=stress load-all.ts
 *
 * 5. Run a Single Scenario Only:
 *    k6 run -e SCENARIO=pos load-all.ts
 *    k6 run -e SCENARIO=storefront load-all.ts
 *    k6 run -e SCENARIO=checkout load-all.ts
 *    k6 run -e SCENARIO=analytics load-all.ts
 *    k6 run -e SCENARIO=gps load-all.ts
 * ==============================================================================
 */

import http, { Response } from 'k6/http';
import { check, group, sleep } from 'k6';
import { Rate, Trend, Counter } from 'k6/metrics';
import { Options } from 'k6/options';

// ------------------------------------------------------------------------------
// Configuration & Environment Variables
// ------------------------------------------------------------------------------
const BASE_URL = __ENV.BASE_URL || 'http://localhost:8080';
const ADMIN_PHONE = __ENV.ADMIN_PHONE || '01000000000';
const ADMIN_PASSWORD = __ENV.ADMIN_PASSWORD || 'admin123';
const PROFILE = __ENV.PROFILE || 'standard'; // 'smoke' | 'standard' | 'stress'
const TARGET_SCENARIO = __ENV.SCENARIO || 'all';

// ------------------------------------------------------------------------------
// Custom Observability Metrics
// ------------------------------------------------------------------------------
export const errorRate = new Rate('custom_error_rate');
export const customQuoteDuration = new Trend('custom_quote_duration_ms', true);
export const posSaleDuration = new Trend('pos_sale_duration_ms', true);
export const ecommerceCheckoutDuration = new Trend('ecommerce_checkout_duration_ms', true);
export const analyticsQueryDuration = new Trend('analytics_query_duration_ms', true);
export const gpsPushDuration = new Trend('gps_push_duration_ms', true);

export const ordersCompleted = new Counter('orders_completed_total');
export const quotesCalculated = new Counter('quotes_calculated_total');
export const gpsPointsPushed = new Counter('gps_points_pushed_total');

// ------------------------------------------------------------------------------
// k6 Execution Options & Dynamic Scenarios
// ------------------------------------------------------------------------------
function buildScenarios(): Record<string, any> {
  if (PROFILE === 'smoke') {
    return {
      smoke_test: {
        executor: 'constant-vus',
        vus: 5,
        duration: '30s',
        exec: 'smokeWorkflow',
      },
    };
  }

  if (PROFILE === 'stress') {
    return {
      stress_traffic: {
        executor: 'ramping-vus',
        startVUs: 10,
        stages: [
          { duration: '1m', target: 100 },
          { duration: '2m', target: 300 },
          { duration: '1m', target: 500 }, // Peak stress spike
          { duration: '2m', target: 300 },
          { duration: '1m', target: 0 },
        ],
        exec: 'standardWorkflow',
      },
    };
  }

  // Multi-Workload Partitioning (Standard Profile)
  const scenarios: Record<string, any> = {};

  if (TARGET_SCENARIO === 'all' || TARGET_SCENARIO === 'storefront') {
    scenarios.storefront_browsers = {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '30s', target: 30 },
        { duration: '2m', target: 60 },
        { duration: '30s', target: 0 },
      ],
      exec: 'storefrontScenario',
    };
  }

  if (TARGET_SCENARIO === 'all' || TARGET_SCENARIO === 'checkout') {
    scenarios.ecommerce_shoppers = {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '30s', target: 15 },
        { duration: '2m', target: 30 },
        { duration: '30s', target: 0 },
      ],
      exec: 'ecommerceCheckoutScenario',
    };
  }

  if (TARGET_SCENARIO === 'all' || TARGET_SCENARIO === 'pos') {
    scenarios.cashier_terminals = {
      executor: 'constant-vus',
      vus: 10,
      duration: '3m',
      exec: 'posCashierScenario',
    };
  }

  if (TARGET_SCENARIO === 'all' || TARGET_SCENARIO === 'gps') {
    scenarios.fleet_drivers = {
      executor: 'constant-vus',
      vus: 5,
      duration: '3m',
      exec: 'driverGpsScenario',
    };
  }

  if (TARGET_SCENARIO === 'all' || TARGET_SCENARIO === 'analytics') {
    scenarios.management_reporting = {
      executor: 'constant-vus',
      vus: 3,
      duration: '3m',
      exec: 'analyticsScenario',
    };
  }

  return scenarios;
}

export const options: Options = {
  scenarios: buildScenarios(),
  thresholds: {
    // Quality of Service Gates
    http_req_failed: ['rate<0.02'], // HTTP failures must remain below 2%
    http_req_duration: ['p(95)<600', 'p(99)<1200'], // 95% of queries under 600ms
    custom_error_rate: ['rate<0.02'],
    custom_quote_duration_ms: ['p(95)<150'], // Pure geometric calculation SLA < 150ms
    pos_sale_duration_ms: ['p(95)<450'], // POS checkout SLA < 450ms
    analytics_query_duration_ms: ['p(95)<800'],
  },
};

// ------------------------------------------------------------------------------
// Setup Stage: Pre-flight Verification & Token Bootstrapping
// ------------------------------------------------------------------------------
export interface TestContext {
  adminToken: string;
  customerToken: string;
  sampleProductSlugs: string[];
  sampleVariantId: string | null;
  sampleTripId: string | null;
}

export function setup(): TestContext {
  console.log(`[k6 Setup] Connecting to backend at ${BASE_URL}...`);

  // 1. Authenticate Admin
  const adminLoginPayload = JSON.stringify({
    phone: ADMIN_PHONE,
    password: ADMIN_PASSWORD,
  });

  const adminRes = http.post(`${BASE_URL}/api/v1/auth/login`, adminLoginPayload, {
    headers: { 'Content-Type': 'application/json' },
  });

  let adminToken = '';
  if (adminRes.status === 200) {
    const json = adminRes.json() as any;
    adminToken = json?.data?.accessToken || '';
    console.log('[k6 Setup] Successfully authenticated Super Admin.');
  } else {
    console.warn(`[k6 Setup] Admin login returned ${adminRes.status}: ${adminRes.body}`);
  }

  // 2. Register/Login a Dedicated Test Customer
  const customerPhone = `011${Math.floor(10000000 + Math.random() * 90000000)}`;
  const customerPass = 'customerPass123!';
  const registerPayload = JSON.stringify({
    fullName: 'Load Test Customer',
    phone: customerPhone,
    password: customerPass,
    email: `loadtest_${Date.now()}@example.com`,
  });

  http.post(`${BASE_URL}/api/v1/auth/register`, registerPayload, {
    headers: { 'Content-Type': 'application/json' },
  });

  const customerLoginRes = http.post(
    `${BASE_URL}/api/v1/auth/login`,
    JSON.stringify({ phone: customerPhone, password: customerPass }),
    { headers: { 'Content-Type': 'application/json' } }
  );

  let customerToken = '';
  if (customerLoginRes.status === 200) {
    const json = customerLoginRes.json() as any;
    customerToken = json?.data?.accessToken || '';
  }

  // Fallback to admin token if customer registration was disabled or already exists
  if (!customerToken) {
    customerToken = adminToken;
  }

  // 3. Probe Catalog for Dynamic Slugs & Variants
  const catalogRes = http.get(`${BASE_URL}/api/v1/catalog/public/products`);
  const slugs: string[] = [];
  let sampleVariantId: string | null = null;

  if (catalogRes.status === 200) {
    const json = catalogRes.json() as any;
    const items = json?.data || [];
    for (const item of items) {
      if (item.slug) slugs.push(item.slug);
      if (!sampleVariantId && item.variants && item.variants.length > 0) {
        sampleVariantId = item.variants[0].id;
      }
    }
  }

  if (slugs.length === 0) {
    slugs.push('medical-royal', 'extra-latex', 'comfort-foam');
  }

  console.log(`[k6 Setup] Ready. Discovered ${slugs.length} catalog slugs. Starting test run.`);

  return {
    adminToken,
    customerToken,
    sampleProductSlugs: slugs,
    sampleVariantId,
    sampleTripId: '00000000-0000-0000-0000-000000000001',
  };
}

// ------------------------------------------------------------------------------
// Utilities
// ------------------------------------------------------------------------------
function randomElement<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

function generateUuid(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

function authHeaders(token: string, additional: Record<string, string> = {}) {
  const h: Record<string, string> = {
    'Content-Type': 'application/json',
    'X-Lang': 'ar',
    ...additional,
  };
  if (token) {
    h['Authorization'] = `Bearer ${token}`;
  }
  return h;
}

// ------------------------------------------------------------------------------
// Scenario 1: Storefront Browsing & Quoting
// ------------------------------------------------------------------------------
export function storefrontScenario(data: TestContext) {
  group('Catalog Storefront Browsing', () => {
    // 1. Browse All Products
    const listRes = http.get(`${BASE_URL}/api/v1/catalog/public/products`, {
      headers: { 'X-Lang': 'ar' },
    });
    const listOk = check(listRes, {
      'storefront list status 200': (r) => r.status === 200,
    });
    errorRate.add(!listOk);

    sleep(0.5);

    // 2. Search Catalog
    const queries = ['مرتبة', 'مخدة', 'لاتكس', 'سوست', 'طبي'];
    const query = randomElement(queries);
    const searchRes = http.get(`${BASE_URL}/api/v1/catalog/public/products/search?q=${encodeURIComponent(query)}`);
    check(searchRes, {
      'search status 200': (r) => r.status === 200,
    });

    sleep(0.5);

    // 3. Inspect Individual Product Page
    const slug = randomElement(data.sampleProductSlugs);
    const detailRes = http.get(`${BASE_URL}/api/v1/catalog/public/products/${slug}`);
    check(detailRes, {
      'product detail status 200 or 404': (r) => r.status === 200 || r.status === 404,
    });

    // 4. Algorithmic Custom Dimension Quote (Stress testing geometric math)
    const shapes = ['RECTANGLE', 'OVAL', 'ROUND'];
    const quotePayload = JSON.stringify({
      shape: randomElement(shapes),
      widthCm: Math.floor(90 + Math.random() * 110), // 90 to 200 cm
      lengthCm: Math.floor(180 + Math.random() * 30), // 180 to 210 cm
    });

    const quoteStart = Date.now();
    const quoteRes = http.post(
      `${BASE_URL}/api/v1/catalog/public/products/${slug}/custom-quote`,
      quotePayload,
      { headers: { 'Content-Type': 'application/json', 'X-Lang': 'ar' } }
    );
    customQuoteDuration.add(Date.now() - quoteStart);

    const quoteOk = check(quoteRes, {
      'custom quote status 200 or 404': (r) => r.status === 200 || r.status === 404,
    });
    if (quoteRes.status === 200) {
      quotesCalculated.add(1);
    }
    errorRate.add(!quoteOk);

    sleep(1);
  });
}

// ------------------------------------------------------------------------------
// Scenario 2: E-Commerce Shopper Flow (Cart -> Estimate -> Place Order)
// ------------------------------------------------------------------------------
export function ecommerceCheckoutScenario(data: TestContext) {
  group('E-Commerce Shopper Flow', () => {
    const headers = authHeaders(data.customerToken);

    // 1. View Cart
    const cartRes = http.get(`${BASE_URL}/api/v1/shop/cart`, { headers });
    check(cartRes, {
      'view cart status 200': (r) => r.status === 200,
    });

    sleep(0.5);

    // 2. Add Item to Cart if Variant Available
    if (data.sampleVariantId) {
      const addItemPayload = JSON.stringify({
        variantId: data.sampleVariantId,
        quantity: 1,
      });

      http.post(`${BASE_URL}/api/v1/shop/cart/items`, addItemPayload, { headers });
    }

    // 3. Estimate Shipping
    const estimatePayload = JSON.stringify({
      governorate: 'Gharbia',
      area: 'Tanta',
      floorNumber: Math.floor(1 + Math.random() * 8),
    });

    http.post(`${BASE_URL}/api/v1/shop/checkout/estimate-shipping`, estimatePayload, { headers });

    // 4. Place Order with Idempotency Key
    const idempotencyKey = `ecom-${generateUuid()}`;
    const orderPayload = JSON.stringify({
      customerPhone: '01023456789',
      paymentMethod: 'COD',
      items: data.sampleVariantId
        ? [{ variantId: data.sampleVariantId, quantity: 1, unitPrice: 3500.0 }]
        : [],
    });

    const checkoutStart = Date.now();
    const orderRes = http.post(`${BASE_URL}/api/v1/shop/checkout/place-order`, orderPayload, {
      headers: authHeaders(data.customerToken, { 'Idempotency-Key': idempotencyKey }),
    });
    ecommerceCheckoutDuration.add(Date.now() - checkoutStart);

    const orderOk = check(orderRes, {
      'place order status 200, 201 or 400': (r) =>
        r.status === 200 || r.status === 201 || r.status === 400,
    });
    if (orderRes.status === 200 || orderRes.status === 201) {
      ordersCompleted.add(1);
    }
    errorRate.add(!orderOk);

    sleep(1.5);
  });
}

// ------------------------------------------------------------------------------
// Scenario 3: Cashier POS High-Throughput Checkouts
// ------------------------------------------------------------------------------
export function posCashierScenario(data: TestContext) {
  group('POS Cashier Operations', () => {
    const cashierHeaders = authHeaders(data.adminToken);

    // 1. Cashier Barcode Scan Lookup
    const barcodes = ['SKU-1001', 'SKU-2002', 'BAR-998811', 'UNKNOWN-BARCODE'];
    const barcode = randomElement(barcodes);

    const scanRes = http.get(`${BASE_URL}/api/v1/sales/pos/scan/${barcode}`, {
      headers: cashierHeaders,
    });
    check(scanRes, {
      'barcode scan answered': (r) => r.status === 200 || r.status === 404,
    });

    sleep(0.3);

    // 2. Check Active Drawer Shift Balance
    http.get(`${BASE_URL}/api/v1/sales/pos/drawer/shift/current`, {
      headers: cashierHeaders,
    });

    sleep(0.3);

    // 3. Complete Instant In-Store Sale
    const idempotencyKey = `pos-${generateUuid()}`;
    const salePayload = JSON.stringify({
      customerPhone: `010${Math.floor(10000000 + Math.random() * 90000000)}`,
      paymentMethod: 'CASH',
      paidAmount: 4200.0,
      items: data.sampleVariantId
        ? [{ variantId: data.sampleVariantId, quantity: 1, unitPrice: 4200.0 }]
        : [],
    });

    const posStart = Date.now();
    const saleRes = http.post(`${BASE_URL}/api/v1/sales/pos/complete-sale`, salePayload, {
      headers: authHeaders(data.adminToken, { 'Idempotency-Key': idempotencyKey }),
    });
    posSaleDuration.add(Date.now() - posStart);

    const saleOk = check(saleRes, {
      'pos complete sale valid status': (r) =>
        r.status === 200 || r.status === 201 || r.status === 400,
    });
    if (saleRes.status === 200 || saleRes.status === 201) {
      ordersCompleted.add(1);
    }
    errorRate.add(!saleOk);

    sleep(1);
  });
}

// ------------------------------------------------------------------------------
// Scenario 4: Driver Fleet Real-Time GPS Streaming
// ------------------------------------------------------------------------------
export function driverGpsScenario(data: TestContext) {
  group('Driver Fleet GPS Telemetry', () => {
    // Generate simulated coordinates in the Nile Delta / Tanta region
    const baseLat = 30.7865;
    const baseLng = 31.0004;
    const lat = baseLat + (Math.random() - 0.5) * 0.05;
    const lng = baseLng + (Math.random() - 0.5) * 0.05;

    const locationPayload = JSON.stringify({
      latitude: lat,
      longitude: lng,
      speedKmh: Math.floor(20 + Math.random() * 60),
      headingDegrees: Math.floor(Math.random() * 360),
    });

    const gpsStart = Date.now();
    const gpsRes = http.post(
      `${BASE_URL}/api/v1/delivery/trips/${data.sampleTripId}/location`,
      locationPayload,
      { headers: authHeaders(data.adminToken) }
    );
    gpsPushDuration.add(Date.now() - gpsStart);

    const gpsOk = check(gpsRes, {
      'gps coordinate accepted or trip not found': (r) =>
        r.status === 200 || r.status === 204 || r.status === 404,
    });
    if (gpsRes.status === 200 || gpsRes.status === 204) {
      gpsPointsPushed.add(1);
    }
    errorRate.add(!gpsOk);

    sleep(2); // GPS updates arrive periodically every 2 seconds
  });
}

// ------------------------------------------------------------------------------
// Scenario 5: Executive Management Analytics & Reporting
// ------------------------------------------------------------------------------
export function analyticsScenario(data: TestContext) {
  group('Management Analytics Dashboard', () => {
    const headers = authHeaders(data.adminToken);

    // 1. Real-Time Summary Dashboard
    const analyticsStart = Date.now();
    const summaryRes = http.get(`${BASE_URL}/api/v1/analytics/summary`, { headers });
    analyticsQueryDuration.add(Date.now() - analyticsStart);

    check(summaryRes, {
      'analytics summary status 200': (r) => r.status === 200,
    });

    sleep(1);

    // 2. Product Velocity & Days of Cover
    const velocityRes = http.get(`${BASE_URL}/api/v1/analytics/product-velocity`, { headers });
    check(velocityRes, {
      'analytics velocity status 200': (r) => r.status === 200,
    });

    sleep(1);

    // 3. Customer RFM Segmentation
    const rfmRes = http.get(`${BASE_URL}/api/v1/analytics/customers/rfm`, { headers });
    check(rfmRes, {
      'rfm segmentation status 200': (r) => r.status === 200,
    });

    sleep(2);
  });
}

// ------------------------------------------------------------------------------
// Combined Workflow for Smoke and Stress Profiles
// ------------------------------------------------------------------------------
export function smokeWorkflow(data: TestContext) {
  storefrontScenario(data);
  posCashierScenario(data);
  analyticsScenario(data);
}

export function standardWorkflow(data: TestContext) {
  // Balanced distribution of simulated actions
  const roll = Math.random();
  if (roll < 0.45) {
    storefrontScenario(data);
  } else if (roll < 0.70) {
    posCashierScenario(data);
  } else if (roll < 0.85) {
    ecommerceCheckoutScenario(data);
  } else if (roll < 0.95) {
    driverGpsScenario(data);
  } else {
    analyticsScenario(data);
  }
}

// Default export fallback
export default function (data: TestContext) {
  standardWorkflow(data);
}
