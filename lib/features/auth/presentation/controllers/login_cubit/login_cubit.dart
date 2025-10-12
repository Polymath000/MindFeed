import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/domain/usecases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginUseCase}) : super(LoginInitial());
  final LoginUseCase loginUseCase;
  eitherFailureOrLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    LoginParams params = LoginParams(email: email, password: password);
    final failureOrLogin = await loginUseCase.call(params: params);
    failureOrLogin.fold(
      (failure) => emit(LoginFailure(errorMessage: failure.message)),
      (user) => emit(LoginSuccess()),
    );
  }
}
