# تصميم قاعدة البيانات — تفصيلي (v1)

> كل جدول: الأعمدة بالأنواع والقيود + الفهارس + العلاقات + خريطة الكود (Entity).
> الموجود (V1→V3) موثق كما هو + إصلاحاته. الجديد مرقم V4→V14 ولا يُنفذ إلا بمرحلته.

## 0. اتفاقيات ملزمة

**نمط الترجمات**: بلا أعمدة `name_ar/name_en/...` أبداً — لغة جديدة صفوف لا DDL.
`product/category/brand/attribute/option/zone/quiz/notification_translations` بمفتاح (entity, lang).
القراءة: المطلوبة ← ar ← canonical. الكتابة ترفض أكواد خارج `app.i18n.supported` (400).

| البند | القاعدة |
|---|---|
| المفتاح | `id UUID DEFAULT gen_random_uuid()` PK |
| التدقيق | `created_at, updated_at TIMESTAMPTZ` + `created_by, updated_by VARCHAR(100)` + `version BIGINT DEFAULT 0` |
| الفلوس | `NUMERIC(12,2)` أسعار/إجماليات، `NUMERIC(19,4)` قيم وسيطة — ممنوع float |
| الحذف | RESTRICT للمراجع الأساسية، CASCADE للسطور التابعة، SET NULL للفرع عند حذفه |
| الملفات | `V<n>__<module>_<what>.sql` — ممنوع تعديل migration مطبق (إن طُبق فعلاً يُصلح بـ migration جديد) |

## 1. الهوية identity (V1 موجود + إصلاح)

- `branches`: id, `name` ← ⚠️ مكرر في الملف (سطر 4 و5) يُحذف المكرر، `code UNIQUE`, phone, city, address, is_active + تدقيق + `version` ← ⚠️ `DEFAULT` بلا قيمة تُصبح `DEFAULT 0`. Entity: `BranchJpaEntity`.
- `roles`: id, `name UNIQUE` (ROLE_*) + 8 أدوار seeded, description. Entity: `RoleJpaEntity`.
- `users`: id, branch_id→branches(SET NULL), full_name, email UNIQUE nullable, phone_number UNIQUE, password_hash, is_active. Entity: `UserJpaEntity`.
- `user_roles`: (user_id→users CASCADE, role_id→roles CASCADE) PK مركبة.
- فهارس: users(phone), users(email), users(branch_id), branches(city).

## 2. الكتالوج catalog (V2+V3 موجود)

- `product_categories`: id, name, slug UNIQUE, description, is_active. → `ProductCategoryJpaEntity`.
- `products`: id, category_id→categories(RESTRICT), name, slug UNIQUE, brand (نص حر حالياً), warranty_years, description, is_active. → `ProductJpaEntity`.
- `product_variants`: id, product_id→products(CASCADE), sku UNIQUE (إلزامي — المعرف), barcode UNIQUE **nullable** (اختياري رسمياً), width_cm, length_cm, height_cm, cost_price/selling_price NUMERIC(12,2), is_active + UQ(product_id,width,length,height). → `ProductVariantJpaEntity`.
- `product_attribute_definitions`: id, name, attribute_key UNIQUE, attribute_type (TEXT/NUMBER/BOOLEAN/SELECT/MULTI_SELECT), is_active.
- `product_attribute_options`: id, attribute_id→definitions(CASCADE), option_value, label, sort_order + UQ(attribute_id,option_value).
- `category_attributes`: id, category_id(CASCADE), attribute_id(RESTRICT), is_required, sort_order + UQ.
- `product_attribute_values`: id, product_id(CASCADE), attribute_id(RESTRICT), value_type, value_text TEXT, value_number NUMERIC(19,4), value_boolean, value_option_id→options(RESTRICT) + UQ(product_id,attribute_id).
- `product_attribute_value_options`: (value_id CASCADE, option_id RESTRICT) للـ MULTI_SELECT.
- `product_presets` + `product_preset_attribute_values (+_options)` + `product_preset_variants` (بلا SKU — قالب فقط).

### مخطط V13__reviews_quiz
- `product_reviews`: id, product_id→products(CASCADE), user_id→users(CASCADE), rating SMALLINT CHECK 1..5, title, body, verified_purchase BOOL (من order_items), status (pending/approved/rejected), helpful_count DEFAULT 0 + UQ(user_id,product_id).
- `quiz_questions`: id, sort_order, text_ar, text_en, is_active.
- `quiz_options`: id, question_id(CASCADE), label_ar/en, scores JSONB (مثال `{"firmness":2,"cooling":-1}`).
- `recommendation_runs`: id, user_id nullable, answers JSONB, results JSONB (top-N + نسب).

## 3. المبيعات sales (مخطط V6)

- `orders`: id, branch_id, customer_id→users nullable, guest_phone nullable (CHECK أحدهما موجود), channel (pos/shop), status (draft/confirmed/preparing/delivering/delivered/returned/cancelled/failed), payment_method (CASH/CARD/COD/TRANSFER/WALLET/INSTALLMENT), payment_status (unpaid/pending_confirmation/paid/partial), subtotal, discount_total, delivery_fee, carry_up_fee, grand_total NUMERIC(12,2), delivery_zone_id, idempotency_key UNIQUE, tracking_number UNIQUE.
- `order_items`: id, order_id(CASCADE), variant_id, qty, unit_price, discount, net NUMERIC, applied_promo_codes TEXT[], is_gift BOOL DEFAULT FALSE + CHECK(qty>0).
- `invoices`: id, order_id UNIQUE, serial (مسلسل لكل فرع/سنة UQ), pdf_path, issued_at.
- `returns`: id, order_id, status, reason, refund_method, Lawson… (refund_amount NUMERIC).
- `reservations`: id, branch_id, customer_id/guest_phone, variant_id, qty, deposit NUMERIC, deliver_at, status (active/fulfilled/expired/cancelled).
- `installment_plans`: id, order_id, total NUMERIC, down_payment, months, monthly_amount + `installments`: (plan_id, due_date, amount, paid_amount, status).
- `cash_shifts`: id, branch_id, cashier_id, opened_at, opening_balance, closed_at, expected_cash, actual_cash, variance + `cash_drops`: (shift_id, amount, at).
- `promotions` + `promotion_bundle_items` (الأنواع الستة — راجع 8.3 arch.md).

## 4. المخازن inventory (مخطط V7) — التفصيل الكامل في `modules/inventory.md`

- `warehouses`: id, branch_id→branches, name, code UNIQUE, is_active.
- `stock_levels`: (warehouse_id, variant_id) UQ, qty, reserved_qty + CHECK(qty>=0).
- `stock_moves`: id, warehouse_id, variant_id, qty_signed (موجب/سالب), move_type, ref_type, ref_id, note, created_by — **لا update للأرصدة إلا عبره**.
- `stock_transfers`: id, from_warehouse, to_warehouse, status (draft/in_transit/partially_received/received/confirmed), + `transfer_items`: (transfer_id, variant_id, sent_qty, received_qty, damaged_qty).
- `stock_audits`: id, warehouse_id, status (open/counting/reconciled), + `audit_counts`: (audit_id, variant_id, system_qty, counted_qty, variance).

## 5. المشتريات purchasing (مخطط V8)

- `suppliers`: id, name, phone, address, tax_id, balance NUMERIC (مستحق), is_active.
- `purchase_orders`: id, supplier_id, branch_id, status (draft/sent/partial/closed/cancelled), total NUMERIC + `po_items`: (po_id, variant_id, qty, unit_cost).
- `goods_receipts`: id, po_id, warehouse_id, received_at, received_by + `receipt_items`: (receipt_id, variant_id, expected_qty, actual_qty, damaged_qty) — كل دفعة سطر استلام مستقل، والفرق يبقى معلقاً على الـ PO.

## 6. العملاء crm (مخطط V9)

- `customer_profiles`: user_id PK→users(CASCADE), governorate, city, segment (new/repeat/vip), referral_source, birth_date nullable.
- `customer_addresses`: id, user_id(CASCADE), label, phone, governorate, address_text, lat/lng nullable, is_default.
- `favorites`: (user_id CASCADE, product_id CASCADE) UQ.
- `warranties`: id, invoice_id→invoices (شهادة لكل فاتورة — قرار), covers_until, status.
- `warranty_claims`: id, warranty_id, status (reported/inspecting/repairing/replaced/closed), inspection_at, resolution, photos TEXT[].

## 7. الموارد hr (مخطط V10) — بلا حضور (قرار)

- `employees`: user_id PK→users(CASCADE), branch_id, job_title, hire_date, base_salary NUMERIC, commission_rule_id, is_active.
- `leave_requests`: id, employee, type, from_date, to_date, substitute, status.
- `commission_rules`: id, name, kind (percent/fixed_per_mattress), value NUMERIC, applies_to_category nullable.
- `advances`: id, employee, amount, remaining, status. `deductions`: id, employee, amount, reason, payroll_run nullable.
- `payroll_runs`: id, branch_id, month, status (draft/approved/paid) + `payroll_lines`: (run_id, employee, base, commission, advances, deductions, net).

## 8. المحاسبة accounting (مخطط V11)

- `chart_of_accounts`: code PK (هرمي: 1xxx أصول...), name_ar/en, type, parent_code, branch_nullable (مراكز تكلفة).
- `journal_entries`: id, branch_id, entry_date, source (SALE/PURCHASE/PAYROLL/MANUAL...), ref, memo + `journal_lines`: (entry_id, account_code, debit, credit NUMERIC) + CHECK(debit=0 XOR credit=0) وتوازن المجموع.
- `treasuries`: id, branch_id, name, balance NUMERIC + `treasury_transfers`: (from,to,amount,at,by).
- `expenses`: id, branch_id, category, amount, receipt_photo, approved_by.
- `checks`: id, direction (in/out), amount, due_date, status (held/cashed/bounced), party.

## 9. التوصيل delivery (مخطط V12)

- `delivery_zones`: id, governorate, area, fee NUMERIC + UQ(governorate,area).
- `carry_up_fees`: id, floor_from, floor_to, fee NUMERIC (seed: 1–2 → 50).
- `vehicles`: id, branch_id, plate UQ, kind, capacity, status.
- `delivery_trips`: id, branch_id, driver_id, vehicle_id, trip_date, status + `trip_stops`: (trip_id, order_id, seq, window, status, proof_photo, fail_reason, delivered_at).

## 10. التحليلات والسلوك واللوجز (V5 مُنفذ: audit_logs + sales_daily_facts — التفصيل في `modules/analytics.md`)

- `sales_daily_facts`: (day, branch_id, variant_id) UQ, qty, revenue, cost, profit NUMERIC — تُغذى incrementally مع كل فاتورة (قرار: لحظي).
- `customer_rfm`: user_id UQ, recency_days, frequency, monetary + segment.
- `product_velocity`: variant_id UQ, sold_30d, days_of_cover.
- `inquiries`: id, branch_id, staff_id, product_id/variant nullable, note, outcome, customer_phone nullable, at — استفسارات المحل (سأل ولم يشترِ).
- `audit_logs`: id, actor_id, branch_id, action, entity, entity_id, before/after JSONB, at — من فعل ماذا.
- `app_events`: id, type, actor/anonymous_id, payload JSONB, at — raw السلوك (retention 90 يوم).
- `idempotency_keys`: key UQ, response_code, response_body (P3).
- خريطة FK: جداول التحليلات read-model بلا FKs صارمة — تُعاد بناؤها عند الحاجة.

## 12. الولاء والمدفوعات والتتبع (V22)

- `loyalty_accounts (user_id PK, points, lifetime_earned)` + `loyalty_ledger (user, order nullable, delta≠0, reason, balance_after)` — الكسب حدثي عند التسليم (idempotent لكل طلب)، والاستبدال خصم عند الإنشاء.
- `payment_intents (order, gateway, amount>0, status: pending/authorized/captured/failed/cancelled/refunded, provider_ref UNIQUE, payload JSONB)` — الكولباك يتحقق من التوقيع أولاً ثم يطبق idempotently.
- `trip_locations (trip, lat/lng, recorded_at)` + `trip_stops.lat/lng` + `driver_ratings (order UNIQUE, driver, 1..5)`.

## 13. المقاسات الخاصة والحجوزات (V24)

- `products.price_per_meter` (أساس تسعير المتر المربع) + `order_items.is_custom/custom_spec` (بدون حجز مخزن).
- `reservations.total/paid_amount` + `reservation_payments (reservation, amount>0, method, paid_at, received_by)`.
- `orders.paid_amount` لدفع البواقي على الطلبات المؤكدة.
- **قاعدة التسعير**: مساحة الشكل (مستطيل/بيضاوي/دائري بالقطر=العرض) × سعر المتر + نسبة تشغيل حسب العرض
  (90-100: 24%، 101-120: 20%، 121-140: 13%، 141-160: 8%، 161-180: 4%، 181-200: 2%، 201-210: 0%، خارجها: 0%).
  بلا حدود دنيا/عليا — أي طول (حتى فوق 205) يُسعّر بنفس نسبة عرضه.

## 11. ترتيب المايجريشنز (محدّث — التنفيذ بدأ بالمخازن أولاً)

V1 (مُصلح: عمود مكرر + DEFAULT) → V2,V3 (موجودة) → **V4 inventory (مُنفذ)** → **V5 analytics: audit_logs + sales_daily_facts (مُنفذ)** →
**V6 sales + V7 audit-cols (مُنفذ)** →
**V8 crm (مُنفذ: profiles/addresses/favorites/warranties/claims)** →
V9 purchasing (مُنفذ) → V10 hr (مُنفذ) → V11 accounting (مُنفذ) → V12 delivery (مُنفذ) →
V13 reviews+quiz (مُنفذ) → V14 inquiries + app_events + idempotency_keys (مُنفذ) →
V15 brands + variant-attrs + seed (مُنفذ) → V16/V17 إصلاحات → V18 Q&A + صور تقييمات (مُنفذ) →
V19 ترجمات + صور منتجات + outbox إشعارات (مُنفذ) → V20 ترجمات الكويز (مُنفذ) → V21 إصلاح audit →
V22 ولاء + مدفوعات + GPS وتقييم سائق (مُنفذ) → V23 إصلاح →
V24 مقاسات خاصة + حجوزات بالأرصدة + دفع جزئي للطلبات (مُنفذ).
