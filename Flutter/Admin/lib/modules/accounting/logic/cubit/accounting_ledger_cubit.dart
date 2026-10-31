import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../entity/accounting_ledger_line_entity.dart';
import '../usecase/ledger_usecases.dart';
import 'accounting_ledger_state.dart';

@injectable
final class AccountingLedgerCubit extends CubitSignal<AccountingLedgerState> {
  AccountingLedgerCubit({required this._getGeneralLedger})
    : super(initialState: const AccountingLedgerState.initial());

  final GetGeneralLedgerUsecase _getGeneralLedger;

  GetGeneralLedgerParams _params = const GetGeneralLedgerParams();

  List<AccountingLedgerLineEntity> get items => switch (state.value) {
    AccountingLedgerSuccess(:final items) => items,
    _ => const [],
  };

  Future<void> load({GetGeneralLedgerParams? params}) async {
    if (params != null) _params = params;
    emit(const AccountingLedgerState.loading());
    final result = await _getGeneralLedger.call(_params);
    result.when(
      success: (items) => emit(AccountingLedgerState.success(items: items)),
      failure: (error) =>
          emit(AccountingLedgerState.failure(message: error.message)),
    );
  }
}
