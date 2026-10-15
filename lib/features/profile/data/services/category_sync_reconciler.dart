import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mind_feed/features/profile/data/repos/profile_repo_impl.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class CategorySyncReconciler {
  final ProfileRepository _profileRepository;

  CategorySyncReconciler({
    ProfileRepository? profileRepository,
    ProfileRemoteDataSource? remoteDataSource,
  }) : _profileRepository = profileRepository ??
            ProfileRepoImpl(
              remoteDataSource: remoteDataSource ?? ProfileRemoteDataSourceImpl(),
            );

  Future<bool> reconcilePendingSync({String? userId}) async {
    return _profileRepository.reconcilePendingCategorySync(userId: userId);
  }
}
