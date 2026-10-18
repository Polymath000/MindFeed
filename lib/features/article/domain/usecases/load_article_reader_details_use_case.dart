import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import '../entities/article_reader_details.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class LoadArticleReaderDetailsUseCase {
  final ArticlesRepository articlesRepository;
  final OfflineArticlesRepository offlineRepository;
  final ArticleEngagementRepository engagementRepository;

  const LoadArticleReaderDetailsUseCase({
    required this.articlesRepository,
    required this.offlineRepository,
    required this.engagementRepository,
  });

  const LoadArticleReaderDetailsUseCase.positional(
    this.articlesRepository,
    this.offlineRepository,
    this.engagementRepository,
  );

  Future<ApiResult<ArticleReaderDetails>> call({
    required String articleId,
    String? userId,
  }) async {
    final trimmedId = articleId.trim();
    if (trimmedId.isEmpty) {
      return const FailureResult(
        ValidationFailure('Article ID cannot be empty'),
      );
    }

    final articleFuture = articlesRepository.getArticleById(trimmedId);
    final isDownloadedFuture = _checkDownloadedSafely(trimmedId);

    final articleResult = await articleFuture;
    return switch (articleResult) {
      FailureResult(:final failure) => FailureResult(failure),
      Success(:final data) => _loadEngagements(
          article: data,
          articleId: trimmedId,
          userId: userId,
          isDownloadedFuture: isDownloadedFuture,
        ),
    };
  }

  Future<bool> _checkDownloadedSafely(String id) async {
    try {
      final downloaded = await offlineRepository.getDownloadedArticleById(id);
      return downloaded != null;
    } catch (_) {
      return false;
    }
  }

  Future<ApiResult<ArticleReaderDetails>> _loadEngagements({
    required ArticleEntity article,
    required String articleId,
    required String? userId,
    required Future<bool> isDownloadedFuture,
  }) async {
    final isDownloaded = await isDownloadedFuture;
    final isLiked = await _resolveIsLiked(articleId, userId, article.isLiked);
    final isSaved = await _resolveIsSaved(articleId, userId, article.isSaved);
    final authorRating = await _resolveAuthorRating(article);
    final likeCount =
        article.likesCount > 0 ? article.likesCount : article.starCount;

    return Success(
      ArticleReaderDetails(
        article: article,
        isLiked: isLiked,
        likeCount: likeCount,
        isSaved: isSaved,
        isDownloaded: isDownloaded,
        authorRating: authorRating,
      ),
    );
  }

  Future<bool> _resolveIsLiked(
    String articleId,
    String? userId,
    bool fallback,
  ) async {
    final trimmedUserId = userId?.trim();
    if (trimmedUserId == null || trimmedUserId.isEmpty) return fallback;
    try {
      final res =
          await engagementRepository.isArticleLiked(articleId, trimmedUserId);
      return switch (res) {
        Success(:final data) => data,
        FailureResult() => fallback,
      };
    } catch (_) {
      return fallback;
    }
  }

  Future<bool> _resolveIsSaved(
    String articleId,
    String? userId,
    bool fallback,
  ) async {
    final trimmedUserId = userId?.trim();
    if (trimmedUserId == null || trimmedUserId.isEmpty) return fallback;
    try {
      final res =
          await articlesRepository.isArticleSaved(articleId, trimmedUserId);
      return switch (res) {
        Success(:final data) => data,
        FailureResult() => fallback,
      };
    } catch (_) {
      return fallback;
    }
  }

  Future<AuthorRatingSummary> _resolveAuthorRating(ArticleEntity article) async {
    final authorKey = _resolveAuthorKey(article);
    try {
      final res = await engagementRepository.getAuthorRatingSummary(
        authorKey: authorKey,
        authorId: article.authorId,
        authorName: article.authorName,
      );
      return switch (res) {
        Success(:final data) => data,
        FailureResult() => _fallbackAuthorRating(article, authorKey),
      };
    } catch (_) {
      return _fallbackAuthorRating(article, authorKey);
    }
  }

  AuthorRatingSummary _fallbackAuthorRating(
    ArticleEntity article,
    String authorKey,
  ) {
    return AuthorRatingSummary(
      authorKey: authorKey,
      userStars: article.userAuthorStars,
      ratingAvg: article.authorRatingAvg,
      ratingCount: article.authorRatingCount,
    );
  }

  String _resolveAuthorKey(ArticleEntity article) {
    final authorId = article.authorId?.trim();
    if (authorId != null && authorId.isNotEmpty) {
      return authorId;
    }
    final authorName = article.authorName.trim().toLowerCase();
    return authorName.isNotEmpty ? authorName : 'editorial_staff';
  }
}
