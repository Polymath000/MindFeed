import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class GetFavoriteCategoriesUseCase {
  final ProfileRepository repository;

  const GetFavoriteCategoriesUseCase(this.repository);

  Future<ApiResult<List<Map<String, dynamic>>>> call(String userId) {
    return repository.getFavoriteCategories(userId);
  }
}
