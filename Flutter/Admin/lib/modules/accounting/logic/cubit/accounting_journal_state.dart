import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_journal_entry_entity.dart';

part 'accounting_journal_state.freezed.dart';

@freezed
sealed class AccountingJournalState with _$AccountingJournalState {
  const factory AccountingJournalState.initial() = _Initial;

  const factory AccountingJournalState.loading() = _Loading;

  const factory AccountingJournalState.success({
    required List<AccountingJournalEntryEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = Success;

  const factory AccountingJournalState.failure({required String message}) =
      _Failure;
}
