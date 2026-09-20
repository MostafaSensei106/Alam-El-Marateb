# ARCH — معمارية وداتابيز نظام إدارة محل المراتب

> وثيقة تخطيط حيّة (living doc). الهدف: باك-إند شامل لإدارة محل مراتب بفروع ومخازن متعددة،
> أدمن وعمال وصلاحيات، بيع (معرض + أونلاين)، حجوزات وتسليم وطلبات، وتحليلات من الفواتير.
> التقنية: **Modular Monolith — Kotlin + Spring Boot — Clean Architecture داخل كل موديول**.

---

## 1. المبادئ الحاكمة (غير قابلة للتفاوض)

1. **الدومين هو الملك**: الـ URL يعبر عن المورد (`/catalog`, `/sales`, `/hr`)، والصلاحية يعبر عنها الـ role مش الـ URL.
2. **نوع منتج جديد = داتا مش كود**: إضافة (مرتبة لاتكس، مخدة ميموري، مصحف، مصلية...) تتم من الداشبورد بدون تعديل كود أو redeploy.
3. **الفاتورة هي مصدر الحقيقة للتحليلات**: كل تحليل يُبنى من وقائع البيع (invoices/order items) — لا إدخال يدوي للإحصائيات.
4. **العزل بين الجمهور**: روت الداشبورد ≠ روت العميل ≠ روت التشغيل، على مستوى الـ URL والـ role معاً.
5. **كل حركة مخزن أو خزنة لها أثر مالي**: البيع ← حجز مخزن ← قيد محاسبي، عبر domain events مش استدعاءات مباشرة.

---

## 2. المعمارية: Modular Monolith + Clean Architecture

```
src/main/kotlin/com/mostafasensei/alamelmarateb/
├── core/                        # Shared kernel — ممنوع يعتمد على أي موديول
│   ├── router/                  # ★ كل الروتس في فولدر واحد (15 فايل + ApiRoutes + api/ApiVersion)
│   ├── common/                  # ApiResponse, PagedResponse, BaseController, EntityBase
│   ├── security/                # JWT filter/provider/principal
│   ├── config/                  # SecurityConfig, JPA auditing
│   └── exceptions/              # GlobalExceptionHandler + DomainExceptions
└── modules/<domain>/            # كل موديول معزول، يعتمد على core فقط
    ├── presentation/            # controllers + DTOs (request/response) + mappers
    ├── application/             # use-cases/services + ports (interfaces)
    ├── domain/                  # pure Kotlin: entities, value objects, policies, domain events
    └── infrastructure/          # JPA entities, repository impls, flyway migrations
```

**قواعد الاعتماد**: `presentation → application → domain ← infrastructure`، و`infrastructure → application (ports)`.
ممنوع: controller يحقن repository، موديول يستورد من موديول آخر مباشرة (التواصل عبر events أو application ports).

**الـ versioning**: `/api/v1` ثابت حالياً (`ApiVersion.CURRENT`). نسخة جديدة تُخلق فقط عند breaking change
وللـ resource المتأثر فقط، والقديم يفضل شغال مع هيدر `X-API-Deprecated + Sunset`.

---

## 3. الموديولز العشرة + الروتس بتاعتها

| الموديول | المسؤولية | روتس الكور | الصلاحيات |
|---|---|---|---|
| `catalog` | منتجات، أصناف، صفات، presets، متغيرات (مقاسات) | `CatalogAdminRoutes` (`/catalog`) / `CatalogStoreRoutes` (`/catalog/public`) | إدارة: BRANCH_MANAGER / تصفح: عام |
| `sales` | كاشير POS، سلة، دفع، أوامر، مرتجعات، شفتات درج | `SalesPosRoutes` (`/sales/pos`, `/sales/orders`) / `ShopRoutes` (`/shop`) | CASHIER / CUSTOMER |
| `inventory` | مخازن، أرصدة، تحويلات، جرد، تنبيهات النواقص | `InventoryAdminRoutes` (`/inventory`) / `WarehouseOpsRoutes` (`/warehouse`) | BRANCH_MANAGER / WAREHOUSE_KEEPER |
| `purchasing` | موردين، أوامر شراء، استلام بضاعة | `PurchasingRoutes` (`/purchasing`) | BRANCH_MANAGER |
| `crm` | عملاء، عناوين، ضمان (سيريال)، مطالبات | `CrmAdminRoutes` (`/crm`) / `PortalRoutes` (`/portal`) | BRANCH_MANAGER / CUSTOMER |
| `hr` | موظفين، حضور، إجازات، عمولات، سلف، مرتبات | `HrAdminRoutes` (`/hr`) / `SelfServiceRoutes` (`/me`) | BRANCH_MANAGER / أي موظف (لبياناته) |
| `accounting` | شجرة حسابات، قيود، أستاذ، خزن، مصاريف، شيكات، ضرائب | `AccountingRoutes` (`/accounting`) | ACCOUNTANT |
| `delivery` | رحلات، محطات، إثبات تسليم، مركبات | `DeliveryRoutes` (`/delivery`) | DELIVERY_DRIVER |
| `analytics` | داشبورد الإدارة (قراءة فقط فوق كل الموديولز) | `AnalyticsRoutes` (`/analytics`) | BRANCH_MANAGER فقط |
| `identity` | تسجيل/دخول، فروع، مستخدمين، أدوار | `AuthRoutes` (`/auth` عام) / `IdentityAdminRoutes` (`/identity`) | عام / BRANCH_MANAGER |

---

## 4. الداتابيز — الوضع الحالي والمقترح

### 4.1 الموجود فعلاً (V1 → V3)

- **V1**: `branches`, `roles` (+ 8 أدوار seeded)، `users` (جدول موحد: موظفين + عملاء)، `user_roles`.
- **V2→V3**: `product_categories`, `products`, `product_variants` (SKU/barcode/أبعاد/أسعار)،
  ثم نظام EAV مرن: `product_attribute_definitions`, `product_attribute_options`,
  `category_attributes`, `product_attribute_values (+_options)`، و`product_presets` (+values/variants).
  الأعمدة الهاردكوديد (`product_type, chassis_type, feel...`) اتحذفت — الاتجاه صح.

> ⚠️ **عطل حرج في V1 يمنع أول migrate** (لازم يتصلح قبل أي شغل):
> - جدول `branches` فيه عمود `name` مكرر (سطر 4 و5) ← Postgres يرفض `duplicate column`.
> - سطر 15: `version BIGINT NOT NULL DEFAULT` بدون قيمة ← `syntax error`.
> الإصلاح: حذف السطر المكرر + `DEFAULT 0`.

### 4.2 نظام المنتجات المرن (بدون تعديل كود)

الموديل الحالي EAV يكفي. إضافة نوع جديد (مثال: «مصلية طبية») = خطوات داشبورد فقط:

1. `POST /catalog/categories` → صنف «مصليات».
2. `POST /catalog/attributes` → صفات (الخامة: قطن/فوم، السماكة، المقاس...) بخياراتها.
3. `PUT /catalog/categories/{id}/attributes` → ربط الصفات بالصنف (إجباري/اختياري).
4. `POST /catalog/presets` → بريسِت جاهز، ثم `POST /catalog/products/from-preset/{id}` للتكرار السريع.

**ملاحظة تصميمية**: `product_variants` اليوم (طول×عرض×ارتفاع) تكفي المراتب والمخدات.
لمنتجات بلا أبعاد (مصحف) اترك الأبعاد nullable مستقبلاً أو أضف `variant_attribute_values`
(نفس EAV على مستوى المتغير) — **بدون كسر** الجداول الحالية.

### 4.3 الجداول المقترحة لباقي الموديولز (تُبنى مرحلة مرحلة)

- **sales**: `orders` (branch_id, customer_id, status: draft→confirmed→delivering→delivered/returned, channel: pos/shop),
  `order_items` (variant_id, qty, unit_price, discount — **وقائع التحليلات**),
  `invoices/receipts`, `cash_shifts`, `cash_drawer_moves`, `returns`.
- **inventory**: `warehouses` (branch_id), `stock_levels` (warehouse_id, variant_id, qty, reserved_qty),
  `stock_moves` (ledger لكل حركة: بيع/تحويل/جرد/تالف — لا update مباشر للرصيد),
  `stock_transfers`, `stock_audits (+counts)`, view `low_stock_alerts`.
- **purchasing**: `suppliers`, `purchase_orders (+items)`, `goods_receipts` (تزوّد `stock_moves`).
- **crm**: `customer_profiles` (امتداد لـ `users`: addresses, governorate, segment),
  `customer_addresses`, `warranties` (serial_number فريد ← variant/order_item),
  `warranty_claims` (status + inspection/resolution).
- **hr**: `employees` (امتداد لـ `users`: branch_id, job_title, base_salary, commission_rule_id),
  `attendance_logs`, `leave_requests`, `commission_rules`, `advances`, `deductions`, `payroll_runs (+lines)`.
- **accounting**: `chart_of_accounts`, `journal_entries (+lines)`, `treasuries`, `treasury_transfers`,
  `expenses`, `checks`, وmaterialized views (`profit_loss`, `balance_sheet`, `tax_report`).
- **delivery**: `vehicles` (branch_id), `delivery_trips`, `trip_stops` (order_id, status, proof).
- **analytics** (قراءة فقط): `sales_daily_facts` (materialized من `order_items`),
  `customer_rfm`, `product_velocity`, `warranty_claim_rates` — تُبنى بملء دوري (refresh) لا بكتابة مباشرة.

### 4.4 قواعد عامة للداتابيز

- كل جدول عملياتي: `id UUID`, `branch_id` (حيث ينطبق), `created_at/updated_at/created_by/updated_by`, `version` (optimistic locking).
- `ddl-auto: validate` + كل تغيير عبر Flyway `V<n>__<module>_<what>.sql` — ممنوع تعديل migration مطبق.
- الأرصدة تُشتق من `stock_moves` (ledger) لا تُعدل مباشرة. القيود المحاسبية غير قابلة للحذف (reversal entries فقط).

---

## 5. التحليلات والمتابعة (من الفواتير)

- **فهم العملاء**: RFM (آخر شراء/تكرار/قيمة) + تقسيم المحافظات + تفضيل الخامات (من EAV) ← عروض وfollow-up.
- **المتابعة**: حجوزات (orders بحالة reserved)، تذكير ضمان يقترب، مطالبات مفتوحة، تسليم متأخر (trip_stops).
- **المنتجات**: سرعة البيع per variant، مقارنة الشاسيهات/الخامات، موسمية (seasons)، heatmap جغرافي.
- **الأداء**: فروع، مناديب (عمولات مربوطة بـ order_items)، كاشير (شفتات).

---

## 6. خطة المراحل (نشتغلها واحدة واحدة)

- [x] **P0**: توحيد الروتس + versioning + BaseController (تم).
- [x] **P1**: إصلاح عطل V1 + تثبيت `EntityBase` على كل الكيانات + `customer_profiles`/`employees` (employees بجدول مستقل مرتبط بـ user).
- [x] **P2**: تقسية `catalog` (variant attributes + brands + reviews + Q&A + quiz + quick-create + search/featured/compare) + seed أصناف وبراندات وأسئلة.
- [x] **P3**: `sales` (POS + orders + idempotency + shifts + receipt/invoice) + **محرك الخصومات (10)** + **price-preview قبل الدفع** ← أول revenue path.
- [x] **P4**: `inventory` + `purchasing` (suppliers + POs + receipt دفعات + payments).
- [x] **P5**: `crm` (ضمان شهادة + مطالبات + **مفضلة 8**) + `delivery` (مركبات + رحلات + إثبات تسليم) + **اختبار الترشيح Quiz (9)**.
- [x] **P6**: `hr` (ملفات + إجازات + عمولات + سلف + مرتبات + self-service) + `accounting` (شجرة + قيود + خزن + مصاريف + شيكات + تقارير). القيود التلقائية من الأحداث: بيع→facts؛ قيد محاسبي تلقائي للمرتبات/المشتريات: مؤجل (manual journals).
- [x] **P7**: `analytics` (facts لحظية + إيراد/RFM/فروع/heatmap + beacon + inquiries) + identity (users/roles/branches). الباقي المؤجل: Kafka transport (profile جاهز)، Redis للـ rate-limiter متعدد النسخ، ClickHouse.

## 8. القوالب والمفضلة والخصومات (تصميم — يُنفذ في P2/P3/P5)

### 8.1 القالب الجاهز (Quick-create من preset)
المشكلة: إنشاء منتج جديد (مرتبة 120×195 موديل كذا ارتفاع كذا سوست كذا) اليوم يتطلب ملء كل البيانات.
الحل: `POST /catalog/products/quick-create` ببراميترات `{presetId, slug, widthCm, lengthCm, heightCm?, sku?, prices?}` —
ينسخ الصفات من القالب + متغير **واحد** بالمقاس المطلوب فقط (بدل نسخ كل المقاسات)،
والسعر يُؤخذ من متغير القالب المطابق لنفس العرض/الطول (أو يُتجاوز يدوياً)، وSKU يتولد تلقائياً.

### 8.2 المفضلة (Wishlist)
جدول `favorites (user_id, product_id, UNIQUE(user_id, product_id))` —
`GET/POST/DELETE /portal/favorites` للعميل فقط، تُستخدم لاحقاً في العروض والـ follow-up.

### 8.3 نظام الخصومات (Promotions)
جداول: `promotions (code, promo_type, value_percent/value_amount/bundle_price, target, min_cart_total, validity, max_uses, exclusive)`
+ `promotion_bundle_items`. الأنواع:
- خصم % أو مبلغ ثابت **على عنصر** (يستهدف product أو variant).
- **بندل** بسعر ثابت (مرتبة + كفر) — يُطابَق بالكميات ويُوزع الخصم تناسبياً على السطور.
- خصم % أو مبلغ ثابت **على الإجمالي** (بعد خصومات السطور).
- **هدية**: سطر بسعر صفر يُظهر السعر الأصلي ويُخصم بالكامل في الفاتورة.
القواعد: `exclusive` واحد فقط يفوز (الأعلى توفيراً)، لا خصم يتجاوز قاعدته، والإجمالي لا ينزل تحت الصفر.
`POST /shop/checkout/price-preview` يعرض الحسبة للعميل **قبل الدفع** (غير ملزمة)،
وإدارة الخصومات `GET/POST /sales/promotions` + toggle — للمديرين فقط، العملاء يرون الأثر فقط.

## 9. اختبار الترشيح Quiz + Scoring (تصميم — يُنفذ في P5)

الهدف: اقتراح المرتبة والمخدة المناسبة من 5–7 أسئلة فقط (لا كثير ولا قليل):
وضعية النوم، آلام ظهر/رقبة، الوزن التقريبي، الحرارة والتعرق، الصلابة المفضلة، الميزانية، المقاس.
- كل إجابة تمنح نقاطاً على أبعاد (الصلابة، الدعم، التبريد، الخامة) بأوزان — scoring مرجّح.
- الأبعاد تُطابَق قيم صفات المنتجات (نفس EAV) ← أعلى N منتجات بنسبة توافق %.
- جداول: `quiz_questions`, `quiz_options (scores JSONB)`, `recommendation_runs` (تُغذي التحليلات).
- الأسئلة seedable من الداشبورد (نفس مبدأ: محتوى = داتا مش كود).

## 10. قواعد التعامل مع الفلوس (ملزمة من أول سطر كود مالي)

1. **ممنوع `Double`/`Float` نهائياً** في أي DTO/entity/service يخص فلوس — `java.math.BigDecimal` حصراً.
2. الداتابيز: `NUMERIC(12,2)` للأسعار والإجماليات، `NUMERIC(19,4)` للقيم الوسيطة (موجود فعلاً في V2/V3 — يُعمم).
3. `scale = 2` + `RoundingMode.HALF_EVEN` لكل حسبة فاتورة؛ المقارنة بـ `compareTo` لا `==`.
4. الـ JSON يُسلسل BigDecimal بدقة كاملة؛ الفرونت لا يحسب إجماليات — **الباك هو مصدر الحقيقة** عبر price-preview.
5. العملة واحدة حالياً (EGP) مع عمود `currency_code` جاهز للتوسع مستقبلاً.

## 11. تعدد اللغات AR/EN (مُنفذ — قابل للتوسع)

**محتوى الداتابيز (منتجات/أصناف/براندات/صفات/مناطق/كويز)**: نفس المبدأ بلا أعمدة per-language —
الجدول الأم يحمل العربية canonical، وكل لغة زيادة = صفوف في `*_translations` (مفتاح entity+lang).
لغة جديدة = إضافة الكود لـ `app.i18n.supported` + صفوف ترجمة. صفر DDL وصفر كود.
القراءة تُحل بلغة الطلب (`X-Lang`) بسقوط: المطلوبة ← ar ← canonical.

العقد: **نفس شكل الرسبونس دائماً، لغة واحدة لكل طلب** — لا يُرجع en+ar معاً.
- مفتاح اللغة من هيدر `X-Lang: ar|en` (ثم Accept-Language ثم الافتراضي ar).
- لغة جديدة = ملف `messages_<code>.properties` + إضافة الكود لـ `app.i18n.supported` — بدون تغيير كود.
- التنفيذ: `core/i18n` (فلتر + MessageService + bundles) — الأخطاء المركزية والرسائل الافتراضية مترجمة، والتفاصيل الديناميكية تبقى في `errors`.

## 12. قرارات مؤجلة (نحسمها وقتها)

1. `users` موحد (الحالي) مقابل فصل `customers` — المقترح: إبقاء الموحد + `customer_profiles`.
2. أسعار الضرائب والخصومات: على مستوى الصنف أم الفاتورة أم الاثنين؟
3. الدفع الأونلاين: بوابات (فوري/Paymob) في P3 أم تُؤجل؟
4. صور المنتجات: تخزين محلي أم S3-compatible؟
