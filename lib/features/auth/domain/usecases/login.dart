import 'package:dartz/dartz.dart';
import 'package:mind_feed/core/errors/failure.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';

class Login {
  final AuthRepository repo;
  Login({required this.repo});

  Future<Either<Failure, String>> call({required LoginParams params}) {
    return repo.login(params);
  }
}
