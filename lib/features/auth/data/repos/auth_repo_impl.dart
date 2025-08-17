import 'package:dartz/dartz.dart';
import 'package:mind_feed/core/errors/expentions.dart';
import 'package:mind_feed/core/errors/failure.dart';
import 'package:mind_feed/core/network/network_info.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart';
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';

class UserRepoImpl extends AuthRepository {
  NetworkInfo networkInfo;
  final AuthApiSource authApiSource;
  final UserCacheDataSource userCacheDataSource;
  UserRepoImpl({
    required this.authApiSource,
    required this.networkInfo,
    required this.userCacheDataSource,
  });
  @override
  Future<Either<Failure, void>> forgetPassword(String email) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    if (await networkInfo.isConnected!) {
      try {
        final remote = await authApiSource.login(params: params);
        if (remote.token!.isEmpty) {
          return Left(Failure(errMessage: 'No User Found'));
        }
        userCacheDataSource.cacheUser(remote);
        return Right(remote);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'You are Offline'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup(UserEntity userEntity) {
    // TODO: implement signup
    throw UnimplementedError();
  }
}
