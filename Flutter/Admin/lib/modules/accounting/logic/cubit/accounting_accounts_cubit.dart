import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/use_case/use_case_base.dart';
import '../entity/accounting_account_entity.dart';
import '../entity/accounting_enums.dart';
import '../usecase/account_usecases.dart';
import 'accounting_accounts_state.dart';

@injectable
final class AccountingAccountsCubit
    extends CubitSignal<AccountingAccountsState> {
  AccountingAccountsCubit({
    required this._getAccounts,
    required this._createAccount,
    required this._updateAccount,
  }) : super(initialState: const AccountingAccountsState.initial());

  final GetAccountsUsecase _getAccounts;
  final CreateAccountUsecase _createAccount;
  final UpdateAccountUsecase _updateAccount;

  List<AccountingAccountEntity> get _items => switch (state.value) {
    AccountingAccountsSuccess(:final items) => items,
    _ => const [],
  };

  Future<void> load() async {
    emit(const AccountingAccountsState.loading());
    final result = await _getAccounts.call(const NoParams());
    result.when(
      success: (items) => emit(AccountingAccountsState.success(items: items)),
      failure: (error) =>
          emit(AccountingAccountsState.failure(message: error.message)),
    );
  }

  Future<bool> create({
    required String code,
    required String name,
    required AccountType type,
    String? parentCode,
    String? branchId,
    String? nameEn,
  }) async {
    emit(AccountingAccountsState.success(items: _items, isSaving: true));
    final result = await _createAccount.call(
      CreateAccountParams(
        code: code,
        name: name,
        type: type,
        parentCode: parentCode,
        branchId: branchId,
        nameEn: nameEn,
      ),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingAccountsState.success(
            items: _items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> update({
    required String code,
    String? name,
    String? nameEn,
    AccountType? type,
    String? parentCode,
  }) async {
    emit(AccountingAccountsState.success(items: _items, isSaving: true));
    final result = await _updateAccount.call(
      UpdateAccountParams(
        code: code,
        name: name,
        nameEn: nameEn,
        type: type,
        parentCode: parentCode,
      ),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingAccountsState.success(
            items: _items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<void> _refresh() async {
    final result = await _getAccounts.call(const NoParams());
    result.when(
      success: (items) => emit(AccountingAccountsState.success(items: items)),
      failure: (error) => emit(
        AccountingAccountsState.success(
          items: _items,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
