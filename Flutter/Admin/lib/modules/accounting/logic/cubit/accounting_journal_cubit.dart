import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../entity/accounting_enums.dart';
import '../entity/accounting_journal_entry_entity.dart';
import '../usecase/journal_usecases.dart';
import 'accounting_journal_state.dart';

@injectable
final class AccountingJournalCubit extends CubitSignal<AccountingJournalState> {
  AccountingJournalCubit({
    required this._getJournalEntries,
    required this._getJournalEntry,
    required this._postJournalEntry,
  }) : super(initialState: const AccountingJournalState.initial());

  final GetJournalEntriesUsecase _getJournalEntries;
  final GetJournalEntryUsecase _getJournalEntry;
  final PostJournalEntryUsecase _postJournalEntry;

  GetJournalEntriesParams _params = const GetJournalEntriesParams();

  List<AccountingJournalEntryEntity> get _items => switch (state.value) {
    Success(:final items) => items,
    _ => const [],
  };

  Future<void> load({GetJournalEntriesParams? params}) async {
    if (params != null) _params = params;
    emit(const AccountingJournalState.loading());
    final result = await _getJournalEntries.call(_params);
    result.when(
      success: (items) => emit(AccountingJournalState.success(items: items)),
      failure: (error) =>
          emit(AccountingJournalState.failure(message: error.message)),
    );
  }

  /// Fetches one entry on demand; used by the ledger view to open the matching
  /// journal entry (ledger rows can point at entries filtered out of the list).
  Future<AccountingJournalEntryEntity?> fetchEntry(String id) async {
    final result = await _getJournalEntry.call(id);
    return result.when(
      success: (entry) => entry,
      failure: (error) {
        emit(
          AccountingJournalState.success(
            items: _items,
            errorMessage: error.message,
          ),
        );
        return null;
      },
    );
  }

  Future<bool> post({
    required DateTime entryDate,
    required List<AccountingJournalLineInput> lines,
    JournalSource source = JournalSource.manual,
    String? branchId,
    String? reference,
    String? memo,
  }) async {
    emit(AccountingJournalState.success(items: _items, isSaving: true));
    final result = await _postJournalEntry.call(
      PostJournalEntryParams(
        entryDate: entryDate,
        lines: lines,
        source: source,
        branchId: branchId,
        reference: reference,
        memo: memo,
      ),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingJournalState.success(
            items: _items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<void> _refresh() async {
    final result = await _getJournalEntries.call(_params);
    result.when(
      success: (items) => emit(AccountingJournalState.success(items: items)),
      failure: (error) => emit(
        AccountingJournalState.success(
          items: _items,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
