# تخطيط موديول المبيعات sales (v2 — تفصيلي)

> **الحالة: مُنفذ ومُختبر** (طلبات + سلة + خصومات + تقسيط + حجوزات + شفتات + `OrderFlowTest` و`PromotionEngineTest` خضر).
> أول revenue path. التفاصيل الكاملة للجداول في `docs/database.md` (§3)، والـ endpoints في `docs/api.md`.

> أول revenue path. يشمل: POS المعرض + متجر العميل + دورة الطلب + المرتجعات + شفتات الدرج + الخصومات + التقسيط + الحجوزات.

## 1. دورة الطلب (Order lifecycle)

```
draft → confirmed → preparing → delivering → delivered
   ↓         ↓           ↓
cancelled  returned   failed_delivery → rescheduled
```

- **POS**: draft سريع → complete-sale (دفع فوري) أو place-order (توصيل لاحق).
- **المتجر**: cart → checkout (ضيف برقم موبايل أو عميل) → place-order بحالة `confirmed` + دفع `COD` أو `TRANSFER/WALLET` بحالة `pending_confirmation` يؤكدها المدير يدوياً (§9 في ux.md).
- **الحجز**: طلب `reserved` بميعاد تسليم + عربون اختياري — يُغذي المتابعة.

## 2. الجداول (تفصيل §4.3 في arch.md)

- `orders`: branch_id, customer_id/user nullable + guest_phone, channel (pos/shop), status, payment_method (CASH/CARD/COD/TRANSFER/WALLET/INSTALLMENT؟), payment_status, subtotal, discount_total, delivery_fee, grand_total (كلها NUMERIC — §10 arch.md)، idempotency_key.
- `order_items`: variant_id, qty, unit_price, discount, net, applied_promo_codes[], is_gift.
- `invoices`: رقم مسلسل لكل فرع/سنة + PDF.
- `returns`: order_id, items, reason, status, refund_method.
- `cash_shifts`: open/close, opening_balance, drops, expected vs actual + الفرق.
- `reservations`: order_id أو مستقلة؟ (سؤال أدناه).

## 3. التكامل مع الخصومات (§8.3)

- الـ POS يعرض نفس حسبة price-preview قبل إتمام البيع (خصم سطر/فاتورة/بندل/هدية).
- الهدية سطر `is_gift` بسعر صفر في الفاتورة المطبوعة.
- `used_count` للبرومو يزيد عند تأكيد الطلب فقط (لا عند الـ draft).

## 4. الـ APIs

موجودة روتسها: POS (سكان/مسودة/إتمام/مرتجع/إيصال/شفتات)، shop (سلة/دفع/طلباتي/تتبع)، promotions (إدارة + preview).
مخطط إضافي: تأكيد تحويل يدوي `POST /sales/orders/{id}/confirm-payment` (مدير)، إلغاء، إعادة جدولة تسليم.

## 5. Must-have مقابل Nice-to-have

**Must**: دورة الطلب أعلاه + ضيوف + تأكيد يدوي + مرتجعات + شفتات + فاتورة PDF + idempotency.
**Nice**: تقسيط داخلي، نقاط ولاء، "اطلب والمخزن يجهز" (click & collect)، دفع جزئي/عربون أونلاين.

## 6. قرارات محسومة (من النقاش)

1. **التقسيط الداخلي**: موجود من P3 — دفعات على الطلب (`installment_plans` + أقساط وحالاتها).
2. **الحجوزات**: جدول مستقل `reservations` (ميعاد تسليم + عربون اختياري) مرتبط بالعميل والفرع.
3. **Click & collect**: متاح من الأول — الطلب الأونلاين يتيح الاستلام من الفرع.
