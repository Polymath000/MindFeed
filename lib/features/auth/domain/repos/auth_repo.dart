import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/entities/auth_result_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<String>> login(LoginParams params);
  Future<ApiResult<AuthResultEntity>> signup(SignupParams params);
  Future<ApiResult<String>> verifyOtp({required String email, required String token});
  Future<ApiResult<void>> resendOtp({required String email});
  Future<ApiResult<void>> forgetPassword(String email);
  Future<ApiResult<void>> logout();
}
