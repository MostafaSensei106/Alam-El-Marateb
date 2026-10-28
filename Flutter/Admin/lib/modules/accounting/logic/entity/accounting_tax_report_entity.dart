import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_tax_report_entity.freezed.dart';

/// `TaxReportView`
@freezed
sealed class AccountingTaxReportEntity with _$AccountingTaxReportEntity {
  const factory AccountingTaxReportEntity({
    required DateTime from,
    required DateTime to,
    required num revenueInclusive,
    required num vatPortion,
    required num purchasesInclusive,
    required num inputVat,
    required num netVatPayable,
  }) = _AccountingTaxReportEntity;
}
