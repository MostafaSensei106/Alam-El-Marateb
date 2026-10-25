import 'package:json_annotation/json_annotation.dart';

part 'balance_sheet_response_data.g.dart';

@JsonSerializable()
final class BalanceSheetResponseData {
  const BalanceSheetResponseData({
    required this.asOf,
    required this.assets,
    required this.liabilities,
    required this.equity,
  });

  /// From Json
  factory BalanceSheetResponseData.fromJson(Map<String, dynamic> json) =>
      _$BalanceSheetResponseDataFromJson(json);

  /// To Json
  Map<String, dynamic> toJson() => _$BalanceSheetResponseDataToJson(this);

  final String asOf;
  final int assets;
  final int liabilities;
  final int equity;
}
