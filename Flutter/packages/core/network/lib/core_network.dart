/// Shared networking: Dio factory, backend contract envelope, error mapping.
library;

export 'src/api_executor.dart';
export 'src/api_response.dart';
export 'src/dio_factory.dart';
export 'src/error/api_error_handler.dart';
export 'src/error/api_error_model.dart';
export 'src/error/error_type.dart';
export 'src/error/failures.dart';
export 'src/headers.dart';
export 'src/interceptors/auth_token_interceptor.dart';
export 'src/interceptors/client_key_interceptor.dart';
export 'src/interceptors/connectivity_retry_interceptor.dart';
export 'src/interceptors/locale_interceptor.dart';
export 'src/network_config.dart';
export 'src/network_info/interface/base_network_info.dart';
export 'src/network_info/network_info.dart';
export 'src/request_deduplicator.dart';
export 'src/token_storage.dart';
