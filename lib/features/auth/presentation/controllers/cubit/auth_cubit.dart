import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/domain/usecases/login.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.loginUseCase}) : super(AuthInitial( ));
  final LoginUseCase loginUseCase;
  eitherFailureOrLogin({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    LoginParams params = LoginParams(email: email, password: password);
    final failureOrLogin = await loginUseCase.call(params: params);
    failureOrLogin.fold(
      (failure) => emit(AuthFailure(errorMessage: failure.message)),
      (user) => emit(AuthSuccess()),
    );
  }
}
