import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';
import 'article_reader_deps.dart';
import 'article_reader_state.dart';

export 'article_reader_state.dart';

class ArticleReaderCubit extends Cubit<ArticleReaderState> {
  final GetArticleDetailsUseCase? _getArticleDetailsUseCase;
  final ToggleArticleLikeUseCase? _toggleArticleLikeUseCase;
  final ToggleBookmarkUseCase? _toggleBookmarkUseCase;
  final RateAuthorUseCase? _rateAuthorUseCase;
  final GetAuthorRatingUseCase? _getAuthorRatingUseCase;
  final DownloadArticleTextUseCase? _downloadArticleTextUseCase;
  final ToggleStarUseCase? _toggleStarUseCase;
  final ArticlesRepository? _articlesRepository;
  final OfflineArticlesRepository? _localDataSource;
  final String? _currentUserId;

  ArticleReaderCubit({
    GetArticleDetailsUseCase? getArticleDetailsUseCase,
    ToggleArticleLikeUseCase? toggleArticleLikeUseCase,
    ToggleBookmarkUseCase? toggleBookmarkUseCase,
    RateAuthorUseCase? rateAuthorUseCase,
    GetAuthorRatingUseCase? getAuthorRatingUseCase,
    DownloadArticleTextUseCase? downloadArticleTextUseCase,
    ToggleStarUseCase? toggleStarUseCase,
    ArticlesRepository? articlesRepository,
    OfflineArticlesRepository? localDataSource,
    String? currentUserId,
  })  : _articlesRepository = articlesRepository ?? _resolve<ArticlesRepository>(),
        _localDataSource = localDataSource ?? _resolve<OfflineArticlesRepository>(),
        _getArticleDetailsUseCase = getArticleDetailsUseCase ??
            _resolveUseCase(
              articlesRepository,
              (repo) => GetArticleDetailsUseCase(repo),
            ),
        _toggleArticleLikeUseCase = toggleArticleLikeUseCase ??
            _resolveEngagementUseCase(
              articlesRepository,
              (repo) => ToggleArticleLikeUseCase(repo),
            ),
        _toggleBookmarkUseCase = toggleBookmarkUseCase ??
            _resolveUseCase(
              articlesRepository,
              (repo) => ToggleBookmarkUseCase(repo),
            ),
        _rateAuthorUseCase = rateAuthorUseCase ??
            _resolveEngagementUseCase(
              articlesRepository,
              (repo) => RateAuthorUseCase(repo),
            ),
        _getAuthorRatingUseCase = getAuthorRatingUseCase ??
            _resolveEngagementUseCase(
              articlesRepository,
              (repo) => GetAuthorRatingUseCase(repo),
            ),
        _downloadArticleTextUseCase = downloadArticleTextUseCase ??
            _resolveLocalDsUseCase(
              localDataSource,
              (ds) => DownloadArticleTextUseCase(ds),
            ),
        _toggleStarUseCase = toggleStarUseCase ??
            _resolveUseCase(
              articlesRepository,
              (repo) => ToggleStarUseCase(repo),
            ),
        _currentUserId = currentUserId,
        super(const ArticleReaderInitial());

  static T? _resolve<T extends Object>() {
    try {
      if (getIt.isRegistered<T>()) return getIt<T>();
    } catch (_) {}
    return null;
  }

  static T? _resolveUseCase<T extends Object>(
    ArticlesRepository? repo,
    T Function(ArticlesRepository repo) factory,
  ) {
    if (repo != null) return factory(repo);
    return _resolve<T>();
  }

  static T? _resolveEngagementUseCase<T extends Object>(
    ArticlesRepository? repo,
    T Function(ArticleEngagementRepository repo) factory,
  ) {
    if (repo is ArticleEngagementRepository) {
      return factory(repo as ArticleEngagementRepository);
    }
    return _resolve<T>();
  }

  static T? _resolveLocalDsUseCase<T extends Object>(
    OfflineArticlesRepository? ds,
    T Function(OfflineArticlesRepository ds) factory,
  ) {
    if (ds != null) return factory(ds);
    return _resolve<T>();
  }

  ArticleEngagementRepository? get _engagementRepo {
    if (_articlesRepository is ArticleEngagementRepository) {
      return _articlesRepository as ArticleEngagementRepository;
    }
    return _resolve<ArticleEngagementRepository>();
  }

  String? _getUserId() => _currentUserId ?? CurrentUserSession.currentUserId;

  void toggleSlowScroll() {
    if (state is ArticleReaderLoaded) {
      final s = state as ArticleReaderLoaded;
      emit(s.copyWith(isSlowScrolling: !s.isSlowScrolling, clearFeedback: true));
    } else {
      emit(ArticleReaderLoaded(isSlowScrolling: !state.isSlowScrolling));
    }
  }

  void stopSlowScroll() {
    if (state is ArticleReaderLoaded) {
      final s = state as ArticleReaderLoaded;
      if (s.isSlowScrolling) emit(s.copyWith(isSlowScrolling: false));
    } else if (state.isSlowScrolling) {
      emit(const ArticleReaderLoaded(isSlowScrolling: false));
    }
  }

  void setScrollPace(double pace) {
    if (state is ArticleReaderLoaded) {
      final s = state as ArticleReaderLoaded;
      emit(s.copyWith(scrollPace: pace, clearFeedback: true));
    } else {
      emit(ArticleReaderLoaded(scrollPace: pace));
    }
  }

  void toggleScrollBarRetracted() {
    if (state is ArticleReaderLoaded) {
      final s = state as ArticleReaderLoaded;
      emit(s.copyWith(
        isScrollBarRetracted: !s.isScrollBarRetracted,
        clearFeedback: true,
      ));
    } else {
      emit(ArticleReaderLoaded(
        isScrollBarRetracted: !state.isScrollBarRetracted,
      ));
    }
  }

  Future<void> initArticle(EditorialNewsItem? item) async {
    if (item == null) {
      if (!isClosed) emit(const ArticleReaderError('Article not found'));
      return;
    }
    _emitInitialLoaded(item);
    await _checkDownloaded(item.id);
    await _checkUserEngagement(item.id);
    await _fetchAuthorRating(item);
    await _fetchArticleDetailsIfNeeded(item);
  }

  void _emitInitialLoaded(EditorialNewsItem item) {
    if (isClosed) return;
    final initialLiked = item.isLiked || item.isStarred;
    final initialCount = item.likesCount > 0 ? item.likesCount : item.starCount;
    final initialItem = item.copyWith(
      isLiked: initialLiked,
      isStarred: initialLiked,
      likesCount: initialCount,
      starCount: initialCount,
      isSaved: item.isSaved,
      authorRatingAvg: item.authorRatingAvg,
      authorRatingCount: item.authorRatingCount,
      userAuthorStars: item.userAuthorStars,
    );
    emit(ArticleReaderLoaded(
      item: initialItem,
      isLiked: initialLiked,
      likeCount: initialCount,
      isStarred: initialLiked,
      starCount: initialCount,
      isSaved: item.isSaved,
      authorRatingAvg: item.authorRatingAvg,
      authorRatingCount: item.authorRatingCount,
      userAuthorStars: item.userAuthorStars,
    ));
  }

  Future<void> _checkDownloaded(String id) async {
    if (_localDataSource == null) return;
    try {
      final d = await _localDataSource.getDownloadedArticleById(id);
      if (d != null && !isClosed && state is ArticleReaderLoaded) {
        emit((state as ArticleReaderLoaded).copyWith(isDownloaded: true));
      }
    } catch (_) {}
  }

  Future<void> _checkUserEngagement(String articleId) async {
    final userId = _getUserId();
    if (userId == null) return;
    await _checkLiked(articleId, userId);
    await _checkSaved(articleId, userId);
  }

  Future<void> _checkLiked(String articleId, String userId) async {
    final engRepo = _engagementRepo;
    if (engRepo != null) {
      final res = await engRepo.isArticleLiked(articleId, userId);
      res.when(success: _updateLikedState, failure: (_) {});
      return;
    }
    if (_articlesRepository != null) {
      final res = await _articlesRepository.isArticleStarred(articleId, userId);
      res.when(success: _updateLikedState, failure: (_) {});
    }
  }

  void _updateLikedState(bool liked) {
    if (isClosed || state is! ArticleReaderLoaded) return;
    final s = state as ArticleReaderLoaded;
    final updatedItem = s.item?.copyWith(isLiked: liked, isStarred: liked);
    emit(s.copyWith(item: updatedItem, isLiked: liked, isStarred: liked));
  }

  Future<void> _checkSaved(String articleId, String userId) async {
    if (_articlesRepository == null) return;
    final res = await _articlesRepository.isArticleSaved(articleId, userId);
    res.when(
      success: (saved) {
        if (isClosed || state is! ArticleReaderLoaded) return;
        final s = state as ArticleReaderLoaded;
        emit(s.copyWith(item: s.item?.copyWith(isSaved: saved), isSaved: saved));
      },
      failure: (_) {},
    );
  }

  Future<void> _fetchAuthorRating(EditorialNewsItem item) async {
    if (_getAuthorRatingUseCase == null) return;
    final res = await _getAuthorRatingUseCase.call(
      authorKey: item.authorKey,
      authorId: item.authorId,
      authorName: item.authorName,
    );
    res.when(
      success: (s) {
        if (isClosed || state is! ArticleReaderLoaded) return;
        final loaded = state as ArticleReaderLoaded;
        final updated = loaded.item?.copyWith(
          authorRatingAvg: s.ratingAvg,
          authorRatingCount: s.ratingCount,
          userAuthorStars: s.userStars,
        );
        emit(loaded.copyWith(
          item: updated,
          authorRatingAvg: s.ratingAvg,
          authorRatingCount: s.ratingCount,
          userAuthorStars: s.userStars,
        ));
      },
      failure: (_) {},
    );
  }

  Future<void> _fetchArticleDetailsIfNeeded(EditorialNewsItem item) async {
    if (item.content != null && item.content!.isNotEmpty) return;
    if (_getArticleDetailsUseCase == null) return;
    final res = await _getArticleDetailsUseCase.call(item.id);
    res.when(
      success: (entity) {
        if (isClosed || state is! ArticleReaderLoaded) return;
        final loaded = state as ArticleReaderLoaded;
        final count = entity.likesCount > 0 ? entity.likesCount : entity.starCount;
        final mapped = entity.toEditorialNewsItem().copyWith(
          isStarred: loaded.isStarred,
          isLiked: loaded.isLiked,
          isSaved: loaded.isSaved,
          starCount: count,
          likesCount: count,
        );
        emit(loaded.copyWith(item: mapped, starCount: count, likeCount: count));
      },
      failure: (_) {},
    );
  }

  Future<void> rateAuthor(int stars) async {
    if (state is! ArticleReaderLoaded || stars < 1 || stars > 5) return;
    final loaded = state as ArticleReaderLoaded;
    final prevStars = loaded.userAuthorStars, prevAvg = loaded.authorRatingAvg, prevCnt = loaded.authorRatingCount;
    final newCnt = prevStars == 0 ? prevCnt + 1 : prevCnt;
    final newAvg = newCnt == 0 ? stars.toDouble() : double.parse(((prevAvg * prevCnt - prevStars + stars) / newCnt).toStringAsFixed(2));
    final optimisticItem = loaded.item?.copyWith(
      userAuthorStars: stars,
      authorRatingAvg: newAvg,
      authorRatingCount: newCnt,
    );
    if (!isClosed) {
      emit(loaded.copyWith(
        item: optimisticItem,
        userAuthorStars: stars,
        authorRatingAvg: newAvg,
        authorRatingCount: newCnt,
        clearFeedback: true,
      ));
    }
    await _executeRateAuthor(loaded, stars);
  }

  Future<void> _executeRateAuthor(ArticleReaderLoaded loaded, int stars) async {
    final item = loaded.item;
    final userId = _getUserId();
    if (userId == null) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Please sign in to rate authors'));
      return;
    }
    if (_rateAuthorUseCase == null) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Author rating unavailable'));
      return;
    }
    final res = await _rateAuthorUseCase.call(
      authorKey: item?.authorKey ?? '',
      stars: stars,
      authorId: item?.authorId,
      authorName: item?.authorName ?? 'Author',
    );
    if (!isClosed) _handleRateAuthorResult(res, loaded, stars);
  }

  void _handleRateAuthorResult(
    ApiResult<AuthorRatingSummary> res,
    ArticleReaderLoaded loaded,
    int stars,
  ) {
    res.when(
      success: (s) {
        final name = loaded.item?.authorName ?? 'Author';
        final updated = loaded.item?.copyWith(
          userAuthorStars: s.userStars,
          authorRatingAvg: s.ratingAvg,
          authorRatingCount: s.ratingCount,
        );
        emit(loaded.copyWith(
          item: updated,
          userAuthorStars: s.userStars,
          authorRatingAvg: s.ratingAvg,
          authorRatingCount: s.ratingCount,
          userFeedback: 'Rated $name $stars/5 stars',
        ));
      },
      failure: (f) => emit(loaded.copyWith(
        userFeedback: f.message.isNotEmpty ? f.message : 'Failed to rate author',
      )),
    );
  }

  Future<void> toggleLike() async {
    if (state is! ArticleReaderLoaded) return;
    final loaded = state as ArticleReaderLoaded;
    final item = loaded.item;
    if (item == null) return;
    final prevLiked = loaded.isLiked, prevCount = loaded.likeCount;
    final newLiked = !prevLiked;
    final newCount = newLiked ? prevCount + 1 : (prevCount > 0 ? prevCount - 1 : 0);
    final optimisticItem = item.copyWith(
      isLiked: newLiked,
      isStarred: newLiked,
      likesCount: newCount,
      starCount: newCount,
    );
    if (!isClosed) {
      emit(loaded.copyWith(
        item: optimisticItem,
        isLiked: newLiked,
        likeCount: newCount,
        isStarred: newLiked,
        starCount: newCount,
        clearFeedback: true,
      ));
    }
    await _executeToggleLike(loaded, item, prevLiked, newCount);
  }

  Future<void> toggleStar() => toggleLike();

  Future<void> _executeToggleLike(
    ArticleReaderLoaded loaded,
    EditorialNewsItem item,
    bool prevLiked,
    int newCount,
  ) async {
    final userId = _getUserId();
    if (userId == null) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Please sign in to endorse stories'));
      return;
    }
    if (_toggleArticleLikeUseCase != null) {
      await _performLikeUseCase(loaded, item, userId, prevLiked, newCount);
      return;
    }
    if (_toggleStarUseCase != null) {
      await _performStarUseCase(loaded, item, userId, prevLiked, newCount);
      return;
    }
    if (!isClosed) emit(loaded.copyWith(userFeedback: 'Star action unavailable'));
  }

  Future<void> _performLikeUseCase(
    ArticleReaderLoaded loaded,
    EditorialNewsItem item,
    String userId,
    bool prevLiked,
    int newCount,
  ) async {
    final res = await _toggleArticleLikeUseCase!.call(
      articleId: item.id,
      userId: userId,
      isCurrentlyLiked: prevLiked,
    );
    if (isClosed) return;
    res.when(
      success: (l) {
        final updated = loaded.item?.copyWith(
          isLiked: l,
          isStarred: l,
          likesCount: newCount,
          starCount: newCount,
        );
        emit(loaded.copyWith(
          item: updated,
          isLiked: l,
          likeCount: newCount,
          isStarred: l,
          starCount: newCount,
        ));
      },
      failure: (f) => emit(loaded.copyWith(
        userFeedback: f.message.isNotEmpty ? f.message : 'Failed to update like',
      )),
    );
  }

  Future<void> _performStarUseCase(
    ArticleReaderLoaded loaded,
    EditorialNewsItem item,
    String userId,
    bool prevLiked,
    int newCount,
  ) async {
    final res = await _toggleStarUseCase!.call(
      articleId: item.id,
      userId: userId,
      isCurrentlyStarred: prevLiked,
    );
    if (isClosed) return;
    res.when(
      success: (s) {
        final updated = loaded.item?.copyWith(
          isStarred: s,
          isLiked: s,
          starCount: newCount,
          likesCount: newCount,
        );
        emit(loaded.copyWith(
          item: updated,
          isLiked: s,
          likeCount: newCount,
          isStarred: s,
          starCount: newCount,
        ));
      },
      failure: (f) => emit(loaded.copyWith(
        userFeedback: f.message.isNotEmpty ? f.message : 'Failed to update star',
      )),
    );
  }

  Future<void> toggleBookmark() async {
    if (state is! ArticleReaderLoaded) return;
    final loaded = state as ArticleReaderLoaded;
    final item = loaded.item;
    if (item == null) return;
    final prevSaved = loaded.isSaved, newSaved = !prevSaved;
    final optimisticItem = item.copyWith(isSaved: newSaved);
    if (!isClosed) {
      emit(loaded.copyWith(
        item: optimisticItem,
        isSaved: newSaved,
        clearFeedback: true,
      ));
    }

    final userId = _getUserId();
    if (userId == null) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Please sign in to save stories'));
      return;
    }
    if (_toggleBookmarkUseCase == null) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Bookmark action unavailable'));
      return;
    }
    await _executeBookmarkUseCase(loaded, item.id, userId, prevSaved);
  }

  Future<void> _executeBookmarkUseCase(
    ArticleReaderLoaded loaded,
    String articleId,
    String userId,
    bool prevSaved,
  ) async {
    final res = await _toggleBookmarkUseCase!.call(
      articleId: articleId,
      userId: userId,
      isCurrentlySaved: prevSaved,
    );
    if (isClosed) return;
    res.when(
      success: (saved) {
        final updated = loaded.item?.copyWith(isSaved: saved);
        emit(loaded.copyWith(
          item: updated,
          isSaved: saved,
          userFeedback: saved ? 'Added to Saved Stories' : 'Removed from Saved Stories',
        ));
      },
      failure: (f) => emit(loaded.copyWith(
        userFeedback: f.message.isNotEmpty ? f.message : 'Failed to update bookmark',
      )),
    );
  }

  Future<void> downloadArticle() async {
    if (state is! ArticleReaderLoaded) return;
    final loaded = state as ArticleReaderLoaded;
    final item = loaded.item;
    if (item == null) return;
    if (_downloadArticleTextUseCase == null) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Download service unavailable'));
      return;
    }
    try {
      await _downloadArticleTextUseCase.call(ArticleReaderDependencies.mapToDownloadedEntity(item));
      if (!isClosed) {
        emit(loaded.copyWith(
          isDownloaded: true,
          userFeedback: 'Article saved for offline reading',
        ));
      }
    } catch (_) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Failed to download article'));
    }
  }
}
