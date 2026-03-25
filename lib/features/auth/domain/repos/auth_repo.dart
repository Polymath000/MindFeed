import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mind_feed/core/errors/failure.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart' show SignupParams;

abstract class AuthRepository {
  Future<Either<Failure, String>> login(LoginParams params);
  Future<Either<Failure, Response>> signup(SignupParams params);
  Future<Either<Failure, void>> forgetPassword(String email);
}
