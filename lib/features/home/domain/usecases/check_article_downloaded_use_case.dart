import '../repos/articles_repo.dart';

class CheckArticleDownloadedUseCase {
  final OfflineArticlesRepository repository;

  const CheckArticleDownloadedUseCase(this.repository);

  OfflineArticlesRepository get localDataSource => repository;

  Future<bool> call(String articleId) async {
    final trimmedId = articleId.trim();
    if (trimmedId.isEmpty) return false;
    try {
      final downloaded = await repository.getDownloadedArticleById(trimmedId);
      return downloaded != null;
    } catch (_) {
      return false;
    }
  }
}
