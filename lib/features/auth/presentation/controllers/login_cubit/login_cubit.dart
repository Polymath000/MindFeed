import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/domain/usecases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginUseCase}) : super(LoginInitial());
  final LoginUseCase loginUseCase;
  
  Future<void> eitherFailureOrLogin({
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(LoginLoading());
    LoginParams params = LoginParams(email: email, password: password);
    final result = await loginUseCase.call(params: params);
    
    if (!isClosed) {
      result.when(
        success: (user) => emit(LoginSuccess()),
        failure: (failure) => emit(LoginFailure(errorMessage: failure.message)),
      );
    }
  }
}
