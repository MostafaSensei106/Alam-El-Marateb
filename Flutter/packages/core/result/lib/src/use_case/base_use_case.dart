import 'package:alam_el_marateb_result/src/failure/failures.dart';
import 'package:alam_el_marateb_result/src/result.dart';

abstract interface class BaseUseCase<T, Params> {
  Future<Result<T, Failure>> call(Params params);
}

final class NoParams {
  const NoParams();
}

class PaginationParams {
  const PaginationParams({required this.page});
  final int page;
}
