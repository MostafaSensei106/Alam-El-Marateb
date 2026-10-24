import '../../error/failures.dart';
import '../result/result.dart';

abstract interface class UseCaseBase<T, Params> {
  Future<Result<T, Failures>> call(Params params);
}

final class NoParams {
  const NoParams();
}

class PaginationParams {
  const PaginationParams({required this.page});
  final int page;
}
