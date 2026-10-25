import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/use_case/use_case_base.dart';
import '../usecase/get_profile_usecase.dart';
import 'profile_state.dart';

@injectable
final class ProfileCubit extends CubitSignal<ProfileState> {
  ProfileCubit({required this._getProfileUsecase})
    : super(initialState: const ProfileState.initial());

  final GetProfileUsecase _getProfileUsecase;

  Future<void> getProfile() async {
    emit(const ProfileState.loading());
    final result = await _getProfileUsecase.call(const NoParams());
    result.when(
      success: (s) => emit(ProfileState.success(data: s)),
      failure: (e) => emit(ProfileState.failure(message: e.message)),
    );
  }
}
