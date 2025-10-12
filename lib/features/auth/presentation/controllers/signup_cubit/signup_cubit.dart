import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/usecases/signup_use_case.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required this.signUpUseCase}) : super(SignupInitial());
  final SignupUseCase signUpUseCase;

  eitherFailureOrSignup({required SignupParams params}) async {
    emit(SignupLoading());
    final failureOrSignUp = await signUpUseCase.call(params: params);
    failureOrSignUp.fold(
      (failure) => emit(SignupFailure(errorMessage: failure.message)),
      (success) => emit(SignupSuccess()),
    );
  }
}
