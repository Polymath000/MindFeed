import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/usecases/signup_use_case.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required this.signUpUseCase}) : super(SignupInitial());
  final SignupUseCase signUpUseCase;

  Future<void> eitherFailureOrSignup({required SignupParams params}) async {
    if (isClosed) return;
    emit(SignupLoading());
    final result = await signUpUseCase.call(params: params);
    
    if (!isClosed) {
      result.when(
        success: (success) => emit(SignupSuccess()),
        failure: (failure) => emit(SignupFailure(errorMessage: failure.message)),
      );
    }
  }
}
