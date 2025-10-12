import 'package:dartz/dartz.dart';
import 'package:mind_feed/core/constants/constants.dart' show tokenKey;
import 'package:mind_feed/core/database/cache/cache_helper.dart';
import 'package:mind_feed/core/errors/expentions.dart';
import 'package:mind_feed/core/errors/failure.dart';
import 'package:mind_feed/core/network/network_info.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart';
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/params/signup_params.dart';
import '../../../../core/services/shared_preferences_singleton.dart';

class AuthRepoImpl extends AuthRepository {
  NetworkInfo networkInfo;
  final AuthApiSource authApiSource;
  final UserCacheDataSource userCacheDataSource;
  late CacheHelper cacheHelper;
  AuthRepoImpl({
    required this.authApiSource,
    required this.networkInfo,
    required this.userCacheDataSource,
  });
  @override
  Future<Either<Failure, void>> forgetPassword(String email) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  final sharedPreferences = SharedPreferences.getInstance();
  @override
  Future<Either<Failure, String>> login(LoginParams params) async {
    if (await networkInfo.isConnected!) {
      try {
        final remote = await authApiSource.login(params: params);
        if (remote.isEmpty) {
          return Left(Failure(message: 'No User Found'));
        }
        await SharedPreferencesSingleton.setString(tokenKey, remote);
        return Right(remote);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(message: 'You are Offline'));
    }
  }

  @override
  Future<Either<Failure, String>> signup(SignupParams params) async{
    if (await networkInfo.isConnected!) {
      try {
        final remote = await authApiSource.signUp(params: params);
        await SharedPreferencesSingleton.setString(tokenKey, remote);
        return Right(remote);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(message: 'You are Offline'));
    }
  }
}
