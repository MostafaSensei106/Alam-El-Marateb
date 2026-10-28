// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_journal_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalLineResponseData _$JournalLineResponseDataFromJson(
  Map<String, dynamic> json,
) => JournalLineResponseData(
  accountCode: json['accountCode'] as String,
  accountName: json['accountName'] as String,
  debit: json['debit'] as num,
  credit: json['credit'] as num,
  id: json['id'] as String?,
);

Map<String, dynamic> _$JournalLineResponseDataToJson(
  JournalLineResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'accountCode': instance.accountCode,
  'accountName': instance.accountName,
  'debit': instance.debit,
  'credit': instance.credit,
};

JournalResponseData _$JournalResponseDataFromJson(Map<String, dynamic> json) =>
    JournalResponseData(
      source: json['source'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map(
            (e) => JournalLineResponseData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      totalDebit: json['totalDebit'] as num,
      totalCredit: json['totalCredit'] as num,
      id: json['id'] as String?,
      branchId: json['branchId'] as String?,
      entryDate: json['entryDate'] as String?,
      ref: json['ref'] as String?,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$JournalResponseDataToJson(
  JournalResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'branchId': instance.branchId,
  'entryDate': instance.entryDate,
  'source': instance.source,
  'ref': instance.ref,
  'memo': instance.memo,
  'lines': instance.lines,
  'totalDebit': instance.totalDebit,
  'totalCredit': instance.totalCredit,
};

LedgerLineResponseData _$LedgerLineResponseDataFromJson(
  Map<String, dynamic> json,
) => LedgerLineResponseData(
  source: json['source'] as String,
  accountCode: json['accountCode'] as String,
  accountName: json['accountName'] as String,
  debit: json['debit'] as num,
  credit: json['credit'] as num,
  runningBalance: json['runningBalance'] as num,
  entryId: json['entryId'] as String?,
  entryDate: json['entryDate'] as String?,
  ref: json['ref'] as String?,
);

Map<String, dynamic> _$LedgerLineResponseDataToJson(
  LedgerLineResponseData instance,
) => <String, dynamic>{
  'entryId': instance.entryId,
  'entryDate': instance.entryDate,
  'source': instance.source,
  'ref': instance.ref,
  'accountCode': instance.accountCode,
  'accountName': instance.accountName,
  'debit': instance.debit,
  'credit': instance.credit,
  'runningBalance': instance.runningBalance,
};

JournalLineRequestBody _$JournalLineRequestBodyFromJson(
  Map<String, dynamic> json,
) => JournalLineRequestBody(
  accountCode: json['accountCode'] as String,
  debit: json['debit'] as num? ?? 0,
  credit: json['credit'] as num? ?? 0,
);

Map<String, dynamic> _$JournalLineRequestBodyToJson(
  JournalLineRequestBody instance,
) => <String, dynamic>{
  'accountCode': instance.accountCode,
  'debit': instance.debit,
  'credit': instance.credit,
};

PostJournalRequestBody _$PostJournalRequestBodyFromJson(
  Map<String, dynamic> json,
) => PostJournalRequestBody(
  entryDate: json['entryDate'] as String,
  source: json['source'] as String,
  lines: (json['lines'] as List<dynamic>)
      .map((e) => JournalLineRequestBody.fromJson(e as Map<String, dynamic>))
      .toList(),
  branchId: json['branchId'] as String?,
  ref: json['ref'] as String?,
  memo: json['memo'] as String?,
);

Map<String, dynamic> _$PostJournalRequestBodyToJson(
  PostJournalRequestBody instance,
) => <String, dynamic>{
  'branchId': instance.branchId,
  'entryDate': instance.entryDate,
  'source': instance.source,
  'ref': instance.ref,
  'memo': instance.memo,
  'lines': instance.lines,
};
