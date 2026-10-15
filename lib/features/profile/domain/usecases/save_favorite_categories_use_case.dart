import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class CategorySaveOutcome {
  final bool isLocalSaved;
  final bool isRemoteSynced;
  final bool isPendingSync;
  final String? errorMessage;

  const CategorySaveOutcome({
    required this.isLocalSaved,
    required this.isRemoteSynced,
    required this.isPendingSync,
    this.errorMessage,
  });
}

class SaveFavoriteCategoriesUseCase {
  final ProfileRepository repository;

  SaveFavoriteCategoriesUseCase(this.repository);

  Future<CategorySaveOutcome> call({
    required String userId,
    required List<String> categoryNames,
    UserEntity? currentUser,
  }) async {
    final localResult = await repository.saveLocalCategories(
      userId: userId,
      categoryNames: categoryNames,
      currentUser: currentUser,
    );

    if (localResult is FailureResult) {
      return CategorySaveOutcome(
        isLocalSaved: false,
        isRemoteSynced: false,
        isPendingSync: false,
        errorMessage: localResult.failure.message,
      );
    }

    final remoteResult = await repository.syncFavoriteCategories(
      userId: userId,
      categoryNames: categoryNames,
    );

    if (remoteResult is FailureResult) {
      return CategorySaveOutcome(
        isLocalSaved: true,
        isRemoteSynced: false,
        isPendingSync: true,
        errorMessage: remoteResult.failure.message,
      );
    }

    return const CategorySaveOutcome(
      isLocalSaved: true,
      isRemoteSynced: true,
      isPendingSync: false,
    );
  }
}
