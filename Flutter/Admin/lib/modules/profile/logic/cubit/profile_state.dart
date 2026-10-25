import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/profile_entity.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.success({required ProfileEntity data}) = _Success;
  const factory ProfileState.failure({required String message}) = _Failure;
}
