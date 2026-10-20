# لوحة التحكم — ما يستهلكه Flutter وما ينقصه في Postman

> الملف ده مرجع للـ API calls اللي لوحة تحكم Flutter (`Flutter/Admin`) محتاجاها.
> اللوحة حاليًا شغالة على بيانات عيّنة (`DashboardSampleData`) بنفس شكل الـ DTOs
> المتوقعة، لحد ما الـ endpoints الناقصة تتضاف وتتسجل في
> `Kotlin/docs/api/postman_collection.json`.

## 1. حالة اللوحة

- الشاشة: `Flutter/Admin/lib/modules/dashboard/ui/page/dashboard_page.dart`
- البيانات: `Flutter/Admin/lib/modules/dashboard/data/dashboard_sample_data.dart`
- الموديلات: `Flutter/Admin/lib/modules/dashboard/domain/dashboard_models.dart`
- كل الأرقام والنسب والفروع ثابتة (deterministic) وبتتغير مع فلتر الفترة/الفرع.
- لا يوجد أي اتصال شبكي فعلي من اللوحة دلوقتي: `ApiService` في Flutter فاضي
  و`ApiRoutes.apiBaseURL` بيشاور على API تطبيق الموبايل مش على API الإدارة.

## 2. الـ endpoints الموجودة والمستخدمة في التصميم

كلها تحت `/api/v1/analytics` ودورها `BRANCH_MANAGER` أو أعلى.

| # | الميثود والمسار | اللي بيغذّيه في اللوحة | ناقص للعرض الكامل |
|---|---|---|---|
| 1 | `GET /summary` | KPI مخزون، عدد المنتجات، تنبيهات التشغيل (low stock / transfers / audits) | مفيش إيراد/ربح/أوردرات/عملاء في الـ summary |
| 2 | `GET /revenue-profit?from=&to=&branchId=` | كارت الإيراد + الربح + هامش الربح + متوسط الأوردر | محتاج `branchId` و`orders` وبيانات يومية متجمعة |
| 3 | `GET /performance/branches?from=&to=` | جدول أداء الفروع | بيرجّع `branchId` فقط — محتاج `branchName` و`city` و`share` |
| 4 | `GET /product-velocity?warehouseId=` | جدول سرعة البيع وتغطية المخزون | بيرجّع `variantId` فقط — محتاج اسم المنتج/المقاس والمخزن |
| 5 | `GET /products/top?from=&to=&limit=` | كارت أفضل المنتجات | بيرجّع `variantId` فقط — محتاج الاسم/التصنيف/النصيب |
| 6 | `GET /geo-heatmap?from=&to=` | كارت التوزيع الجغرافي | النصيب محسوب عند العميل — مقبول، أو يتحسب سيرفر |
| 7 | `GET /customers/rfm` | كارت RFM | بيرجّع صف لكل عميل — محتاج تجميع (عدد/قيمة/نصيب لكل شريحة) |
| 8 | `GET /inquiries?branchId=` | كارت استفسارات المعرض | بيرجّع IDs فقط — محتاج اسم العميل/المنتج/الفرع + pagination |
| 9 | `GET /inquiries/top-asked?from=&limit=` | كارت أكثر المنتجات المطلوبة | بيرجّع `productId` فقط — محتاج اسم المنتج |

### إضافات موجودة لكن غير مستهلكة بعد

- `GET /analytics/revenue` — alias لنفس بيانات `revenue-profit`.
- `GET /analytics/customers/rfm` — موجود بالفعل ضمن الجدول أعلاه.
- `GET /analytics/notifications` — طابور متابعة، ممكن يغذّي تنبيهات التشغيل.
- `GET /analytics/sales-drilldown?from=&to=&branchId=&limit=` — ممكن يغذّي
  «أحدث الأوردرات» أو صفحة تحليل أعمق.
- `POST /analytics/inquiries` — تسجيل استفسار من الكاشير (موجود).
- `POST /analytics/events` — beacon للسلوك (موجود، 202 دايمًا).

## 3. ميزات Flutter فقط (مش مغطاة بأي endpoint)

دي الميزات اللي اتبنت في اللوحة وليها بيانات عيّنة، ومحتاجة API قبل ما تتوصل:

### 3.1 Customer 360

الحوار (`dashboard_customer_360.dart`) بيعرض:

- بيانات العميل: الاسم، الهاتف، البريد، الفرع المفضل، تاريخ أول تعامل، قناة التواصل.
- الولاء: النقاط، الشريحة (tier)، شريحة RFM، متوسط الأوردر، إجمالي الصرف، عدد الأوردرات.
- العناوين: label + العنوان + المدينة + هاتف التواصل.
- سجل الأوردرات: reference/date/items/total/status/channel.
- الضمانات والمطالبات: المنتج، تاريخ الشراء، تاريخ الانتهاء، الحالة، المشكلة.
- ملاحظات داخلية.

**المقترح:** endpoint واحد مجمّع بدل 5 نداءات:

```http
GET /api/v1/crm/customers/{customerId}/360
```

```json
{
  "success": true,
  "message": "ok",
  "data": {
    "customerId": "uuid",
    "name": "…",
    "phone": "+2010…",
    "email": "…",
    "preferredBranch": { "id": "uuid", "name": "…", "city": "…" },
    "preferredChannel": "showroom | phone | whatsapp",
    "since": "2024-03-11",
    "totalSpend": 84500.00,
    "orders": 12,
    "averageOrder": 7041.67,
    "loyaltyPoints": 420,
    "tier": "gold",
    "rfmSegment": "champions",
    "addresses": [
      { "label": "home", "line": "…", "city": "…", "phone": "…" }
    ],
    "orderHistory": [
      {
        "reference": "SO-2041",
        "date": "2026-10-12",
        "items": 3,
        "total": 12900.00,
        "status": "delivered",
        "channel": "showroom"
      }
    ],
    "claims": [
      {
        "product": "…",
        "purchased": "2025-01-04",
        "expires": "2028-01-04",
        "status": "open",
        "issue": "…"
      }
    ],
    "notes": "…"
  }
}
```

### 3.2 أحدث الأوردرات

اللوحة بتعرض 5 صفوف في الصفحة (5/10/20) مع فتح Customer 360 عند الضغط.

**المقترح:** `GET /api/v1/analytics/recent-orders?branchId=&limit=&page=`

```json
{
  "reference": "SO-2041",
  "customerId": "uuid",
  "customerName": "…",
  "branch": "…",
  "channel": "showroom",
  "status": "paid | pending | delivered | shipping | cancelled",
  "total": 12900.00,
  "date": "2026-10-12",
  "items": 3
}
```

### 3.3 أفضل العملاء

ترتيب تنازلي بإجمالي الصرف، مع tier وعدد الأوردرات، وفتح 360.

**المقترح:** `GET /api/v1/analytics/customers/top?branchId=&from=&to=&limit=`

```json
{
  "customerId": "uuid",
  "name": "…",
  "phone": "…",
  "branch": "…",
  "orders": 12,
  "totalSpend": 84500.00,
  "tier": "gold",
  "rfmSegment": "champions"
}
```

### 3.4 سجل تدقيق عام (Audit feed)

الـ endpoint الحالي `GET /analytics/audit-trail/{entity}/{entityId}` محتاج
كيان ومعرّف. اللوحة محتاجة آخر الأحداث عبر النظام كله.

**المقترح:** `GET /api/v1/analytics/audit-trail/recent?limit=&branchId=`

```json
{
  "id": "uuid",
  "action": "stock.adjust",
  "actor": "…",
  "entity": "variant",
  "entityLabel": "…",
  "entityId": "uuid",
  "detail": "…",
  "at": "2026-10-12T14:03:00"
}
```

### 3.5 تنبيهات التشغيل القابلة للضغط

كروت (نواقص المخزون / تحويلات معلّقة / جرد مفتوح) بتفتح الموديول المناسب.
محتاجة روابط/عدادات مؤكدة من `/summary` أو `GET /analytics/notifications`.

### 3.6 فلتر الفترة والفرع

- الفترة: 7 / 30 / 90 يوم.
- الفرع: `all` أو UUID فرع.
- كل endpoint بيرجّع بياناته لازم يقبل `from` و`to` (ISO `YYYY-MM-DD`)
  و`branchId` اختياري، ما عدا الـ endpoints اللي بالفعل محدد لها باراميترز.
- الأرقام المالية بالجنيه المصري `EGP`، والتواريخ ISOبدون timezone
  (`YYYY-MM-DD`) عشان تتعرض في Flutter بدون `intl`.

## 4. شكل الاستجابة الموحّد

كل الـ endpoints بترجع `ApiResponse<T>`:

```json
{ "success": true, "message": "…", "data": {}, "errors": null }
```

- هيدرز إلزامية: `X-Api-Client`, `X-Api-Key`, `X-Lang: ar|en`.
- `X-Trace-Id` بيترجع في الهيدر.
- الأدوار: `BRANCH_MANAGER` أو `SUPER_ADMIN`.
- الأخطاء: 400 syntax / 422 semantics / 409 conflict / 429 + `Retry-After`.

## 5. خطة تحديث Postman

1. أضف فولدر `Analytics — dashboard gaps` جوه فولدر `analytics`.
2. أضف الـ 5 endpoints المقترحة أعلاه مع أمثلة response.
3. أضف متغيرات: `from`, `to`, `branchId`, `customerId`, `analyticsLimit`.
4. أضف اختبارات Postman أساسية:
   - `pm.expect(json.data).to.be.an('array')` أو object حسب الـ endpoint.
   - `pm.expect(pm.response.headers.get('X-Trace-Id')).to.exist`.
5. حدّث `Kotlin/docs/api.md` بجدول الـ endpoints الجديدة بعد التنفيذ.
6. بعد رجوع الـ API، استبدل `DashboardSampleData.snapshot(...)` في
   `dashboard_page.dart` بنداءات `ApiService` مع نفس الأسماء/الحقول.

## 6. مراجع سريعة

- الـ controller: `Kotlin/src/main/kotlin/com/mostafasensei/alamelmarateb/modules/analytics/presentation/AnalyticsController.kt`
- الموديلات: `.../modules/analytics/domain/model/AnalyticsModels.kt`
- خدمات الإيراد: `.../modules/analytics/application/RevenueServices.kt`
- مسارات التحليلات: `.../core/router/AnalyticsRoutes.kt`
- مسارات CRM: `.../core/router/CrmAdminRoutes.kt`
- مجموعة Postman: `Kotlin/docs/api/postman_collection.json`
