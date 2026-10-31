import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_journal_entry_entity.dart';

part 'accounting_journal_state.freezed.dart';

@freezed
sealed class AccountingJournalState with _$AccountingJournalState {
  const factory AccountingJournalState.initial() = AccountingJournalInitial;

  const factory AccountingJournalState.loading() = AccountingJournalLoading;

  const factory AccountingJournalState.success({
    required List<AccountingJournalEntryEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = AccountingJournalSuccess;

  const factory AccountingJournalState.failure({required String message}) = AccountingJournalFailure;
}
