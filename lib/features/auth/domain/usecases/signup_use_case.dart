import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart' show AuthRepository;

import '../../../../core/errors/failure.dart';

class SignupUseCase {
    final AuthRepository repo;
  SignupUseCase({required this.repo});

  Future<Either<Failure, Response>> call({required SignupParams params}) {
    return repo.signup(params);
  }
}