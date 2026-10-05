import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_pagination_state.freezed.dart';
part 'base_pagination_state.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginationState<T> with _$PaginationState<T> {
  const factory PaginationState({
    @Default([]) List<T> items,
    @Default(1) int currentPage,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isInitialLoading,
    String? errorMessage,
  }) = _PaginationState<T>;

  const PaginationState._();

  factory PaginationState.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginationStateFromJson(json, fromJsonT);
}
