import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_enums.dart';
import '../entity/accounting_journal_entry_entity.dart';

// ────────────────────────────── Journal entries ──────────────────────────

final class GetJournalEntriesParams {
  const GetJournalEntriesParams({this.branchId, this.from, this.to, this.source});

  final String? branchId;
  final DateTime? from;
  final DateTime? to;
  final JournalSource? source;
}

@injectable
final class GetJournalEntriesUsecase
    implements
        UseCaseBase<
          List<AccountingJournalEntryEntity>,
          GetJournalEntriesParams
        > {
  const GetJournalEntriesUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<List<AccountingJournalEntryEntity>, Failures>> call(
    GetJournalEntriesParams params,
  ) => _repo.getJournalEntries(
    branchId: params.branchId,
    from: params.from,
    to: params.to,
    source: params.source,
  );
}

@injectable
final class GetJournalEntryUsecase
    implements UseCaseBase<AccountingJournalEntryEntity, String> {
  const GetJournalEntryUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingJournalEntryEntity, Failures>> call(
    String params,
  ) => _repo.getJournalEntry(id: params);
}

final class PostJournalEntryParams {
  const PostJournalEntryParams({
    required this.entryDate,
    required this.lines,
    this.source = JournalSource.manual,
    this.branchId,
    this.reference,
    this.memo,
  });

  final DateTime entryDate;
  final List<AccountingJournalLineInput> lines;
  final JournalSource source;
  final String? branchId;
  final String? reference;
  final String? memo;
}

@injectable
final class PostJournalEntryUsecase
    implements
        UseCaseBase<AccountingJournalEntryEntity, PostJournalEntryParams> {
  const PostJournalEntryUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingJournalEntryEntity, Failures>> call(
    PostJournalEntryParams params,
  ) => _repo.postJournalEntry(
    entryDate: params.entryDate,
    lines: params.lines,
    source: params.source,
    branchId: params.branchId,
    reference: params.reference,
    memo: params.memo,
  );
}
