# تخطيط موديول المخازن والمشتريات inventory + purchasing (v2 — تفصيلي)

> **الحالة: مُنفذ ومُختبر** (entities/services/controllers + تست دورة كاملة أخضر ضد Postgres حقيقي).
> P4. القاعدة: لا رصيد يُعدل مباشرة — كل حركة سطر في `stock_moves`، والرصيد مُشتق.
> التفصيل الكامل للجداول في `docs/database.md` (§4 و§5)، والـ endpoints في `docs/api.md`.

## 1. المخازن والفروع (قرار: فروع مستقلة بتحويلات مباشرة)

- `warehouses`: كل فرع مخزن واحد على الأقل (`branch_id`)؛ التحويل يتم فرع↔فرع مباشرة بلا مركزي.
- `stock_levels`: سطر لكل (مخزن × متغير): `qty` المتاح + `reserved_qty` للمحجوز (طلبات مؤكدة لم تُسلّم).
- البحث والعدّ بـ SKU أو الاسم أو الباركود (اختياري) — `GET /warehouse/stocks/lookup/{barcodeOrSku}`.

## 2. التحويل بين المخازن — دورة كاملة خطوة بخطوة

الحالة: `draft → in_transit → (partially_received) → received → confirmed`. البضاعة **في الطريق** تظهر في تقرير "بضاعة بالطريق" ولا تُحسب لرصيد أي مخزن.

| # | الفاعل | الفعل (route) | أثر الداتابيز | الكود |
|---|---|---|---|---|
| 1 | مدير المصدر | إنشاء تحويل مسودة `POST /inventory/transfers` (من، إلى، سطور variant×qty) | `stock_transfers(draft)` + `transfer_items(sent_qty, received=0)` | `TransferController` → `TransferService.create` |
| 2 | مدير المصدر | ترحيل `POST /transfers/{id}/dispatch` | الحالة `in_transit` + `stock_moves` سالبة من المصدر (TRANSFER_OUT) + حجز من `stock_levels` | `dispatch()` — تنقص المصدر فوراً |
| 3 | سائق/نظام | البضاعة في الطريق (تُعرض للفرعين) | لا رصيد لأحد — تُقرأ من `transfers(in_transit)` | استعلام "in-transit" |
| 4 | أمين المقصد | استلام **على دفعات** `POST /warehouse/transfers/{id}/confirm-receipt {items:[{variant,actual_qty,damaged}]}` | كل دفعة: `transfer_items.received_qty +=` + `stock_moves` موجبة للمقصد (TRANSFER_IN)؛ التالف يُسجل `damaged_qty` **معلق** | `receiveBatch()` — تُستدعى لكل دفعة حتى اكتمال الكمية |
| 5 | النظام | اكتمال كل الكميات → `received` (أو `partially_received` لو بقي معلق) | — | — |
| 6 | مدير المقصد | اعتماد الفروق `POST /transfers/{id}/confirm` (التالف المعتمد → `stock_moves` DAMAGED؛ الناقص → مطالبة) | الحالة `confirmed` — تُقفل نهائياً ولا تعديل بعدها | `confirm()` — قرار: التالف باعتماد مدير |

## 3. استلام المشتريات على دفعات

- أمر الشراء `purchase_orders` يُستلم على **عدة دفعات**: كل دفعة `goods_receipts` + `receipt_items(expected vs actual vs damaged)`.
- كل دفعة تولّد `stock_moves` (PURCHASE) فورياً للمخزن المستلم؛ المتبقي يبقى معلقاً على الـ PO (`partial`).
- إغلاق الـ PO عند اكتمال الكمية أو إلغاء الباقي بقرار مدير.

## 4. الجرد — دورة كاملة

1. مدير يفتح جرد `POST /inventory/audits` (مخزن + نطاق: كلي/أصناف) → `stock_audits(open)` مع `system_qty` لكل سطر.
2. الأمين يعدّ بالسكان `POST /warehouse/audits/{id}/count {variant, counted_qty}` → سطور `audit_counts` + `variance` تُحسب فوراً وتُعرض.
3. المدير يراجع الفروق ويعتمد `POST /audits/{id}/reconcile` → الفروق المعتمدة تولّد `stock_moves` (AUDIT) + الحالة `reconciled` (نهائية).
4. فروق فوق حد معين → تنبيه تحقيق (nice-to-have: workflow).

## 5. التوالف والهالك (قرار: تسجيل أمين + اعتماد مدير)

- التسجيل (من استلام/جرد/بلاغ): `damaged_qty` + سبب + صور → حالة **معلقة** لا تمس الرصيد.
- الاعتماد: `stock_moves` سالبة (DAMAGE) + خصم من `stock_levels`؛ الرفض: تُشطب واسترجاع للرصيد المتاح.

## 6. المشتريات (ملخص — التفصيل في database.md §5)

`suppliers` → `purchase_orders (+items)` → `goods_receipts` دفعات → `stock_moves` → إغلاق/إلغاء.
اقتراح أمر شراء تلقائي من تنبيه النواقص (nice-to-have).

## 7. التنبيهات (قرار: حد ديناميكي من سرعة البيع)

- الحد = متوسط بيع يومي (من `product_velocity`) × أيام التغطية (افتراضي 14) — يُعاد حسابه ليلياً.
- `low_stock_alerts` في الداشبورد + المدير يقدر يثبّت حداً يدوياً يتجاوز المحسوب.

## 8. خريطة الكود (ماذا يُبنى أين)

| المكون | المسار |
|---|---|
| Entities | `modules/inventory/domain/entity/` (Warehouse, StockMove, Transfer+Item, Audit+Count) |
| Repositories | `modules/inventory/data/repository/` (Spring Data) |
| Services | `TransferService` (dispatch/receiveBatch/confirm), `AuditService` (open/count/reconcile), `StockQueryService` (lookup/levels/in-transit) |
| Controllers | `InventoryAdminController` (`/inventory`) + `WarehouseOpsController` (`/warehouse`) |
| Events صادرة | `GoodsReceived`, `TransferConfirmed`, `StockAdjusted` → المحاسبة (قيود) والتحليلات (facts) |

## 9. قرارات محسومة (من النقاش)

1. **الهيكل**: فروع مستقلة بتحويلات مباشرة بينها — لا مخزن مركزي.
2. **التوالف**: تسجيل من الأمين + اعتماد مدير قبل الخصم.
3. **حد النواقص**: ديناميكي من سرعة البيع (يُحسب تلقائياً، والمدير يقدر يتجاوزه).
