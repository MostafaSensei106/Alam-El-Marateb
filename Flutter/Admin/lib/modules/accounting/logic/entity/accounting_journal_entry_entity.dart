import 'package:freezed_annotation/freezed_annotation.dart';

import 'accounting_enums.dart';

part 'accounting_journal_entry_entity.freezed.dart';

/// `JournalLineView`
@freezed
sealed class AccountingJournalLineEntity with _$AccountingJournalLineEntity {
  const factory AccountingJournalLineEntity({
    required String accountCode,
    required String accountName,
    required num debit,
    required num credit,
    String? id,
  }) = _AccountingJournalLineEntity;
}

/// `JournalView`
@freezed
sealed class AccountingJournalEntryEntity with _$AccountingJournalEntryEntity {
  const factory AccountingJournalEntryEntity({
    required String id,
    required JournalSource source,
    required List<AccountingJournalLineEntity> lines,
    required num totalDebit,
    required num totalCredit,
    String? branchId,
    DateTime? entryDate,
    String? reference,
    String? memo,
  }) = _AccountingJournalEntryEntity;
  const AccountingJournalEntryEntity._();

  bool get balanced => (totalDebit - totalCredit).abs() < 0.01;
}

/// One debit/credit line posted through `PostJournalRequest.lines`.
@freezed
sealed class AccountingJournalLineInput with _$AccountingJournalLineInput {
  const factory AccountingJournalLineInput({
    required String accountCode,
    required num debit,
    required num credit,
  }) = _AccountingJournalLineInput;
}
