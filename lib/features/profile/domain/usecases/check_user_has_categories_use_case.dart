import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class CheckUserHasCategoriesUseCase {
  final ProfileRepository profileRepository;

  const CheckUserHasCategoriesUseCase(this.profileRepository);

  Future<ApiResult<bool>> call({String? userId}) async {
    final result = await profileRepository.getFavoriteCategories(userId ?? '');
    return switch (result) {
      Success(:final data) => Success(data.isNotEmpty),
      FailureResult(:final failure) => FailureResult(failure),
    };
  }
}
