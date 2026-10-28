import 'package:freezed_annotation/freezed_annotation.dart';

import 'accounting_enums.dart';

part 'accounting_ledger_line_entity.freezed.dart';

/// `LedgerLineView`
@freezed
sealed class AccountingLedgerLineEntity with _$AccountingLedgerLineEntity {
  const factory AccountingLedgerLineEntity({
    required JournalSource source,
    required String accountCode,
    required String accountName,
    required num debit,
    required num credit,
    required num runningBalance,
    String? entryId,
    DateTime? entryDate,
    String? reference,
  }) = _AccountingLedgerLineEntity;
}
