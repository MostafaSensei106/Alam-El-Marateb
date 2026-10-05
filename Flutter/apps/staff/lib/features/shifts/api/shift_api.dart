import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';

/// Cashier shift API layer.
class ShiftApi {
  ShiftApi(this._dio);

  final Dio _dio;

  static const String currentPath =
      '/api/v1/sales/pos/drawer/shift/current';
  static const String openPath = '/api/v1/sales/pos/drawer/shift/open';
  static const String closePath = '/api/v1/sales/pos/drawer/shift/close';
  static const String dropPath = '/api/v1/sales/pos/drawer/shift/drop';

  Future<CashShift?> current() => ApiExecutor.call(
    () => _dio.get<dynamic>(currentPath),
    (json) => json == null
        ? null
        : CashShift.fromJson(json as Map<String, dynamic>),
  );

  Future<CashShift> open({
    required String branchId,
    required double openingBalance,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(openPath, data: <String, dynamic>{
      'branchId': branchId,
      'openingBalance': openingBalance,
    }),
    (json) => CashShift.fromJson(json as Map<String, dynamic>),
  );

  Future<CashShift> close({
    required String shiftId,
    required double actualCash,
  }) => ApiExecutor.call(
    () => _dio.post<dynamic>(closePath, data: <String, dynamic>{
      'shiftId': shiftId,
      'actualCash': actualCash,
    }),
    (json) => CashShift.fromJson(json as Map<String, dynamic>),
  );

  Future<void> drop({required String shiftId, required double amount}) =>
      ApiExecutor.call(
        () => _dio.post<dynamic>(dropPath, data: <String, dynamic>{
          'shiftId': shiftId,
          'amount': amount,
        }),
        (_) {},
      );
}

/// Cash drawer shift view.
class CashShift {
  const CashShift({
    this.id,
    this.branchId,
    this.status = 'open',
    this.openingBalance = 0,
    this.expectedCash,
    this.actualCash,
    this.variance,
  });

  factory CashShift.fromJson(Map<String, dynamic> json) => CashShift(
    id: json['id']?.toString(),
    branchId: json['branchId']?.toString(),
    status: json['status']?.toString() ?? 'open',
    openingBalance: _money(json['openingBalance']),
    expectedCash: json['expectedCash'] == null
        ? null
        : _money(json['expectedCash']),
    actualCash: json['actualCash'] == null
        ? null
        : _money(json['actualCash']),
    variance: json['variance'] == null ? null : _money(json['variance']),
  );

  final String? id;
  final String? branchId;
  final String status;
  final double openingBalance;
  final double? expectedCash;
  final double? actualCash;
  final double? variance;
}

double _money(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};
