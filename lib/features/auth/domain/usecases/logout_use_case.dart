import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class LogoutUseCase {
  final AuthRepository authRepo;
  final ArticlesRepository? articlesRepo;
  final OfflineArticlesRepository? localDataSource;

  LogoutUseCase({
    required this.authRepo,
    this.articlesRepo,
    this.localDataSource,
  });

  Future<ApiResult<void>> call() async {
    try {
      if (articlesRepo != null) {
        await articlesRepo!.clearDownloadedArticles();
      } else if (localDataSource != null) {
        await localDataSource!.clearAllDownloadedArticles();
      }
    } catch (_) {}
    return authRepo.logout();
  }
}
