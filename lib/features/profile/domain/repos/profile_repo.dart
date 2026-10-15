import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId);
  Future<ApiResult<Map<String, dynamic>>> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });
  Future<ApiResult<List<Map<String, dynamic>>>> getCategories();
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(String userId);
  Future<ApiResult<void>> saveLocalCategories({
    required String userId,
    required List<String> categoryNames,
    UserEntity? currentUser,
  });
  Future<ApiResult<void>> syncFavoriteCategories({
    required String userId,
    required List<String> categoryNames,
  });
  Future<bool> reconcilePendingCategorySync({String? userId});
}
