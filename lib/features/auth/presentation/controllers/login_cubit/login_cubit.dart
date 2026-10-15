import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/login_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/check_user_has_categories_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.loginUseCase,
    this.checkUserHasCategoriesUseCase,
  }) : super(LoginInitial());

  final LoginUseCase loginUseCase;
  final CheckUserHasCategoriesUseCase? checkUserHasCategoriesUseCase;

  Future<void> eitherFailureOrLogin({
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(LoginLoading());
    final params = LoginParams(email: email, password: password);
    final result = await loginUseCase.call(params: params);

    if (isClosed) return;

    await result.when(
      success: (accessToken) async => await _handleLoginSuccess(
        accessToken: accessToken,
        email: email,
      ),
      failure: (failure) async {
        if (!isClosed) {
          emit(LoginFailure(
            errorMessage: failure.message,
            email: email,
          ));
        }
      },
    );
  }

  Future<void> _handleLoginSuccess({
    required String accessToken,
    required String email,
  }) async {
    final hasCategories = await _checkHasCategories(email);
    if (isClosed) return;

    if (hasCategories) {
      emit(LoginSuccess());
    } else {
      final userEntity = UserEntity(
        userName: '',
        email: email,
        favoriteCategories: const [],
        token: accessToken,
      );
      emit(LoginRequiresCategories(userEntity: userEntity));
    }
  }

  Future<bool> _checkHasCategories(String email) async {
    if (checkUserHasCategoriesUseCase == null) return false;
    final res = await checkUserHasCategoriesUseCase!(userId: email);
    return res is Success<bool> ? res.data : false;
  }
}
