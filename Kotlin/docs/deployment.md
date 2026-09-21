# النشر والتشغيل — v1-backend

## 1. المتطلبات

- JDK 21 + Docker (Postgres 16 + Redis).
- أول إقلاع يطبق Flyway (V1→V8) ثم `AdminSeeder` ينشئ فرع MAIN + سوبر أدمن **مرة واحدة فقط**.

## 2. متغيرات البيئة

| المتغير | الافتراضي | الوصف |
|---|---|---|
| `PORT` | 8080 | بورت التطبيق |
| `DB_URL` | jdbc:postgresql://localhost:5432/mydatabase | اتصال Postgres |
| `DB_USER` / `DB_PASSWORD` | root / root | بيانات الدخول |
| `REDIS_HOST` / `REDIS_PORT` | localhost / 6379 | ريدس |
| `JWT_SECRET` | قيمة تطوير | **يجب تغييره في الإنتاج (≥32 حرف)** |
| `ADMIN_PHONE` | 01000000000 | هاتف السوبر أدمن الأول |
| `ADMIN_PASSWORD` | admin123 | **يُغيَّر فوراً بعد أول دخول** |
| `ADMIN_NAME` | System Admin | اسم الأدمن |
| `EVENTS_TRANSPORT` | in-process | `kafka` للنقل عبر البروكر |
| `KAFKA_BOOTSTRAP` | localhost:9092 | بروكر كافكا |
| `STORAGE_DIR` | ./data/uploads | مجلد الصور المحلي |
| `STORAGE_MAX_MB` | 5 | حد حجم الصورة |
| `STORAGE_BACKEND` | local | `s3` للتخزين السحابي |
| `S3_ENDPOINT/BUCKET/...` | minio محلي | إعدادات S3 |
| `CLICKHOUSE_ENABLED` | false | `true` للتحليلات الثقيلة |
| `CLICKHOUSE_URL/USER/PASSWORD` | localhost:8123 | اتصال ClickHouse |
| `PAYMOB_ENABLED/FAWRY_ENABLED` | false | تفعيل البوابات الحية |
| `PAYMOB_API_KEY/HMAC_SECRET` | - | أسرار Paymob |
| `FAWRY_MERCHANT/SECRET` | - | أسرار Fawry |

## 3. التشغيل محلياً

```bash
docker compose up -d postgres redis
docker compose --profile kafka up -d   # اختياري: نقل الأحداث عبر Kafka
docker compose --profile minio up -d   # S3 للتخزين السحابي (STORAGE_BACKEND=s3)
docker compose --profile clickhouse up -d   # تحليلات ثقيلة (CLICKHOUSE_ENABLED=true)
./gradlew bootRun
```

## 4. التشغيل بالإنتاج (Docker)

```bash
docker build -t alamelmarateb-backend .
docker run -p 8080:8080 \
  -e DB_URL=jdbc:postgresql://<host>:5432/<db> \
  -e DB_USER=... -e DB_PASSWORD=... \
  -e REDIS_HOST=... -e JWT_SECRET='<32+ chars>' \
  -e ADMIN_PHONE=... -e ADMIN_PASSWORD=... \
  alamelmarateb-backend
```

## 5. التحقق بعد النشر

1. `GET /actuator/health` → `{"status":"UP"}`.
2. `POST /api/v1/auth/login` بالأدمن → access + refresh tokens.
3. `GET /api/v1/analytics/summary` بالتوكن → ملخص الداشبورد.
4. Swagger: `/swagger-ui.html` — Postman: `docs/api/postman_collection.json`.

## 6. أول خطوات بعد الدخول

1. غيّر باسورد الأدمن (أنشئ مستخدماً جديداً وعطّل القديم — لا endpoint لتغيير الباسورد بعد، يُضاف مع identity الكامل).
2. أنشئ الفروع (`POST /identity/branches`) والمستخدمين (`POST /identity/access/users`).
3. أنشئ مخزناً لكل فرع (`POST /inventory/warehouses`) ثم الأصناف والمنتجات.

## 7. ملاحظات معروفة لهذه النسخة

- تغيير الباسورد/self-service للمستخدم: غير موجود (P-identity الكامل).
- الدفع الإلكتروني: مؤجل (يدوي فقط). التقارير المتقدمة والـ Quiz: مخططة ولم تُبنَ.
- بيانات تجارب التستات تتراكم في داتابيز التطوير (seed ب Ramdom) — للإنتاج قاعدة نظيفة تُهاجر من V1.
