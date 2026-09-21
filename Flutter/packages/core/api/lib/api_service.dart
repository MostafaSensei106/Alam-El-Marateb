/// Typed Retrofit clients for the `/api/v1` backend.
///
/// Re-exports the network kernel plus every API interface and DTO.
/// Regenerate with:
/// `dart run build_runner build --delete-conflicting-outputs`
library;

export 'package:core_network/core_network.dart';

export 'src/api_module.dart';
export 'src/api_routes.dart';
export 'src/generated/auth_api.dart';
export 'src/generated/catalog_api.dart';
export 'src/generated/crm_api.dart';
export 'src/generated/delivery_api.dart';
export 'src/generated/estimator_api.dart';
export 'src/generated/inventory_api.dart';
export 'src/generated/models/auth_dto.dart';
export 'src/generated/models/crm_dto.dart';
export 'src/generated/models/delivery_dto.dart';
export 'src/generated/models/estimator_dto.dart';
export 'src/generated/models/inventory_dto.dart';
export 'src/generated/models/order_dto.dart';
export 'src/generated/models/pos_dto.dart';
export 'src/generated/models/product_dto.dart';
export 'src/generated/models/sales_dto.dart';
export 'src/generated/pos_api.dart';
export 'src/generated/shop_api.dart';
