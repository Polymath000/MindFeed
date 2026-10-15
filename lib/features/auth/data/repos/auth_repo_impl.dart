import 'package:hive/hive.dart';
import 'package:mind_feed/core/constants/constants.dart' show AppConstants;
import 'package:mind_feed/core/database/cache/cache_helper.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_error_handler.dart';
import 'package:mind_feed/core/networking/network_info.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart';
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import 'package:mind_feed/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';

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
  Future<ApiResult<void>> forgetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await authApiSource.resetPassword(email: email);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<String>> login(LoginParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await authApiSource.login(params: params);
        if (remote.isEmpty) {
          return const FailureResult(ServerFailure('No User Found'));
        }
        await SharedPreferencesSingleton.setString(AppConstants.tokenKey, remote);
        return Success(remote);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<AuthResultEntity>> signup(SignupParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authApiSource.signUp(params: params);
        if (result.hasActiveSession && result.accessToken != null && result.accessToken!.isNotEmpty) {
          await SharedPreferencesSingleton.setString(AppConstants.tokenKey, result.accessToken!);
        }
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String token,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = await authApiSource.verifyOtp(email: email, token: token);
        await SharedPreferencesSingleton.setString(AppConstants.tokenKey, accessToken);
        return Success(accessToken);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> resendOtp({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        await authApiSource.resendOtp(email: email);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> updatePassword({required String newPassword}) async {
    if (await networkInfo.isConnected) {
      try {
        await authApiSource.updatePassword(newPassword: newPassword);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<String>> verifyRecoveryOtp({
    required String email,
    required String token,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = await authApiSource.verifyRecoveryOtp(email: email, token: token);
        await SharedPreferencesSingleton.setString(AppConstants.tokenKey, accessToken);
        return Success(accessToken);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    try {
      await authApiSource.signOut();
    } catch (_) {
    } finally {
      try {
        if (Hive.isBoxOpen(AppConstants.userKey)) {
          try {
            final box = Hive.box<UserEntity>(AppConstants.userKey);
            await box.clear();
          } catch (_) {
            final box = Hive.box(AppConstants.userKey);
            await box.clear();
          }
        }
      } catch (_) {}
      try {
        await SharedPreferencesSingleton.remove(AppConstants.tokenKey);
      } catch (_) {}
      try {
        final allKeys = SharedPreferencesSingleton.getKeys();
        for (final k in allKeys) {
          if (k.startsWith('pending_category_sync')) {
            await SharedPreferencesSingleton.remove(k);
          }
        }
      } catch (_) {}
    }
    return const Success(null);
  }
}
