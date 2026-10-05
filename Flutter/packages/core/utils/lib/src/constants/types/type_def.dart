import 'package:core_network/core_network.dart';

import '../../utils/result/result.dart';

typedef ApiResult<T> = Result<T, Failures>;

typedef LocalStorageResult<T> = Result<T, LocalStorageFailure>;
