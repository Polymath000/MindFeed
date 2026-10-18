import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class ReconcileCategorySyncUseCase {
  final ProfileRepository _profileRepository;

  const ReconcileCategorySyncUseCase(this._profileRepository);

  Future<bool> call({String? userId}) async {
    return _profileRepository.reconcilePendingCategorySync(userId: userId);
  }
}

