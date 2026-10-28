import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../entity/accounting_check_entity.dart';
import '../entity/accounting_enums.dart';
import '../usecase/check_usecases.dart';
import 'accounting_checks_state.dart';

@injectable
final class AccountingChecksCubit extends CubitSignal<AccountingChecksState> {
  AccountingChecksCubit({
    required this._getChecks,
    required this._createCheck,
    required this._updateCheck,
    required this._updateCheckStatus,
  }) : super(initialState: const AccountingChecksState.initial());

  final GetChecksUsecase _getChecks;
  final CreateCheckUsecase _createCheck;
  final UpdateCheckUsecase _updateCheck;
  final UpdateCheckStatusUsecase _updateCheckStatus;

  CheckStatus? _status;

  List<AccountingCheckEntity> get items => switch (state.value) {
    AccountingChecksSuccess(:final items) => items,
    _ => const [],
  };

  Future<void> load({CheckStatus? status}) async {
    _status = status;
    emit(const AccountingChecksState.loading());
    final result = await _getChecks.call(GetChecksParams(status: status));
    result.when(
      success: (items) => emit(AccountingChecksState.success(items: items)),
      failure: (error) =>
          emit(AccountingChecksState.failure(message: error.message)),
    );
  }

  Future<bool> create({
    required CheckDirection direction,
    required num amount,
    DateTime? dueDate,
    String? party,
  }) async {
    emit(AccountingChecksState.success(items: items, isSaving: true));
    final result = await _createCheck.call(
      CreateCheckParams(
        direction: direction,
        amount: amount,
        dueDate: dueDate,
        party: party,
      ),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingChecksState.success(
            items: items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> update({
    required String id,
    DateTime? dueDate,
    String? party,
  }) async {
    emit(AccountingChecksState.success(items: items, isSaving: true));
    final result = await _updateCheck.call(
      UpdateCheckParams(id: id, dueDate: dueDate, party: party),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingChecksState.success(
            items: items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> updateStatus({
    required String id,
    required CheckStatus status,
  }) async {
    emit(AccountingChecksState.success(items: items, isSaving: true));
    final result = await _updateCheckStatus.call(
      UpdateCheckStatusParams(id: id, status: status),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingChecksState.success(
            items: items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<void> _refresh() async {
    final result = await _getChecks.call(GetChecksParams(status: _status));
    result.when(
      success: (items) => emit(AccountingChecksState.success(items: items)),
      failure: (error) => emit(
        AccountingChecksState.success(
          items: items,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
