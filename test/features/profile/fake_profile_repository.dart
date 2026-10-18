import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class FakeProfileRepository extends Fake implements ProfileRepository {
  Map<String, dynamic> profileData = {};
  List<Map<String, dynamic>> favoriteCategories = [];
  bool shouldProfileSucceed = true;
  bool shouldFavsSucceed = true;

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId) async {
    if (!shouldProfileSucceed) {
      return FailureResult(ServerFailure('Profile load failed'));
    }
    return Success(profileData);
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(String userId) async {
    if (!shouldFavsSucceed) {
      return FailureResult(ServerFailure('Favorites load failed'));
    }
    return Success(favoriteCategories);
  }
}
