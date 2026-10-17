import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/features/auth/domain/usecases/forget_password_use_case.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase forgetPasswordUseCase;

  ForgetPasswordCubit({required this.forgetPasswordUseCase})
      : super(const ForgetPasswordInitial());

  Future<void> sendResetInstructions({required String email}) async {
    if (isClosed) return;
    emit(const ForgetPasswordLoading());

    final result = await forgetPasswordUseCase.call(email: email);
    if (isClosed) return;

    result.when(
      success: (_) => emit(ForgetPasswordSuccess(email: email)),
      failure: (failure) =>
          emit(ForgetPasswordFailure(errorMessage: failure.message)),
    );
  }
}
