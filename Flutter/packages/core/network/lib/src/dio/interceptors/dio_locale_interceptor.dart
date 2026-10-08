import 'package:dio/dio.dart';

final class DioLocaleInterceptor extends Interceptor {
  DioLocaleInterceptor(this._localCubit)

  final LocalizationCubit _localCubit;
}
