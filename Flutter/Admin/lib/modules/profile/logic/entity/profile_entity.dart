import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';

@freezed
sealed class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String fullName,
    required String phoneNumber,
    required String email,
    required List<String> roles,
  }) = _ProfileEntity;
}
