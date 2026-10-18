import '../../error/failures.dart';
import '../../utils/result/result.dart';

typedef ApiResult<T> = Result<T, Failures>;

typedef LocalStorageResult<T> = Result<T, LocalStorageFailure>;
