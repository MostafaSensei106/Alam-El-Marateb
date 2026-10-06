import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../../../shared/enums.dart';
import '../models/pos_models.dart';

/// Staff POS API layer: scan → ticket → complete sale + shifts.
class PosApi {
  PosApi(this._dio);

  final Dio _dio;

  static const String scanPath = '/api/v1/sales/pos/scan';
  static const String draftPath = '/api/v1/sales/pos/orders/draft';
  static const String completeSalePath = '/api/v1/sales/pos/complete-sale';
  static const String shiftCurrentPath =
      '/api/v1/sales/pos/drawer/shift/current';
  static const String shiftOpenPath = '/api/v1/sales/pos/drawer/shift/open';
  static const String shiftClosePath = '/api/v1/sales/pos/drawer/shift/close';
  static const String shiftDropPath = '/api/v1/sales/pos/drawer/shift/drop';

  Future<ScannedItem> scan(String barcode) => ApiExecutor.call(
    () => _dio.get<dynamic>('$scanPath/$barcode'),
    (json) => ScannedItem.fromJson(json as Map<String, dynamic>),
  );

  Future<CompletedOrder> completeSale({
    required List<TicketLine> lines, required PaymentMethod paymentMethod, String? branchId,
    String? guestPhone,
    double paidAmount = 0,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      completeSalePath,
      data: <String, dynamic>{
        'branchId': ?branchId,
        'guestPhone': ?guestPhone,
        'items': lines
            .map(
              (l) => <String, dynamic>{'variantId': l.variantId, 'qty': l.qty},
            )
            .toList(),
        'paymentMethod': paymentMethod.value,
        if (paidAmount > 0) 'paidAmount': paidAmount,
      },
    ),
    (json) => CompletedOrder.fromJson(json as Map<String, dynamic>),
  );
}
