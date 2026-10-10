import 'package:dio/dio.dart';
import 'package:mind_feed/core/constants/constants.dart' show AppConstants;
import 'package:mind_feed/core/database/cache/cache_helper.dart';
import 'package:mind_feed/core/errors/expentions.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/network/network_info.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart';
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';

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
  Future<ApiResult<void>> forgetPassword(String email) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<String>> login(LoginParams params) async {
    if (await networkInfo.isConnected!) {
      try {
        final remote = await authApiSource.login(params: params);
        if (remote.isEmpty) {
          return FailureResult(Failure(message: 'No User Found'));
        }
        await SharedPreferencesSingleton.setString(AppConstants.tokenKey, remote);
        return Success(remote);
      } on ServerException catch (e) {
        return FailureResult(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return FailureResult(Failure(message: 'You are Offline'));
    }
  }

  @override
  Future<ApiResult<Response>> signup(SignupParams params) async {
    if (await networkInfo.isConnected!) {
      try {
        final remote = await authApiSource.signUp(params: params);

        final responseData = remote.data;
        if (responseData is Map) {
          final responseMap = Map<String, dynamic>.from(responseData as Map);
          final token = responseMap['idToken'] as String?;
          if (token != null && token.isNotEmpty) {
            await SharedPreferencesSingleton.setString(AppConstants.tokenKey, token);
          }
        }

        return Success(remote);
      } on ServerException catch (e) {
        return FailureResult(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return FailureResult(Failure(message: 'You are Offline'));
    }
  }
}
