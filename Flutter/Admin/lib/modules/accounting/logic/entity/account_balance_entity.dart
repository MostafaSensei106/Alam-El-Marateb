import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_balance_entity.freezed.dart';

@freezed
sealed class AccountBalanceEntity with _$AccountBalanceEntity {
  const factory AccountBalanceEntity({
    required String asOf,
    required num assets,
    required num liabilities,
    required num equity,
  }) = _AccountBalanceEntity;

  const factory AccountBalanceEntity.placHolder({

  }) = __AccountBalanceEntity;
}
