import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/entities/author_rating_summary.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/author/domain/entities/author_dossier_entity.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';

class LoadAuthorProfileDossierUseCase {
  final GetHomeFeedUseCase _getHomeFeedUseCase;
  final GetArticlesByAuthorUseCase? _getArticlesByAuthorUseCase;
  final GetUserProfileUseCase? _getUserProfileUseCase;
  final GetAuthorFollowSummaryUseCase? _getAuthorFollowSummaryUseCase;
  final GetAuthorRatingUseCase? _getAuthorRatingUseCase;

  const LoadAuthorProfileDossierUseCase({
    required GetHomeFeedUseCase getHomeFeedUseCase,
    GetArticlesByAuthorUseCase? getArticlesByAuthorUseCase,
    GetUserProfileUseCase? getUserProfileUseCase,
    GetAuthorFollowSummaryUseCase? getAuthorFollowSummaryUseCase,
    GetAuthorRatingUseCase? getAuthorRatingUseCase,
  })  : _getHomeFeedUseCase = getHomeFeedUseCase,
        _getArticlesByAuthorUseCase = getArticlesByAuthorUseCase,
        _getUserProfileUseCase = getUserProfileUseCase,
        _getAuthorFollowSummaryUseCase = getAuthorFollowSummaryUseCase,
        _getAuthorRatingUseCase = getAuthorRatingUseCase;

  Future<ApiResult<AuthorDossierEntity>> call({
    required String authorName,
    String? authorId,
    String? fallbackRole,
    String? fallbackAvatar,
    String? viewerUserId,
  }) async {
    final rawArticlesResult = await _fetchRawArticles(
      authorName: authorName,
      authorId: authorId,
    );

    if (rawArticlesResult is FailureResult<List<ArticleEntity>>) {
      return FailureResult(rawArticlesResult.failure);
    }

    final rawArticles =
        (rawArticlesResult as Success<List<ArticleEntity>>).data;

    final publishedArticles = rawArticles
        .where((a) => a.status.toLowerCase() == 'published')
        .toList();

    final resolvedAuthorId = _resolveAuthorId(
      authorId: authorId,
      articles: publishedArticles,
    );

    var (displayName, bio, avatarUrl) = _resolveInitialProfile(
      authorName: authorName,
      fallbackRole: fallbackRole,
      fallbackAvatar: fallbackAvatar,
      articles: publishedArticles,
    );

    if (AuthorFollowValidator.isValidUuid(resolvedAuthorId) &&
        _getUserProfileUseCase != null) {
      final profileOverrides =
          await _fetchProfileOverrides(resolvedAuthorId!);
      if (profileOverrides.displayName.isNotEmpty) {
        displayName = profileOverrides.displayName;
      }
      if (profileOverrides.bio.isNotEmpty) {
        bio = profileOverrides.bio;
      }
      if (profileOverrides.avatarUrl.isNotEmpty) {
        avatarUrl = profileOverrides.avatarUrl;
      }
    }

    final hasConcreteIdentity =
        (resolvedAuthorId != null && resolvedAuthorId.isNotEmpty) ||
        authorName.trim().isNotEmpty ||
        publishedArticles.isNotEmpty;

    final authorKey = hasConcreteIdentity
        ? AuthorFollowValidator.resolveAuthorKey(
            authorId: resolvedAuthorId,
            authorName: displayName,
          )
        : '';

    final followSummary = await _fetchFollowSummary(
      targetUserId: resolvedAuthorId,
      authorKey: authorKey,
      authorName: displayName,
      viewerUserId: viewerUserId,
    );

    final canFollow = AuthorFollowValidator.canShowFollowButton(
      authorId: resolvedAuthorId,
      authorKey: authorKey,
      viewerUserId: viewerUserId,
    );
    final canRate = hasConcreteIdentity &&
        !AuthorFollowValidator.isSelf(
          authorId: resolvedAuthorId,
          authorKey: authorKey,
          viewerUserId: viewerUserId,
        );

    final ratingSummary = await _fetchRatingSummary(
      authorKey: authorKey,
      authorId: resolvedAuthorId,
      displayName: displayName,
      articles: publishedArticles,
    );

    final topics = publishedArticles
        .map((a) => a.badge.trim())
        .where((b) => b.isNotEmpty)
        .toSet()
        .toList();

    return Success(
      AuthorDossierEntity(
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
        authorKey: authorKey,
        authorId: resolvedAuthorId,
        publishedArticles: publishedArticles,
        topics: topics,
        followSummary: followSummary,
        canFollow: canFollow,
        canRate: canRate,
        ratingSummary: ratingSummary,
      ),
    );
  }

  Future<ApiResult<List<ArticleEntity>>> _fetchRawArticles({
    required String authorName,
    String? authorId,
  }) async {
    final cleanId = authorId?.trim();
    if (cleanId != null &&
        cleanId.isNotEmpty &&
        _getArticlesByAuthorUseCase != null) {
      return _getArticlesByAuthorUseCase(cleanId);
    }

    final homeResult = await _getHomeFeedUseCase();
    return homeResult.when(
      failure: (failure) => FailureResult(failure),
      success: (articles) {
        final matches = articles
            .where((a) => a.authorName.trim() == authorName.trim())
            .toList();
        return Success(matches);
      },
    );
  }

  String? _resolveAuthorId({
    String? authorId,
    required List<ArticleEntity> articles,
  }) {
    final cleanId = authorId?.trim();
    if (cleanId != null && cleanId.isNotEmpty) return cleanId;
    if (articles.isNotEmpty) {
      final firstId = articles.first.authorId?.trim();
      if (firstId != null && firstId.isNotEmpty) return firstId;
    }
    return null;
  }

  (String, String, String) _resolveInitialProfile({
    required String authorName,
    String? fallbackRole,
    String? fallbackAvatar,
    required List<ArticleEntity> articles,
  }) {
    var name = authorName.trim();
    if (name.isEmpty && articles.isNotEmpty) {
      name = articles.first.authorName.trim();
    }
    if (name.isEmpty) {
      name = 'MindFeed Author';
    }

    var bio = fallbackRole?.trim() ?? '';

    var avatar = fallbackAvatar?.trim();
    if ((avatar == null || avatar.isEmpty) && articles.isNotEmpty) {
      avatar = articles.first.authorAvatar?.trim();
    }
    if (avatar == null || avatar.isEmpty) {
      avatar = AppConstants.defaultAvatarUrl;
    }

    return (name, bio, avatar);
  }

  Future<({String displayName, String bio, String avatarUrl})>
      _fetchProfileOverrides(String userId) async {
    try {
      final res = await _getUserProfileUseCase!(userId);
      if (res is Success<Map<String, dynamic>>) {
        final profile = res.data;
        final pName = (profile['display_name'] ??
                profile['full_name'] ??
                profile['username'])
            ?.toString()
            .trim() ??
            '';
        final pBio = profile['bio']?.toString().trim() ?? '';
        final pAvatar = profile['avatar_url']?.toString().trim() ?? '';
        return (displayName: pName, bio: pBio, avatarUrl: pAvatar);
      }
      return (displayName: '', bio: '', avatarUrl: '');
    } catch (_) {
      return (displayName: '', bio: '', avatarUrl: '');
    }
  }

  Future<AuthorFollowSummary> _fetchFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? authorName,
    String? viewerUserId,
  }) async {
    final resolvedKey = AuthorFollowValidator.resolveAuthorKey(
      authorId: targetUserId,
      authorKey: authorKey,
      authorName: authorName,
    );
    if (_getAuthorFollowSummaryUseCase == null ||
        (resolvedKey.isEmpty &&
            !AuthorFollowValidator.isValidUuid(targetUserId))) {
      return const AuthorFollowSummary();
    }

    final res = await _getAuthorFollowSummaryUseCase(
      targetUserId: targetUserId,
      authorKey: resolvedKey,
      authorName: authorName,
      viewerUserId: viewerUserId,
    );
    return res.when(
      failure: (_) => const AuthorFollowSummary(),
      success: (summary) => summary,
    );
  }

  Future<AuthorRatingSummary> _fetchRatingSummary({
    required String authorKey,
    String? authorId,
    required String displayName,
    required List<ArticleEntity> articles,
  }) async {
    final fallbackSummary = AuthorRatingSummary(
      authorKey: authorKey,
      userStars: articles.isNotEmpty ? articles.first.userAuthorStars : 0,
      ratingAvg: articles.isNotEmpty ? articles.first.authorRatingAvg : 0.0,
      ratingCount: articles.isNotEmpty ? articles.first.authorRatingCount : 0,
    );

    if (_getAuthorRatingUseCase == null) {
      return fallbackSummary;
    }

    final res = await _getAuthorRatingUseCase(
      authorKey: authorKey,
      authorId: authorId,
      authorName: displayName,
    );

    return res.when(
      failure: (_) => fallbackSummary,
      success: (summary) => summary,
    );
  }
}
