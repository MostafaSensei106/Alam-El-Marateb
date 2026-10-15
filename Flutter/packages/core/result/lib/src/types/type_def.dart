import 'package:alam_el_marateb_utils/utils.dart';

import '../result.dart';

typedef ApiResult<T> = Result<T, Failure>;

typedef LocalStorageResult<T> = Result<T, LocalStorageFailure>;
