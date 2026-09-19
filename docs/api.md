# كتالوج الـ API — تفصيلي (v1)

> كل endpoint: الميثود + المسار + الدور + الكنترولر/السيرفس + أهم حقول الطلب/الرد.
> `(موجود)` = كود شغال. `(مخطط Pn)` = يُبنى في مرحلته. `(يُحذف)` = ملغى بقرار.

## Catalog — إدارة (BRANCH_MANAGER)

| الميثود والمسار | الحالة | الدور/الملاحظة |
|---|---|---|
| GET/POST `/catalog/products` + GET/PUT/DELETE `/catalog/products/{id}` | موجود | `ProductAdminController` — POST تُرجع 201 + `@Valid` |
| POST `/catalog/products/from-preset/{presetId}` | موجود | نسخ كل مقاسات القالب |
| POST `/catalog/products/quick-create` | مخطط P2 | قالب + مقاس واحد (§8.1 arch.md) |
| CRUD `/catalog/categories[/{id}]` + PUT `/catalog/categories/{id}/attributes` | موجود | ربط الصفات |
| CRUD `/catalog/attributes[/{id}]` + POST/DELETE `/catalog/attributes/{id}/options[/{optionId}]` | موجود | |
| CRUD `/catalog/presets[/{id}]` | موجود | |

## Catalog — متجر عام (بدون auth للـ GET)

| الميثود والمسار | الحالة |
|---|---|
| GET `/catalog/public/products` + `?category&brand&minPrice&maxPrice&rating` | موجود (الفلاتر تُستكمل P2) |
| GET `/catalog/public/products/search?q=` + GET `/featured` + GET `/compare?ids=` | مخطط P2 |
| GET `/catalog/public/products/{slug}` + GET `/{id}/variants` | موجود (الأولى) / مخطط |
| GET `/catalog/public/categories` + GET `/catalog/public/products/{slug}/reviews` | مخطط P2 |

## Sales — POS (CASHIER)

| الميثود والمسار | الحالة |
|---|---|
| GET `/sales/pos/scan/{barcode}` | مخطط P3 (بحث SKU/باركود/اسم) |
| POST `/sales/pos/orders/draft` + POST `/complete-sale` + POST `/place-order` + POST `/custom-order` | مخطط P3 (idempotency_key إجباري) |
| GET `/sales/pos/orders/{orderId}/receipt` + GET `/invoice-pdf` + POST `/{orderId}/return` | مخطط P3 |
| GET/POST `/sales/pos/drawer/shift/current|open|close` + POST `/drop` | مخطط P3 |
| GET `/sales/orders` + GET `/sales/orders/{orderId}` + POST `/{id}/confirm-payment` (مدير) | مخطط P3 |
| GET/POST `/sales/promotions` + POST `/{id}/toggle` (مدير فقط) | مخطط P3 |

## Shop — عميل (CUSTOMER)

| الميثود والمسار | الحالة |
|---|---|
| GET/POST `/shop/cart` + POST `/items` + PUT/DELETE `/items/{itemId}` + POST `/merge|clear` | مخطط P3 |
| POST `/shop/checkout/estimate-shipping` (منطقة+دور ← رسوم) + POST `/place-order` | مخطط P3 |
| POST `/shop/checkout/price-preview` | مخطط P3 (الحسبة قبل الدفع) |
| GET `/shop/orders` + GET `/{orderId}` + GET `/track/{trackingNumber}` | مخطط P3 |

## CRM + Portal

| الميثود والمسار | الدور | الحالة |
|---|---|---|
| CRUD `/crm/customers` | مدير | مخطط P5 |
| GET `/crm/warranties` + GET `/{serial}` + claims + `/inspection|replace|repair` | مدير | مخطط P5 |
| GET/POST `/portal/addresses` + PUT/DELETE `/{addressId}` | عميل | مخطط P5 |
| POST `/portal/warranties/register` + GET `/verify/{serialNumber}` + GET `/claims` | عميل | مخطط P5 |
| GET/POST `/portal/favorites` + DELETE `/{productId}` | عميل | مخطط P5 |
| POST `/portal/reviews` + GET عام + PUT `/crm/reviews/{id}/moderate` | عميل/مدير | مخطط P2 |

## Inventory + Purchasing + Warehouse

| الميثود والمسار | الدور | الحالة |
|---|---|---|
| CRUD `/inventory/warehouses` + GET `/stocks` + GET `/low-alerts` | مدير | مخطط P4 |
| POST `/inventory/transfers` + POST `/{id}/dispatch` + GET `/audits` + POST `/{auditId}/reconcile` | مدير/أمين | مخطط P4 (التفصيل في `modules/inventory.md`) |
| GET `/warehouse/stocks/lookup/{barcodeOrSku}` + POST `/adjustment` | أمين | مخطط P4 |
| GET `/warehouse/transfers/pending` + POST `/{id}/confirm-receipt` (دفعات) + POST `/audits/{id}/count` | أمين | مخطط P4 |
| CRUD `/purchasing/suppliers` + CRUD `/purchase-orders` + POST `/{id}/receive` (دفعة) | مدير | مخطط P4 |

## HR (بلا حضور — قرار) + Self + Accounting + Delivery + Analytics + Identity

| الميثود والمسار | الدور | الحالة |
|---|---|---|
| CRUD `/hr/employees` + GET `/attendance/logs` ← **يُحذف** (لا حضور) | مدير | مخطط P6 |
| GET/POST `/hr/leaves` + POST `/{id}/action` + commissions/advances/deductions + payroll calculate/approve/export | مدير | مخطط P6 |
| `/me/attendance/*` ← **يُحذف**؛ يبقى `/me/leaves/request|commissions|payslips` (موظف) | أي موظف | مخطط P6 |
| `/accounting/*` (شجرة/قيود/خزن/مصاريف/شيكات/تقارير) | ACCOUNTANT | مخطط P6 |
| `/delivery/my-trips|trips|stops|orders` | DELIVERY_DRIVER | مخطط P5 |
| `/analytics/summary`, `/product-velocity`, `/audit-trail/...` | BRANCH_MANAGER | **موجود** |
| باقي `/analytics/*` (إيراد، RFM، فروع...) | BRANCH_MANAGER | مخطط (مع المبيعات) |
| `/auth/**` (عام) + `/identity/branches|access|fleet` | مدير | مخطط P7 (الـ auth موجود جزئياً) |

## قواعد الردود الموحدة

- النجاح: `ApiResponse{success,message,data}` عبر `BaseController` (201 للإنشاء).
- القوائم الكبيرة: `PagedResponse{items,page,size,totalElements,totalPages}` + `Pageable`.
- الأخطاء: `GlobalExceptionHandler` (400 تحقق/404 NotFoundException/409 تعارض).
- الفلوس: BigDecimal برقمين عشريين دائماً (§10 arch.md).
