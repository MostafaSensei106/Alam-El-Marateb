import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

import '../../../shared/enums.dart';
import '../models/finance_models.dart';

/// Admin supplier-finance API layer: shipments, invoices, landed costs.
class FinanceApi {
  FinanceApi(this._dio);

  final Dio _dio;

  static const String shipmentsPath = '/api/v1/purchasing/shipments';
  static const String invoicesPath = '/api/v1/purchasing/supplier-invoices';
  static const String landedBase = '/api/v1/purchasing/landed-costs';

  static String landedCostsPath(String shipmentId) =>
      '/api/v1/purchasing/shipments/$shipmentId/landed-costs';
  static String allocatePath(String invoiceId) =>
      '$invoicesPath/$invoiceId/allocate';
  static String payPath(String invoiceId) => '$invoicesPath/$invoiceId/pay';
  static String statementPath(String supplierId) =>
      '/api/v1/purchasing/suppliers/$supplierId/statement';
  static String finalizePath(String landedCostId) =>
      '$landedBase/$landedCostId/finalize';

  Future<Shipment> createShipment({
    required String supplierId,
    required String shipmentNo,
    String? arrivedAt,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(shipmentsPath, data: <String, dynamic>{
      'supplierId': supplierId,
      'shipmentNo': shipmentNo,
      'arrivedAt': ?arrivedAt,
    }),
    (json) => Shipment.fromJson(json as Map<String, dynamic>),
  );

  Future<SupplierInvoice> createInvoice({
    required String supplierId,
    required String invoiceNo,
    required double total,
    String? issuedAt,
    List<InstallmentInput> installments = const <InstallmentInput>[],
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(invoicesPath, data: <String, dynamic>{
      'supplierId': supplierId,
      'invoiceNo': invoiceNo,
      'total': total,
      'issuedAt': ?issuedAt,
      'installments': installments
          .map(
            (i) => <String, dynamic>{
              'amount': i.amount,
              'dueDate': i.dueDate,
            },
          )
          .toList(),
    }),
    (json) => SupplierInvoice.fromJson(json as Map<String, dynamic>),
  );

  Future<void> allocate({
    required String invoiceId,
    required String shipmentId,
    required double amount,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(allocatePath(invoiceId), data: <String, dynamic>{
      'shipmentId': shipmentId,
      'amount': amount,
    }),
    (_) {},
  );

  Future<SupplierInvoice> pay({
    required String invoiceId,
    required double amount,
    String method = 'CASH',
    String? installmentId,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(payPath(invoiceId), data: <String, dynamic>{
      'amount': amount,
      'method': method,
      'installmentId': ?installmentId,
    }),
    (json) => SupplierInvoice.fromJson(json as Map<String, dynamic>),
  );

  Future<SupplierStatement> statement(String supplierId) => ApiExecutor.call(
    () => _dio.get<dynamic>(statementPath(supplierId)),
    (json) => SupplierStatement.fromJson(json as Map<String, dynamic>),
  );

  Future<LandedCost> addLandedCost({
    required String shipmentId,
    required LandedKind kind,
    required double amount,
    AllocationMethod method = AllocationMethod.byValue,
    bool finalCost = false,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      landedCostsPath(shipmentId),
      data: <String, dynamic>{
        'kind': kind.value,
        'amount': amount,
        'allocationMethod': method.value,
        'final': finalCost,
      },
    ),
    (json) => LandedCost.fromJson(json as Map<String, dynamic>),
  );

  Future<LandedCost> finalizeLandedCost({
    required String landedCostId,
    required double finalAmount,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(
      finalizePath(landedCostId),
      data: <String, dynamic>{'finalAmount': finalAmount},
    ),
    (json) => LandedCost.fromJson(json as Map<String, dynamic>),
  );

  Future<List<LandedCost>> landedCosts(String shipmentId) => ApiExecutor.call(
    () => _dio.get<dynamic>(landedCostsPath(shipmentId)),
    (json) => (json as List)
        .map((e) => LandedCost.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
