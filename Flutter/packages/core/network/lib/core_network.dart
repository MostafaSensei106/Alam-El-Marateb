/// Shared networking kernel for Alam El Marateb apps.
///
/// Dio + interceptors + typed errors, mirroring the Hadidi-Win
/// `core/networking` architecture but targeting the new backend
/// (`/api/v1`, [ApiResponse] envelope, `X-Lang`, `Idempotency-Key`,
/// `X-Trace-Id`, ETag conditional GET).
library core_network;

export 'src/api_exception.dart';
export 'src/api_executor.dart';
export 'src/api_response.dart';
export 'src/dio_client.dart';
export 'src/interceptors/auth_interceptor.dart';
export 'src/interceptors/etag_interceptor.dart';
export 'src/interceptors/idempotency_interceptor.dart';
export 'src/interceptors/lang_interceptor.dart';
export 'src/interceptors/logging_interceptor.dart';
export 'src/network_info.dart';
export 'src/request_deduplicator.dart';
