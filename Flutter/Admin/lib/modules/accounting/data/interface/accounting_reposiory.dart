import '../../../../core/constants/types/type_def.dart';
import '../../logic/entity/accounting_balance_sheet_entity.dart';

abstract interface class AccountingReposiory {
  Future<ApiResult<AccountingBalanceSheetEntity>> getAccountBalanceSheet({
    required String to,
  });
}
