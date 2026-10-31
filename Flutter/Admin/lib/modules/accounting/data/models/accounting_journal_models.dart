import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/date/date_only.dart';
import '../../logic/entity/accounting_enums.dart';
import '../../logic/entity/accounting_journal_entry_entity.dart';
import '../../logic/entity/accounting_ledger_line_entity.dart';

part 'accounting_journal_models.g.dart';

/// `JournalLineView`
@JsonSerializable()
final class JournalLineResponseData {
  const JournalLineResponseData({
    required this.accountCode,
    required this.accountName,
    required this.debit,
    required this.credit,
    this.id,
  });

  factory JournalLineResponseData.fromJson(Map<String, dynamic> json) =>
      _$JournalLineResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$JournalLineResponseDataToJson(this);

  final String? id;
  final String accountCode;
  final String accountName;
  final num debit;
  final num credit;
}

extension JournalLineResponseDataX on JournalLineResponseData {
  AccountingJournalLineEntity toEntity() => AccountingJournalLineEntity(
    id: id,
    accountCode: accountCode,
    accountName: accountName,
    debit: debit,
    credit: credit,
  );
}

/// `JournalView`
@JsonSerializable()
final class JournalResponseData {
  const JournalResponseData({
    required this.source,
    required this.lines,
    required this.totalDebit,
    required this.totalCredit,
    this.id,
    this.branchId,
    this.entryDate,
    this.ref,
    this.memo,
  });

  factory JournalResponseData.fromJson(Map<String, dynamic> json) =>
      _$JournalResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$JournalResponseDataToJson(this);

  final String? id;
  final String? branchId;
  final String? entryDate;
  final String source;
  final String? ref;
  final String? memo;
  final List<JournalLineResponseData> lines;
  final num totalDebit;
  final num totalCredit;
}

extension JournalResponseDataX on JournalResponseData {
  AccountingJournalEntryEntity toEntity() => AccountingJournalEntryEntity(
    id: id ?? '',
    branchId: branchId,
    entryDate: parseDateTime(entryDate),
    source: journalSourceFrom(source),
    reference: ref,
    memo: memo,
    lines: lines.map((line) => line.toEntity()).toList(growable: false),
    totalDebit: totalDebit,
    totalCredit: totalCredit,
  );
}

/// `LedgerLineView`
@JsonSerializable()
final class LedgerLineResponseData {
  const LedgerLineResponseData({
    required this.source,
    required this.accountCode,
    required this.accountName,
    required this.debit,
    required this.credit,
    required this.runningBalance,
    this.entryId,
    this.entryDate,
    this.ref,
  });

  factory LedgerLineResponseData.fromJson(Map<String, dynamic> json) =>
      _$LedgerLineResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerLineResponseDataToJson(this);

  final String? entryId;
  final String? entryDate;
  final String source;
  final String? ref;
  final String accountCode;
  final String accountName;
  final num debit;
  final num credit;
  final num runningBalance;
}

extension LedgerLineResponseDataX on LedgerLineResponseData {
  AccountingLedgerLineEntity toEntity() => AccountingLedgerLineEntity(
    entryId: entryId,
    entryDate: parseDateTime(entryDate),
    source: journalSourceFrom(source),
    reference: ref,
    accountCode: accountCode,
    accountName: accountName,
    debit: debit,
    credit: credit,
    runningBalance: runningBalance,
  );
}

/// `JournalLineRequest`
@JsonSerializable()
final class JournalLineRequestBody {
  const JournalLineRequestBody({
    required this.accountCode,
    this.debit = 0,
    this.credit = 0,
  });

  factory JournalLineRequestBody.fromEntity(AccountingJournalLineInput input) =>
      JournalLineRequestBody(
        accountCode: input.accountCode,
        debit: input.debit,
        credit: input.credit,
      );

  factory JournalLineRequestBody.fromJson(Map<String, dynamic> json) =>
      _$JournalLineRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$JournalLineRequestBodyToJson(this);

  final String accountCode;
  final num debit;
  final num credit;
}

/// `PostJournalRequest`
@JsonSerializable()
final class PostJournalRequestBody {
  const PostJournalRequestBody({
    required this.entryDate,
    required this.source,
    required this.lines,
    this.branchId,
    this.ref,
    this.memo,
  });

  factory PostJournalRequestBody.fromJson(Map<String, dynamic> json) =>
      _$PostJournalRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostJournalRequestBodyToJson(this);

  final String? branchId;
  final String entryDate;
  final String source;
  final String? ref;
  final String? memo;
  final List<JournalLineRequestBody> lines;
}
