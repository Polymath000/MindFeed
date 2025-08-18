import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mind_feed/core/database/api/dio_consumer.dart';
import 'package:mind_feed/core/database/cache/cache_helper.dart';
import 'package:mind_feed/core/network/network_info.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart';
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import 'package:mind_feed/features/auth/data/repos/auth_repo_impl.dart';
import 'package:mind_feed/features/auth/domain/usecases/login.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  eitherFailureOrLogin({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    LoginParams params = LoginParams(email: email, password: password);
    final failureOrLogin = await Login(
      repo: UserRepoImpl(
        authApiSource: AuthApiSource(apiConsumer: DioConsumer(dio: Dio())),
        networkInfo: NetworkInfoImpl(DataConnectionChecker()),
        userCacheDataSource: UserCacheDataSource(cacheHelper: CacheHelper()),
      ),
    ).call(params: params);
    failureOrLogin.fold(
      (failure) => emit(AuthFailure(errorMessage: failure.errMessage)),
      (user) => emit(AuthSuccess()),
    );
  }
}
