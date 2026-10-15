import 'package:alam_el_marateb_result/src/failure/failures.dart';
import 'package:alam_el_marateb_result/src/result.dart';

typedef ApiResult<T> = Result<T, Failure>;

typedef LocalStorageResult<T> = Result<T, LocalStorageFailure>;
