import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/features/auth/domain/usecases/update_password_use_case.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final UpdatePasswordUseCase updatePasswordUseCase;

  ChangePasswordCubit({required this.updatePasswordUseCase})
      : super(const ChangePasswordInitial());

  Future<void> updatePassword({required String newPassword}) async {
    if (isClosed) return;
    emit(const ChangePasswordLoading());

    final result = await updatePasswordUseCase.call(newPassword: newPassword);
    if (isClosed) return;

    result.when(
      success: (_) => emit(const ChangePasswordSuccess()),
      failure: (failure) =>
          emit(ChangePasswordFailure(errorMessage: failure.message)),
    );
  }
}
