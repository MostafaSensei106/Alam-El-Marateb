import 'package:meta/meta.dart';

@immutable
sealed class Result<T, E> {
  const Result();

  const factory Result.success({required T data}) = Success<T, E>;
  const factory Result.failure({required E error, StackTrace? stackTrace}) =
      Failure<T, E>;

  factory Result.fromNullable(T? value, {required E Function() onNull}) =>
      value != null
      ? Result.success(data: value)
      : Result.failure(error: onNull());

  static Future<Result<T, E>> tryCatching<T, E>({
    required Future<T> Function() action,
    required E Function(Object e, StackTrace st) onError,
    bool catchErrors = false,
  }) async {
    try {
      return Result.success(data: await action());
    } catch (e, st) {
      if (e is! Exception && !catchErrors) rethrow;
      return Result.failure(error: onError(e, st), stackTrace: st);
    }
  }

  static Result<T, E> tryCatchingSync<T, E>({
    required T Function() action,
    required E Function(Object e, StackTrace st) onError,
    bool catchErrors = false,
  }) {
    try {
      return Result.success(data: action());
    } catch (e, st) {
      if (e is! Exception && !catchErrors) rethrow;
      return Result.failure(error: onError(e, st), stackTrace: st);
    }
  }

  StackTrace? get stackTrace;

  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  });

  R maybeWhen<R>({
    required R Function() orElse,
    R Function(T data)? success,
    R Function(E error)? failure,
  });

  R? whenOrNull<R>({R Function(T data)? success, R Function(E error)? failure});

  T getOrThrow();
}

final class Success<T, E> extends Result<T, E> {
  const Success({required this.data});
  final T data;

  @override
  StackTrace? get stackTrace => null;

  @override
  @pragma('vm:prefer-inline')
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) => success(data);

  @override
  @pragma('vm:prefer-inline')
  R maybeWhen<R>({
    required R Function() orElse,
    R Function(T data)? success,
    R Function(E error)? failure,
  }) => success != null ? success(data) : orElse();

  @override
  @pragma('vm:prefer-inline')
  R? whenOrNull<R>({
    R Function(T data)? success,
    R Function(E error)? failure,
  }) => success?.call(data);

  @override
  T getOrThrow() => data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Success && other.data == data);

  @override
  int get hashCode => Object.hash(Success, data);

  @override
  String toString() => 'Result.success(data: $data)';
}

final class Failure<T, E> extends Result<T, E> {
  const Failure({required this.error, this.stackTrace});
  final E error;

  @override
  final StackTrace? stackTrace;

  @override
  @pragma('vm:prefer-inline')
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) => failure(error);

  @override
  @pragma('vm:prefer-inline')
  R maybeWhen<R>({
    required R Function() orElse,
    R Function(T data)? success,
    R Function(E error)? failure,
  }) => failure != null ? failure(error) : orElse();

  @override
  @pragma('vm:prefer-inline')
  R? whenOrNull<R>({
    R Function(T data)? success,
    R Function(E error)? failure,
  }) => failure?.call(error);

  @override
  T getOrThrow() {
    final e = error;
    Error.throwWithStackTrace(
      (e is Exception || e is Error) ? e as Object : ResultException(e),
      stackTrace ?? StackTrace.current,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Failure && other.error == error);

  @override
  int get hashCode => Object.hash(Failure, error);

  @override
  String toString() => 'Result.failure(error: $error)';
}

final class ResultException implements Exception {
  const ResultException(this.error);
  final Object? error;

  @override
  String toString() => 'ResultException: $error';
}

extension ResultExtension<T, E> on Result<T, E> {
  @pragma('vm:prefer-inline')
  bool get isSuccess => this is Success<T, E>;

  @pragma('vm:prefer-inline')
  bool get isFailure => this is Failure<T, E>;

  T? get dataOrNull => when(success: (d) => d, failure: (_) => null);

  E? get errorOrNull => when(success: (_) => null, failure: (e) => e);

  T getOrElse(T Function(E error) fallback) =>
      when(success: (d) => d, failure: fallback);

  Result<R, E> map<R>(R Function(T data) mapper) => when(
    success: (d) => Result<R, E>.success(data: mapper(d)),
    failure: (e) => Result<R, E>.failure(error: e, stackTrace: stackTrace),
  );

  Result<T, F> mapError<F>(F Function(E error) mapper) => when(
    success: (d) => Result<T, F>.success(data: d),
    failure: (e) =>
        Result<T, F>.failure(error: mapper(e), stackTrace: stackTrace),
  );

  Result<R, E> flatMap<R>(Result<R, E> Function(T data) mapper) => when(
    success: mapper,
    failure: (e) => Result<R, E>.failure(error: e, stackTrace: stackTrace),
  );

  Result<T, E> recover(T Function(E error) f) => when(
    success: (_) => this,
    failure: (e) => Result<T, E>.success(data: f(e)),
  );

  Result<T, F> recoverWith<F>(Result<T, F> Function(E error) f) => when(
    success: (d) => Result<T, F>.success(data: d),
    failure: f,
  );

  Future<Result<R, E>> mapAsync<R>(Future<R> Function(T data) mapper) => when(
    success: (d) async => Result<R, E>.success(data: await mapper(d)),
    failure: (e) async =>
        Result<R, E>.failure(error: e, stackTrace: stackTrace),
  );

  Future<Result<R, E>> flatMapAsync<R>(
    Future<Result<R, E>> Function(T data) mapper,
  ) => when(
    success: mapper,
    failure: (e) async =>
        Result<R, E>.failure(error: e, stackTrace: stackTrace),
  );

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(E error) onFailure,
  }) => when(success: onSuccess, failure: onFailure);

  Result<T, E> onSuccess(void Function(T data) action) {
    whenOrNull(success: action);
    return this;
  }

  Result<T, E> onFailure(void Function(E error) action) {
    whenOrNull(failure: action);
    return this;
  }
}

extension ResultFutureExtension<T, E> on Future<Result<T, E>> {
  Future<Result<R, E>> map<R>(R Function(T data) mapper) async =>
      (await this).map(mapper);

  Future<Result<T, F>> mapError<F>(F Function(E error) mapper) async =>
      (await this).mapError(mapper);

  Future<Result<R, E>> flatMap<R>(Result<R, E> Function(T data) mapper) async =>
      (await this).flatMap(mapper);

  Future<Result<R, E>> mapAsync<R>(Future<R> Function(T data) mapper) async =>
      (await this).mapAsync(mapper);

  Future<Result<R, E>> flatMapAsync<R>(
    Future<Result<R, E>> Function(T data) mapper,
  ) async => (await this).flatMapAsync(mapper);

  Future<Result<T, E>> recover(T Function(E error) f) async =>
      (await this).recover(f);

  Future<Result<T, E>> onSuccess(void Function(T data) action) async =>
      (await this).onSuccess(action);

  Future<Result<T, E>> onFailure(void Function(E error) action) async =>
      (await this).onFailure(action);

  Future<T> getOrElse(T Function(E error) fallback) async =>
      (await this).getOrElse(fallback);
}

extension ResultIterableExtension<T, E> on Iterable<Result<T, E>> {
  Result<List<T>, E> collect() {
    final out = <T>[];
    for (final r in this) {
      if (r case Failure(:final error, :final stackTrace)) {
        return Result.failure(error: error, stackTrace: stackTrace);
      }
      out.add((r as Success<T, E>).data);
    }
    return Result.success(data: out);
  }

  List<T> get successes => [
    for (final r in this)
      if (r case Success(:final data)) data,
  ];

  List<E> get failures => [
    for (final r in this)
      if (r case Failure(:final error)) error,
  ];
}
