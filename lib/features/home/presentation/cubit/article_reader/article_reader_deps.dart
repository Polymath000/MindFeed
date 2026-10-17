import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';

class ArticleReaderDependencies {
  final ArticlesRepository? articlesRepository;
  final ToggleStarUseCase? toggleStarUseCase;
  final ToggleBookmarkUseCase? toggleBookmarkUseCase;
  final GetArticleDetailsUseCase? getArticleDetailsUseCase;
  final DownloadArticleTextUseCase? downloadArticleTextUseCase;
  final ArticlesLocalDataSource? localDataSource;

  const ArticleReaderDependencies({
    this.articlesRepository,
    this.toggleStarUseCase,
    this.toggleBookmarkUseCase,
    this.getArticleDetailsUseCase,
    this.downloadArticleTextUseCase,
    this.localDataSource,
  });

  ArticlesRepository? resolveArticlesRepo() {
    if (articlesRepository != null) return articlesRepository;
    try {
      if (getIt.isRegistered<ArticlesRepository>()) {
        return getIt<ArticlesRepository>();
      }
    } catch (_) {}
    return null;
  }

  ToggleStarUseCase? resolveToggleStarUseCase() {
    if (toggleStarUseCase != null) return toggleStarUseCase;
    try {
      if (getIt.isRegistered<ToggleStarUseCase>()) {
        return getIt<ToggleStarUseCase>();
      }
    } catch (_) {}
    final repo = resolveArticlesRepo();
    return repo != null ? ToggleStarUseCase(repo) : null;
  }

  ToggleBookmarkUseCase? resolveToggleBookmarkUseCase() {
    if (toggleBookmarkUseCase != null) return toggleBookmarkUseCase;
    try {
      if (getIt.isRegistered<ToggleBookmarkUseCase>()) {
        return getIt<ToggleBookmarkUseCase>();
      }
    } catch (_) {}
    final repo = resolveArticlesRepo();
    return repo != null ? ToggleBookmarkUseCase(repo) : null;
  }

  GetArticleDetailsUseCase? resolveGetArticleDetailsUseCase() {
    if (getArticleDetailsUseCase != null) return getArticleDetailsUseCase;
    try {
      if (getIt.isRegistered<GetArticleDetailsUseCase>()) {
        return getIt<GetArticleDetailsUseCase>();
      }
    } catch (_) {}
    final repo = resolveArticlesRepo();
    return repo != null ? GetArticleDetailsUseCase(repo) : null;
  }

  DownloadArticleTextUseCase? resolveDownloadArticleTextUseCase() {
    if (downloadArticleTextUseCase != null) return downloadArticleTextUseCase;
    try {
      if (getIt.isRegistered<DownloadArticleTextUseCase>()) {
        return getIt<DownloadArticleTextUseCase>();
      }
    } catch (_) {}
    final ds = resolveLocalDataSource();
    return ds != null ? DownloadArticleTextUseCase(ds) : null;
  }

  ArticlesLocalDataSource? resolveLocalDataSource() {
    if (localDataSource != null) return localDataSource;
    try {
      if (getIt.isRegistered<ArticlesLocalDataSource>()) {
        return getIt<ArticlesLocalDataSource>();
      }
    } catch (_) {}
    return null;
  }

  static DownloadedArticleEntity mapToDownloadedEntity(EditorialNewsItem item) {
    return DownloadedArticleEntity(
      id: item.id,
      title: item.title,
      excerpt: item.excerpt,
      content: (item.content != null && item.content!.isNotEmpty)
          ? item.content!
          : item.excerpt,
      authorName: item.authorName,
      authorRole: item.authorRole,
      authorAvatar: item.authorAvatar,
      categoryId: item.categoryId ?? '',
      categorySlug: item.categorySlug ?? item.badge.toLowerCase(),
      tags: item.tags,
      publishedAt: item.publishedAt ?? DateTime.now(),
      readingTimeMinutes: item.readingTimeMinutes,
      downloadedAt: DateTime.now(),
    );
  }
}
