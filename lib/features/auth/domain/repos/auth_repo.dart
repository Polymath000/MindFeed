import 'package:dio/dio.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart' show SignupParams;

abstract class AuthRepository {
  Future<ApiResult<String>> login(LoginParams params);
  Future<ApiResult<Response>> signup(SignupParams params);
  Future<ApiResult<void>> forgetPassword(String email);
}
