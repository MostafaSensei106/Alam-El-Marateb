import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../entity/accounting_treasury_entity.dart';
import '../usecase/treasury_usecases.dart';
import 'accounting_treasuries_state.dart';

@injectable
final class AccountingTreasuriesCubit
    extends CubitSignal<AccountingTreasuriesState> {
  AccountingTreasuriesCubit({
    required this._getTreasuries,
    required this._createTreasury,
    required this._updateTreasury,
  }) : super(initialState: const AccountingTreasuriesState.initial());

  final GetTreasuriesUsecase _getTreasuries;
  final CreateTreasuryUsecase _createTreasury;
  final UpdateTreasuryUsecase _updateTreasury;

  String? _branchId;

  List<AccountingTreasuryEntity> get items => switch (state.value) {
    AccountingTreasuriesSuccess(:final items) => items,
    _ => const [],
  };

  Future<void> load({String? branchId}) async {
    _branchId = branchId;
    emit(const AccountingTreasuriesState.loading());
    final result = await _getTreasuries.call(
      GetTreasuriesParams(branchId: branchId),
    );
    result.when(
      success: (items) => emit(AccountingTreasuriesState.success(items: items)),
      failure: (error) =>
          emit(AccountingTreasuriesState.failure(message: error.message)),
    );
  }

  Future<bool> create({
    required String name,
    num? openingBalance,
    String? branchId,
  }) async {
    emit(AccountingTreasuriesState.success(items: items, isSaving: true));
    final result = await _createTreasury.call(
      CreateTreasuryParams(
        name: name,
        openingBalance: openingBalance,
        branchId: branchId ?? _branchId,
      ),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingTreasuriesState.success(
            items: items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> update({required String id, String? name}) async {
    emit(AccountingTreasuriesState.success(items: items, isSaving: true));
    final result = await _updateTreasury.call(
      UpdateTreasuryParams(id: id, name: name),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingTreasuriesState.success(
            items: items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<void> _refresh() async {
    final result = await _getTreasuries.call(
      GetTreasuriesParams(branchId: _branchId),
    );
    result.when(
      success: (items) => emit(AccountingTreasuriesState.success(items: items)),
      failure: (error) => emit(
        AccountingTreasuriesState.success(
          items: items,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
