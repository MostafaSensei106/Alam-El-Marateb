// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_pagination_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginationState<T> _$PaginationStateFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PaginationState<T>(
  items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
  currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
  hasReachedMax: json['hasReachedMax'] as bool? ?? false,
  isLoadingMore: json['isLoadingMore'] as bool? ?? false,
  isInitialLoading: json['isInitialLoading'] as bool? ?? false,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$PaginationStateToJson<T>(
  _PaginationState<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'currentPage': instance.currentPage,
  'hasReachedMax': instance.hasReachedMax,
  'isLoadingMore': instance.isLoadingMore,
  'isInitialLoading': instance.isInitialLoading,
  'errorMessage': instance.errorMessage,
};
