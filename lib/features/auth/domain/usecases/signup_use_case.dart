import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart' show AuthRepository;
import 'package:mind_feed/core/networking/api_result.dart';

class SignupUseCase {
  final AuthRepository repo;
  SignupUseCase({required this.repo});

  Future<ApiResult<AuthResultEntity>> call({required SignupParams params}) {
    return repo.signup(params);
  }
}