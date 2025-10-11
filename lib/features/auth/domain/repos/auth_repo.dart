import 'package:dartz/dartz.dart';
import 'package:mind_feed/core/errors/failure.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(LoginParams params);
  Future<Either<Failure, String>> signup(UserEntity userEntity);
  Future<Either<Failure, void>> forgetPassword(String email);
}
