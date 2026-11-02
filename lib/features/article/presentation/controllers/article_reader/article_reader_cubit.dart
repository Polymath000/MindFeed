import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/articles/domain/entities/author_rating_summary.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/check_article_downloaded_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_liked_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_saved_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_starred_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';

import 'article_reader_deps.dart';
import 'article_reader_state.dart';

export 'article_reader_state.dart';

class ArticleReaderCubit extends Cubit<ArticleReaderState> {
  final GetArticleDetailsUseCase _getArticleDetailsUseCase;
  final CheckArticleDownloadedUseCase _checkArticleDownloadedUseCase;
  final DownloadArticleTextUseCase _downloadArticleTextUseCase;
  final IsArticleLikedUseCase _isArticleLikedUseCase;
  final ToggleArticleLikeUseCase _toggleArticleLikeUseCase;
  final IsArticleSavedUseCase _isArticleSavedUseCase;
  final ToggleBookmarkUseCase _toggleBookmarkUseCase;
  final RateAuthorUseCase _rateAuthorUseCase;
  final GetAuthorRatingUseCase _getAuthorRatingUseCase;
  final GetAuthorFollowSummaryUseCase? _getAuthorFollowSummaryUseCase;
  final ToggleAuthorFollowUseCase? _toggleAuthorFollowUseCase;
  final ToggleStarUseCase? _toggleStarUseCase;
  final IsArticleStarredUseCase? _isArticleStarredUseCase;
  final String? _currentUserId;

  ArticleReaderCubit({
    required GetArticleDetailsUseCase getArticleDetailsUseCase,
    required CheckArticleDownloadedUseCase checkArticleDownloadedUseCase,
    required DownloadArticleTextUseCase downloadArticleTextUseCase,
    required IsArticleLikedUseCase isArticleLikedUseCase,
    required ToggleArticleLikeUseCase toggleArticleLikeUseCase,
    required IsArticleSavedUseCase isArticleSavedUseCase,
    required ToggleBookmarkUseCase toggleBookmarkUseCase,
    required RateAuthorUseCase rateAuthorUseCase,
    required GetAuthorRatingUseCase getAuthorRatingUseCase,
    GetAuthorFollowSummaryUseCase? getAuthorFollowSummaryUseCase,
    ToggleAuthorFollowUseCase? toggleAuthorFollowUseCase,
    ToggleStarUseCase? toggleStarUseCase,
    IsArticleStarredUseCase? isArticleStarredUseCase,
    String? currentUserId,
  })  : _getArticleDetailsUseCase = getArticleDetailsUseCase,
        _checkArticleDownloadedUseCase = checkArticleDownloadedUseCase,
        _downloadArticleTextUseCase = downloadArticleTextUseCase,
        _isArticleLikedUseCase = isArticleLikedUseCase,
        _toggleArticleLikeUseCase = toggleArticleLikeUseCase,
        _isArticleSavedUseCase = isArticleSavedUseCase,
        _toggleBookmarkUseCase = toggleBookmarkUseCase,
        _rateAuthorUseCase = rateAuthorUseCase,
        _getAuthorRatingUseCase = getAuthorRatingUseCase,
        _getAuthorFollowSummaryUseCase = getAuthorFollowSummaryUseCase,
        _toggleAuthorFollowUseCase = toggleAuthorFollowUseCase,
        _toggleStarUseCase = toggleStarUseCase,
        _isArticleStarredUseCase = isArticleStarredUseCase,
        _currentUserId = currentUserId,
        super(const ArticleReaderInitial());

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
    await _fetchAuthorFollowState(item);
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
    final canFollow = AuthorFollowValidator.canShowFollowButton(
      authorId: item.authorId,
      viewerUserId: _getUserId(),
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
      canFollowAuthor: canFollow,
      isFollowingAuthor: false,
      isFollowLoading: false,
    ));
  }

  Future<void> _checkDownloaded(String id) async {
    try {
      final isDownloaded = await _checkArticleDownloadedUseCase.call(id);
      if (isDownloaded && !isClosed && state is ArticleReaderLoaded) {
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
    final res = await _isArticleLikedUseCase.call(
      articleId: articleId,
      userId: userId,
    );
    res.when(
      success: _updateLikedState,
      failure: (_) async {
        if (_isArticleStarredUseCase != null) {
          final starRes = await _isArticleStarredUseCase.call(
            articleId: articleId,
            userId: userId,
          );
          starRes.when(success: _updateLikedState, failure: (_) {});
        }
      },
    );
  }

  void _updateLikedState(bool liked) {
    if (isClosed || state is! ArticleReaderLoaded) return;
    final s = state as ArticleReaderLoaded;
    final updatedItem = s.item?.copyWith(isLiked: liked, isStarred: liked);
    emit(s.copyWith(item: updatedItem, isLiked: liked, isStarred: liked));
  }

  Future<void> _checkSaved(String articleId, String userId) async {
    final res = await _isArticleSavedUseCase.call(
      articleId: articleId,
      userId: userId,
    );
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

  Future<void> _fetchAuthorFollowState(EditorialNewsItem item) async {
    final canFollow = AuthorFollowValidator.canShowFollowButton(
      authorId: item.authorId,
      viewerUserId: _getUserId(),
    );
    if (isClosed || state is! ArticleReaderLoaded) return;
    final current = state as ArticleReaderLoaded;
    if (current.canFollowAuthor != canFollow) {
      emit(current.copyWith(canFollowAuthor: canFollow));
    }
    if (!canFollow || _getAuthorFollowSummaryUseCase == null) return;

    final res = await _getAuthorFollowSummaryUseCase.call(
      targetUserId: item.authorId,
      viewerUserId: _getUserId(),
    );

    if (isClosed || state is! ArticleReaderLoaded) return;
    res.when(
      success: (summary) {
        if (!isClosed && state is ArticleReaderLoaded) {
          emit((state as ArticleReaderLoaded).copyWith(
            canFollowAuthor: canFollow,
            isFollowingAuthor: summary.isFollowing,
          ));
        }
      },
      failure: (_) {},
    );
  }

  Future<void> _fetchArticleDetailsIfNeeded(EditorialNewsItem item) async {
    if (item.content != null && item.content!.isNotEmpty) return;
    final res = await _getArticleDetailsUseCase.call(item.id);
    switch (res) {
      case Success(:final data):
        if (isClosed || state is! ArticleReaderLoaded) return;
        final loaded = state as ArticleReaderLoaded;
        final count = data.likesCount > 0 ? data.likesCount : data.starCount;
        final mapped = data.toEditorialNewsItem().copyWith(
          isStarred: loaded.isStarred,
          isLiked: loaded.isLiked,
          isSaved: loaded.isSaved,
          starCount: count,
          likesCount: count,
        );
        emit(loaded.copyWith(item: mapped, starCount: count, likeCount: count));
        await _fetchAuthorFollowState(mapped);
      case FailureResult():
        break;
    }
  }

  Future<void> toggleFollowAuthor() async {
    if (state is! ArticleReaderLoaded) return;
    final current = state as ArticleReaderLoaded;
    final authorId = current.article?.authorId;
    final viewerId = _getUserId();

    if (_toggleAuthorFollowUseCase == null ||
        !current.canFollowAuthor ||
        current.isFollowLoading) {
      return;
    }

    emit(current.copyWith(isFollowLoading: true, clearFeedback: true));

    final res = await _toggleAuthorFollowUseCase.call(
      followerId: viewerId,
      authorId: authorId,
      currentlyFollowing: current.isFollowingAuthor,
    );

    if (isClosed || state is! ArticleReaderLoaded) return;
    final s = state as ArticleReaderLoaded;

    res.when(
      success: (summary) {
        final authorName = s.article?.authorName ?? 'author';
        final message = summary.isFollowing
            ? 'Following $authorName'
            : 'Unfollowed $authorName';
        emit(s.copyWith(
          isFollowLoading: false,
          isFollowingAuthor: summary.isFollowing,
          userFeedback: message,
        ));
      },
      failure: (failure) {
        emit(s.copyWith(
          isFollowLoading: false,
          userFeedback: failure.message,
        ));
      },
    );
  }

  Future<void> rateAuthor(int stars) async {
    if (state is! ArticleReaderLoaded || stars < 1 || stars > 5) return;
    final loaded = state as ArticleReaderLoaded;
    final prevStars = loaded.userAuthorStars,
        prevAvg = loaded.authorRatingAvg,
        prevCnt = loaded.authorRatingCount;
    final newCnt = prevStars == 0 ? prevCnt + 1 : prevCnt;
    final newAvg = newCnt == 0
        ? stars.toDouble()
        : double.parse(((prevAvg * prevCnt - prevStars + stars) / newCnt).toStringAsFixed(2));
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

  Future<void> toggleStar() async {
    if (_toggleStarUseCase != null) {
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
      final userId = _getUserId();
      if (userId == null) {
        if (!isClosed) emit(loaded.copyWith(userFeedback: 'Please sign in to endorse stories'));
        return;
      }
      await _performStarUseCase(loaded, item, userId, prevLiked, newCount);
      return;
    }
    await toggleLike();
  }

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
    await _performLikeUseCase(loaded, item, userId, prevLiked, newCount);
  }

  Future<void> _performLikeUseCase(
    ArticleReaderLoaded loaded,
    EditorialNewsItem item,
    String userId,
    bool prevLiked,
    int newCount,
  ) async {
    final res = await _toggleArticleLikeUseCase.call(
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
    if (_toggleStarUseCase == null) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Star action unavailable'));
      return;
    }
    final res = await _toggleStarUseCase.call(
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
    await _executeBookmarkUseCase(loaded, item.id, userId, prevSaved);
  }

  Future<void> _executeBookmarkUseCase(
    ArticleReaderLoaded loaded,
    String articleId,
    String userId,
    bool prevSaved,
  ) async {
    final res = await _toggleBookmarkUseCase.call(
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
    try {
      await _downloadArticleTextUseCase.call(
        ArticleReaderDependencies.mapToDownloadedEntity(item),
      );
      if (!isClosed && state is ArticleReaderLoaded) {
        final currentLoaded = state as ArticleReaderLoaded;
        emit(currentLoaded.copyWith(
          isDownloaded: true,
          userFeedback: 'Article saved for offline reading',
        ));
      }
    } catch (_) {
      if (!isClosed) emit(loaded.copyWith(userFeedback: 'Failed to download article'));
    }
  }
}
