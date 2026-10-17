import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';
import 'article_reader_deps.dart';
import 'article_reader_state.dart';

class ArticleReaderCubit extends Cubit<ArticleReaderState> {
  final ArticleReaderDependencies _deps;
  final String? _currentUserId;

  ArticleReaderCubit({
    ArticlesRepository? articlesRepository, ToggleStarUseCase? toggleStarUseCase,
    ToggleBookmarkUseCase? toggleBookmarkUseCase, GetArticleDetailsUseCase? getArticleDetailsUseCase,
    DownloadArticleTextUseCase? downloadArticleTextUseCase, ArticlesLocalDataSource? localDataSource,
    ToggleArticleLikeUseCase? toggleArticleLikeUseCase, RateAuthorUseCase? rateAuthorUseCase,
    GetAuthorRatingUseCase? getAuthorRatingUseCase, String? currentUserId,
  })  : _deps = ArticleReaderDependencies(
          articlesRepository: articlesRepository, toggleStarUseCase: toggleStarUseCase,
          toggleBookmarkUseCase: toggleBookmarkUseCase, getArticleDetailsUseCase: getArticleDetailsUseCase,
          downloadArticleTextUseCase: downloadArticleTextUseCase, localDataSource: localDataSource,
          toggleArticleLikeUseCase: toggleArticleLikeUseCase, rateAuthorUseCase: rateAuthorUseCase,
          getAuthorRatingUseCase: getAuthorRatingUseCase,
        ),
        _currentUserId = currentUserId,
        super(const ArticleReaderState());

  String? _getUserId() => _currentUserId ?? CurrentUserSession.currentUserId;
  void toggleSlowScroll() => emit(state.copyWith(isSlowScrolling: !state.isSlowScrolling, clearFeedback: true));
  void stopSlowScroll() { if (state.isSlowScrolling) emit(state.copyWith(isSlowScrolling: false)); }
  void setScrollPace(double pace) => emit(state.copyWith(scrollPace: pace, clearFeedback: true));
  void toggleScrollBarRetracted() => emit(state.copyWith(isScrollBarRetracted: !state.isScrollBarRetracted, clearFeedback: true));

  Future<void> initArticle(EditorialNewsItem? item) async {
    if (item == null) {
      emit(state.copyWith(status: ArticleReaderStatus.error, errorMessage: 'Article not found'));
      return;
    }
    final initialLiked = item.isLiked || item.isStarred;
    final initialLikeCount = item.likesCount > 0 ? item.likesCount : item.starCount;
    emit(state.copyWith(
      status: ArticleReaderStatus.ready, item: item, isLiked: initialLiked, likeCount: initialLikeCount,
      isStarred: initialLiked, starCount: initialLikeCount, isSaved: item.isSaved,
      authorRatingAvg: item.authorRatingAvg, authorRatingCount: item.authorRatingCount,
      userAuthorStars: item.userAuthorStars, clearFeedback: true,
    ));

    final localDs = _deps.resolveLocalDataSource();
    if (localDs != null) {
      try {
        final d = await localDs.getDownloadedArticleById(item.id);
        if (d != null) emit(state.copyWith(isDownloaded: true));
      } catch (_) {}
    }

    final userId = _getUserId(), repo = _deps.resolveArticlesRepo(), engRepo = _deps.resolveEngagementRepo();
    if (userId != null) {
      if (engRepo != null) {
        try {
          final res = await engRepo.isArticleLiked(item.id, userId);
          res.when(success: (liked) { item..isLiked = liked..isStarred = liked; emit(state.copyWith(isLiked: liked, isStarred: liked)); }, failure: (_) {});
        } catch (_) {}
      } else if (repo != null) {
        try {
          final res = await repo.isArticleStarred(item.id, userId);
          res.when(success: (starred) { item..isStarred = starred..isLiked = starred; emit(state.copyWith(isStarred: starred, isLiked: starred)); }, failure: (_) {});
        } catch (_) {}
      }
      if (repo != null) {
        try {
          final res = await repo.isArticleSaved(item.id, userId);
          res.when(success: (saved) { item.isSaved = saved; emit(state.copyWith(isSaved: saved)); }, failure: (_) {});
        } catch (_) {}
      }
    }

    final ratingUseCase = _deps.resolveGetAuthorRatingUseCase();
    if (ratingUseCase != null) {
      try {
        final res = await ratingUseCase.call(authorKey: item.authorKey, authorId: item.authorId, authorName: item.authorName);
        res.when(success: (s) {
          item..authorRatingAvg = s.ratingAvg..authorRatingCount = s.ratingCount..userAuthorStars = s.userStars;
          emit(state.copyWith(authorRatingAvg: s.ratingAvg, authorRatingCount: s.ratingCount, userAuthorStars: s.userStars));
        }, failure: (_) {});
      } catch (_) {}
    }

    if (item.content == null || item.content!.isEmpty) {
      final detailsUseCase = _deps.resolveGetArticleDetailsUseCase();
      if (detailsUseCase != null) {
        try {
          final res = await detailsUseCase.call(item.id);
          res.when(success: (e) {
            final count = e.likesCount > 0 ? e.likesCount : e.starCount;
            final m = e.toEditorialNewsItem()..isStarred = state.isStarred..isLiked = state.isLiked..isSaved = state.isSaved..starCount = count..likesCount = count;
            emit(state.copyWith(item: m, starCount: count, likeCount: count));
          }, failure: (_) {});
        } catch (_) {}
      }
    }
  }

  Future<void> rateAuthor(int stars) async {
    final item = state.item;
    if (item == null || stars < 1 || stars > 5) return;
    final prevStars = state.userAuthorStars, prevAvg = state.authorRatingAvg, prevCnt = state.authorRatingCount;
    final newCnt = prevStars == 0 ? prevCnt + 1 : prevCnt;
    final newAvg = newCnt == 0 ? stars.toDouble() : double.parse(((prevAvg * prevCnt - prevStars + stars) / newCnt).toStringAsFixed(2));
    emit(state.copyWith(userAuthorStars: stars, authorRatingAvg: newAvg, authorRatingCount: newCnt, clearFeedback: true));

    final userId = _getUserId();
    if (userId == null) {
      emit(state.copyWith(userAuthorStars: prevStars, authorRatingAvg: prevAvg, authorRatingCount: prevCnt, userFeedback: 'Please sign in to rate authors'));
      return;
    }
    final useCase = _deps.resolveRateAuthorUseCase();
    if (useCase == null) {
      emit(state.copyWith(userAuthorStars: prevStars, authorRatingAvg: prevAvg, authorRatingCount: prevCnt, userFeedback: 'Author rating unavailable'));
      return;
    }
    try {
      final res = await useCase.call(authorKey: item.authorKey, stars: stars, authorId: item.authorId, authorName: item.authorName);
      res.when(
        success: (s) {
          item..userAuthorStars = s.userStars..authorRatingAvg = s.ratingAvg..authorRatingCount = s.ratingCount;
          emit(state.copyWith(userAuthorStars: s.userStars, authorRatingAvg: s.ratingAvg, authorRatingCount: s.ratingCount, userFeedback: 'Rated ${item.authorName} $stars/5 stars'));
        },
        failure: (f) => emit(state.copyWith(userAuthorStars: prevStars, authorRatingAvg: prevAvg, authorRatingCount: prevCnt, userFeedback: f.message.isNotEmpty ? f.message : 'Failed to rate author')),
      );
    } catch (_) {
      emit(state.copyWith(userAuthorStars: prevStars, authorRatingAvg: prevAvg, authorRatingCount: prevCnt, userFeedback: 'Failed to rate author'));
    }
  }

  Future<void> toggleLike() async {
    final item = state.item;
    if (item == null) return;
    final prevLiked = state.isLiked, prevCount = state.likeCount, newLiked = !prevLiked;
    final newCount = newLiked ? prevCount + 1 : (prevCount > 0 ? prevCount - 1 : 0);
    emit(state.copyWith(isLiked: newLiked, likeCount: newCount, isStarred: newLiked, starCount: newCount, clearFeedback: true));

    final userId = _getUserId();
    if (userId == null) {
      emit(state.copyWith(isLiked: prevLiked, likeCount: prevCount, isStarred: prevLiked, starCount: prevCount, userFeedback: 'Please sign in to endorse stories'));
      return;
    }
    final likeUseCase = _deps.resolveToggleArticleLikeUseCase();
    if (likeUseCase != null) {
      try {
        final res = await likeUseCase.call(articleId: item.id, userId: userId, isCurrentlyLiked: prevLiked);
        res.when(
          success: (l) { item..isLiked = l..isStarred = l..likesCount = newCount..starCount = newCount; emit(state.copyWith(isLiked: l, likeCount: newCount, isStarred: l, starCount: newCount)); },
          failure: (f) => emit(state.copyWith(isLiked: prevLiked, likeCount: prevCount, isStarred: prevLiked, starCount: prevCount, userFeedback: f.message.isNotEmpty ? f.message : 'Failed to update like')),
        );
      } catch (_) { emit(state.copyWith(isLiked: prevLiked, likeCount: prevCount, isStarred: prevLiked, starCount: prevCount, userFeedback: 'Failed to update like')); }
      return;
    }
    final starUseCase = _deps.resolveToggleStarUseCase();
    if (starUseCase == null) {
      emit(state.copyWith(isLiked: prevLiked, likeCount: prevCount, isStarred: prevLiked, starCount: prevCount, userFeedback: 'Star action unavailable'));
      return;
    }
    try {
      final res = await starUseCase.call(articleId: item.id, userId: userId, isCurrentlyStarred: prevLiked);
      res.when(
        success: (s) { item..isStarred = s..isLiked = s..starCount = newCount..likesCount = newCount; emit(state.copyWith(isLiked: s, likeCount: newCount, isStarred: s, starCount: newCount)); },
        failure: (f) => emit(state.copyWith(isLiked: prevLiked, likeCount: prevCount, isStarred: prevLiked, starCount: prevCount, userFeedback: f.message.isNotEmpty ? f.message : 'Failed to update star')),
      );
    } catch (_) { emit(state.copyWith(isLiked: prevLiked, likeCount: prevCount, isStarred: prevLiked, starCount: prevCount, userFeedback: 'Failed to update star')); }
  }

  Future<void> toggleStar() => toggleLike();

  Future<void> toggleBookmark() async {
    final item = state.item;
    if (item == null) return;
    final prevSaved = state.isSaved, newSaved = !prevSaved;
    emit(state.copyWith(isSaved: newSaved, clearFeedback: true));
    final userId = _getUserId();
    if (userId == null) { emit(state.copyWith(isSaved: prevSaved, userFeedback: 'Please sign in to save stories')); return; }
    final useCase = _deps.resolveToggleBookmarkUseCase();
    if (useCase == null) { emit(state.copyWith(isSaved: prevSaved, userFeedback: 'Bookmark action unavailable')); return; }
    try {
      final res = await useCase.call(articleId: item.id, userId: userId, isCurrentlySaved: prevSaved);
      res.when(
        success: (saved) { item.isSaved = saved; emit(state.copyWith(isSaved: saved, userFeedback: saved ? 'Added to Saved Stories' : 'Removed from Saved Stories')); },
        failure: (f) => emit(state.copyWith(isSaved: prevSaved, userFeedback: f.message.isNotEmpty ? f.message : 'Failed to update bookmark')),
      );
    } catch (_) { emit(state.copyWith(isSaved: prevSaved, userFeedback: 'Failed to update bookmark')); }
  }

  Future<void> downloadArticle() async {
    final item = state.item;
    if (item == null) return;
    final useCase = _deps.resolveDownloadArticleTextUseCase();
    if (useCase == null) { emit(state.copyWith(userFeedback: 'Download service unavailable')); return; }
    try {
      await useCase.call(ArticleReaderDependencies.mapToDownloadedEntity(item));
      emit(state.copyWith(isDownloaded: true, userFeedback: 'Article saved for offline reading'));
    } catch (_) {
      emit(state.copyWith(userFeedback: 'Failed to download article'));
    }
  }
}
