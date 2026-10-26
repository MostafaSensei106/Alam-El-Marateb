import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:injectable/injectable.dart';

import '../usecase/get_balance_sheet_usecase.dart';
import 'accounting_balance_sheet_state.dart';

@injectable
final class AccountingBalanceSheetCubit
    extends CubitSignal<AccountingBalanceSheetState> {
  AccountingBalanceSheetCubit({
    required this._getBalanceSheetUsecase,
    required super.initialState,
  });
  final GetBalanceSheetUsecase _getBalanceSheetUsecase;

  Future<void> getBalamceSheet({required String to}) async {
    emit(const AccountingBalanceSheetState.loading());
    final result = await _getBalanceSheetUsecase.call(to);
    result.when(
      success: (s) => AccountingBalanceSheetState.success(data: s),
      failure: (e) => AccountingBalanceSheetState.failure(message: e.message),
    );
  }
}
