# تخطيط موديول التحليلات analytics (v2 — تفصيلي)

> **الحالة: مُنفذ جزئياً** — ملخص تنفيذي + سرعة منتجات + سجل تدقيق (شغال ومُختبر).
> الإيراد/RFM والباقي مع موديول المبيعات. التفصيل الكامل للرؤية في الأسفل.

> P7. المبدأ: أي حاجة تحصل على السيستم تتسجل — بيع، تصفح، سؤال في المحل، حركة مخزن.
> لا تحليل بدون حدث مسجل، ولا حدث بدون مستهلك.

## 1. أنواع الأحداث (Event taxonomy)

### أ) أحداث بيزنس (من السيرفسز — مضمونة 100%)
`OrderPlaced/Paid/Cancelled/Returned`, `PromotionApplied`, `StockMoved/Adjusted`, `WarrantyClaimed`,
`DeliveryDone/Failed`, `PayrollApproved`, `InquiryLogged`, `ReviewSubmitted`, `QuizCompleted`.

### ب) أحداث سلوكية (من الفرونت — beacon)
`PageViewed`, `ProductViewed`, `SearchPerformed (query+filters+results_count)`, `FilterUsed`,
`CartAbandoned`, `FavoriteAdded`, `QuizStarted/QuestionAnswered`, `CheckoutStepViewed`.
- endpoint واحد: `POST /analytics/events` (دفعة events + consent flag) → يُقبل دائماً 202 ولا يُعطّل تجربة المستخدم أبداً.
- الضيوف: `anonymous_id` (كوكي) + ربطه بالحساب عند التسجيل (identity stitching).

### ج) استفسارات المحل (كم حد جه سأل؟)
زرار "سؤال سريع" في شاشة المعرض: `inquiries (branch_id, product_id/variant nullable + free_text, staff_id, outcome: bought_later/no_stock/price/just_asking, at)`.
- تُقاس: أكثر منتج يُسأل عنه ولا يُشترى ← إشارة سعر/مخزون/تسويق. تُربط بالبيع لاحقاً (نفس رقم الموبايل).

## 2. ماذا نعرف من الداتا (مصفوفة الأسئلة ← المصدر)

| السؤال | المصدر |
|---|---|
| فترات الشراء (ساعة/يوم/شهر) | `orders.placed_at` + `sales_daily_facts` |
| المواسم | تجميع شهري + مقارنة سنوية + وسوم حملات |
| المناطق (محافظة/منطقة) | `delivery_zones` + عناوين العملاء + heatmap |
| سأل ولم يشترِ (محل + متجر) | `inquiries` + `SearchPerformed` بلا نقرة + `CartAbandoned` |
| تفضيل الخامات/الصلابة | قيم EAV في `order_items` ← variant attributes |
| رحلة العميل الكاملة | stitching: beacon events + orders + claims + reviews |

## 3. نظام اللوجز الشامل (3 طبقات)

1. **Audit log (من فعل ماذا)**: جدول `audit_logs (actor_id, action, entity, entity_id, before/after JSONB, branch_id, at)` —
   يُكتب من السيرفسز للعمليات الحساسة (طلبات، مخزن، مرتبات، صلاحيات). للقراءة من الداشبورد.
2. **Application logs (تشخيص)**: Logback بصيغة JSON (`logstash-logback-encoder`) + `traceId` في MDC
   (نفس `traceId` الرد — §7 في api-status.md) + Micrometer Tracing للربط بين الطلبات.
3. **Metrics (صحة وأداء)**: Micrometer + Prometheus + Grafana (زمن الاستجابة، أخطاء 5xx، طول الطوابير، hit rate الكاش).

## 4. التقنيات الموصى بها — أين تُستخدم

| التقنية | الاستخدام | الموديولز |
|---|---|---|
| **Spring Modulith** | أحداث الدومين بين الموديولز + سجل نشر مضمون + رسم الموديولز تلقائياً | كل الموديولز (بديل الاستدعاء المباشر) |
| **Kafka** | بث الأحداث (بيزنس + سلوك) → مستهلكون يبنون الـ facts؛ فصل النشر عن التحليل | sales, analytics, crm |
| **Redis** | عدادات لحظية (داشبورد real-time)، كاش المنتجات والأسعار، rate limiting، سلات الضيوف، idempotency keys | catalog, sales, analytics |
| **Postgres (facts)** | `sales_daily_facts`, `customer_rfm`, `product_velocity`, `search_funnel`, `inquiry_conversion` — تُبنى incrementally مع كل حدث (قرار: لحظي) | analytics |
| **Caffeine** | كاش محلي للثوابت (الأدوار، المناطق، الأسئلة) | core |
| (لاحقاً) ClickHouse | تحليلات ثقيلة عندما تكبر الداتا | analytics |

- القاعدة: حدث البيع يُنشر عبر Modulith/Kafka **في نفس ترانزكشن الطلب** (outbox pattern) — لا ضياع.
- الـ beacon السلوكي: Kafka topic منفصل بretention قصير + تجميع دوري — لا يؤثر على البيع لو وقع.

## 5. الجداول الجديدة (تُضاف لـ V14/V15)

- `inquiries`: id, branch_id, staff_id, product_id nullable, variant_id nullable, note, outcome, customer_phone nullable, at.
- `audit_logs`: id, actor_id, branch_id, action, entity, entity_id, before/after JSONB, at + فهرس (entity, entity_id).
- `app_events`: id, type, actor/anonymous_id, payload JSONB, at — raw landing للسلوك قبل التجميع (retention 90 يوم).
- `idempotency_keys`: key UQ, response_code, response_body, created_at (P3).

## 6. الخصوصية (إلزامي)

- موافقة صريحة على التتبع السلوكي (consent banner) + إيقاف كامل بضغطة.
- تقليل PII: الهواتف مُجزأة في التحليلات، الـ raw يُمسح بعد 90 يوم، الحق في المسح GDPR-style.
- سجلات الـ audit للموظفين تُعرض لهم (شفافية) — ما يُسجل عنك تراه.

## 7. قرارات محسومة (من النقاش)

1. **الأرقام لحظية** — facts تُبنى incrementally مع كل فاتورة/حدث.
2. **التقارير**: تلقائية دورية + تصدير عند الطلب.
