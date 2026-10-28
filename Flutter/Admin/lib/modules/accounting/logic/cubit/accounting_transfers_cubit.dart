import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../entity/accounting_transfer_entity.dart';
import '../usecase/transfer_usecases.dart';
import 'accounting_transfers_state.dart';

@injectable
final class AccountingTransfersCubit
    extends CubitSignal<AccountingTransfersState> {
  AccountingTransfersCubit({
    required this._getTransfers,
    required this._createTransfer,
  }) : super(initialState: const AccountingTransfersState.initial());

  final GetTransfersUsecase _getTransfers;
  final CreateTransferUsecase _createTransfer;

  String? _treasuryId;

  List<AccountingTransferEntity> get items => switch (state.value) {
    AccountingTransfersSuccess(:final items) => items,
    _ => const [],
  };

  Future<void> load({String? treasuryId}) async {
    _treasuryId = treasuryId;
    emit(const AccountingTransfersState.loading());
    final result = await _getTransfers.call(
      GetTransfersParams(treasuryId: treasuryId),
    );
    result.when(
      success: (items) => emit(AccountingTransfersState.success(items: items)),
      failure: (error) =>
          emit(AccountingTransfersState.failure(message: error.message)),
    );
  }

  Future<bool> create({
    required String fromId,
    required String toId,
    required num amount,
  }) async {
    emit(AccountingTransfersState.success(items: items, isSaving: true));
    final result = await _createTransfer.call(
      CreateTransferParams(fromId: fromId, toId: toId, amount: amount),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingTransfersState.success(
            items: items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<void> _refresh() async {
    final result = await _getTransfers.call(
      GetTransfersParams(treasuryId: _treasuryId),
    );
    result.when(
      success: (items) => emit(AccountingTransfersState.success(items: items)),
      failure: (error) => emit(
        AccountingTransfersState.success(
          items: items,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
