import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_user_feed_topics_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_article_like_use_case.dart';

import 'home_feed_state.dart';

class HomeFeedCubit extends Cubit<HomeFeedState> {
  final GetHomeFeedUseCase _getHomeFeedUseCase;
  final GetUserFeedTopicsUseCase _getUserFeedTopicsUseCase;
  final GetSavedArticlesUseCase _getSavedArticlesUseCase;
  final ToggleBookmarkUseCase _toggleBookmarkUseCase;
  final ToggleStarUseCase _toggleStarUseCase;
  final ToggleArticleLikeUseCase _toggleArticleLikeUseCase;
  final String? _currentUserId;
  final String? Function()? _userIdResolver;

  HomeFeedCubit({
    required GetHomeFeedUseCase getHomeFeedUseCase,
    required GetUserFeedTopicsUseCase getUserFeedTopicsUseCase,
    required GetSavedArticlesUseCase getSavedArticlesUseCase,
    required ToggleBookmarkUseCase toggleBookmarkUseCase,
    required ToggleStarUseCase toggleStarUseCase,
    required ToggleArticleLikeUseCase toggleArticleLikeUseCase,
    String? currentUserId,
    String? Function()? userIdResolver,
  })  : _getHomeFeedUseCase = getHomeFeedUseCase,
        _getUserFeedTopicsUseCase = getUserFeedTopicsUseCase,
        _getSavedArticlesUseCase = getSavedArticlesUseCase,
        _toggleBookmarkUseCase = toggleBookmarkUseCase,
        _toggleStarUseCase = toggleStarUseCase,
        _toggleArticleLikeUseCase = toggleArticleLikeUseCase,
        _currentUserId = currentUserId,
        _userIdResolver = userIdResolver,
        super(HomeFeedInitial(topics: _resolveInitialTopics()));

  static List<String> _resolveInitialTopics() {
    final cached =
        CurrentUserSession.resolveCachedUserEntity()?.favoriteCategories;
    return GetUserFeedTopicsUseCase.buildInitialTopics(cached);
  }

  String? get _resolvedUserId => _userIdResolver != null
      ? _userIdResolver()
      : (_currentUserId ?? CurrentUserSession.currentUserId);

  void _safeEmit(HomeFeedState nextState) {
    if (!isClosed) emit(nextState);
  }

  Future<void> loadFeed() => fetchFeed();

  Future<void> fetchFeed() async {
    _safeEmit(state.copyWith(status: HomeFeedStatus.loading, clearError: true));

    final userId = _resolvedUserId;
    final topicsResult = await _resolveTopics(userId);
    final result = await _getHomeFeedUseCase.call(
      preferredCategoryIds: topicsResult.preferredCategoryIds.isNotEmpty
          ? topicsResult.preferredCategoryIds
          : null,
    );

    await result.when(
      success: (articles) =>
          _handleFeedSuccess(articles, topicsResult.topics, userId),
      failure: (failure) async =>
          _handleFeedFailure(failure.message, topicsResult.topics),
    );
  }

  Future<UserFeedTopicsResult> _resolveTopics(String? userId) {
    final cached =
        CurrentUserSession.resolveCachedUserEntity()?.favoriteCategories;
    return _getUserFeedTopicsUseCase.call(
      userId: userId,
      shouldQueryRemote: userId != null || _userIdResolver == null,
      cachedCategories: cached,
    );
  }

  Future<void> _handleFeedSuccess(
    List<ArticleEntity> articles,
    List<String> topics,
    String? userId,
  ) async {
    final selectedTopic =
        topics.contains(state.selectedTopic) ? state.selectedTopic : 'All';
    final savedIds = await _fetchSavedArticleIds(userId);
    final editorialItems = articles.map((a) {
      final item = a.toEditorialNewsItem();
      if (savedIds.contains(item.id)) item.isSaved = true;
      return item;
    }).toList();

    _safeEmit(
      HomeFeedLoaded(
        allArticles: editorialItems,
        topics: topics,
        selectedTopic: selectedTopic,
      ),
    );
  }

  Future<Set<String>> _fetchSavedArticleIds(String? userId) async {
    final savedIds = <String>{};
    if (userId == null || userId.isEmpty) {
      return savedIds;
    }
    try {
      final savedResult = await _getSavedArticlesUseCase(userId);
      savedResult.when(
        success: (saved) => savedIds.addAll(saved.map((a) => a.id)),
        failure: (_) {},
      );
    } catch (_) {}
    return savedIds;
  }

  void _handleFeedFailure(String rawMessage, List<String> topics) {
    final msg = rawMessage.toLowerCase();
    final isOffline = msg.contains('offline') ||
        msg.contains('network') ||
        msg.contains('connection') ||
        msg.contains('socket');
    final err = isOffline
        ? 'You are currently offline. Please check your internet connection.'
        : (rawMessage.isNotEmpty ? rawMessage : 'Failed to load stories.');
    _safeEmit(
      HomeFeedError(
        errorMessage: err,
        allArticles: state.allArticles,
        topics: topics,
        selectedTopic: state.selectedTopic,
      ),
    );
  }

  Future<SwipeSaveStatus> saveArticleWithStatus(EditorialNewsItem item) async {
    final userId = _resolvedUserId;
    if (userId == null || userId.isEmpty) {
      return SwipeSaveStatus.unauthenticated;
    }
    final saved = await saveArticleOnSwipeRight(item);
    return saved ? SwipeSaveStatus.saved : SwipeSaveStatus.failed;
  }

  Future<bool> saveArticleOnSwipeRight(EditorialNewsItem item) async {
    final userId = _resolvedUserId;
    if (userId == null || userId.isEmpty) return false;
    _setSavedStatus(item, true);
    try {
      final res = await _toggleBookmarkUseCase.call(
        articleId: item.id,
        userId: userId,
        isCurrentlySaved: false,
      );
      return res.when<bool>(
        success: (_) => true,
        failure: (_) {
          _setSavedStatus(item, false);
          return false;
        },
      );
    } catch (_) {
      _setSavedStatus(item, false);
      return false;
    }
  }

  Future<bool> toggleBookmark(EditorialNewsItem item) async {
    final userId = _resolvedUserId;
    if (userId == null || userId.isEmpty) return false;
    final prev = item.isSaved;
    _setSavedStatus(item, !prev);
    try {
      final res = await _toggleBookmarkUseCase.call(
        articleId: item.id,
        userId: userId,
        isCurrentlySaved: prev,
      );
      return res.when<bool>(
        success: (saved) {
          _setSavedStatus(item, saved);
          return true;
        },
        failure: (_) {
          _setSavedStatus(item, prev);
          return false;
        },
      );
    } catch (_) {
      _setSavedStatus(item, prev);
      return false;
    }
  }

  void _setSavedStatus(EditorialNewsItem item, bool isSaved) {
    item.isSaved = isSaved;
    _syncArticleInState(item);
  }

  Future<bool> toggleStar(EditorialNewsItem item) async {
    final userId = _resolvedUserId;
    if (userId == null || userId.isEmpty) return false;
    final prevLiked = item.isLiked || item.isStarred;
    final prevCount = item.likesCount > 0 ? item.likesCount : item.starCount;
    final newCount = !prevLiked
        ? prevCount + 1
        : (prevCount > 0 ? prevCount - 1 : 0);
    _setLikeStatus(item, !prevLiked, newCount);

    return _executeStarToggle(item, userId, prevLiked, prevCount);
  }

  Future<bool> toggleLike(EditorialNewsItem item) async {
    final userId = _resolvedUserId;
    if (userId == null || userId.isEmpty) return false;
    final prevLiked = item.isLiked || item.isStarred;
    final prevCount = item.likesCount > 0 ? item.likesCount : item.starCount;
    final newCount = !prevLiked
        ? prevCount + 1
        : (prevCount > 0 ? prevCount - 1 : 0);
    _setLikeStatus(item, !prevLiked, newCount);

    return _executeLikeToggle(item, userId, prevLiked, prevCount);
  }

  Future<bool> _executeLikeToggle(
    EditorialNewsItem item,
    String userId,
    bool prevLiked,
    int prevCount,
  ) async {
    try {
      final res = await _toggleArticleLikeUseCase.call(
        articleId: item.id,
        userId: userId,
        isCurrentlyLiked: prevLiked,
      );
      return res.when<bool>(
        success: (liked) {
          _setLikeStatus(item, liked, item.likesCount);
          return true;
        },
        failure: (_) {
          _setLikeStatus(item, prevLiked, prevCount);
          return false;
        },
      );
    } catch (_) {
      _setLikeStatus(item, prevLiked, prevCount);
      return false;
    }
  }

  Future<bool> _executeStarToggle(
    EditorialNewsItem item,
    String userId,
    bool prevLiked,
    int prevCount,
  ) async {
    try {
      final res = await _toggleStarUseCase.call(
        articleId: item.id,
        userId: userId,
        isCurrentlyStarred: prevLiked,
      );
      return res.when<bool>(
        success: (starred) {
          _setLikeStatus(item, starred, item.starCount);
          return true;
        },
        failure: (_) {
          _setLikeStatus(item, prevLiked, prevCount);
          return false;
        },
      );
    } catch (_) {
      _setLikeStatus(item, prevLiked, prevCount);
      return false;
    }
  }

  void _setLikeStatus(EditorialNewsItem item, bool liked, int count) {
    item
      ..isLiked = liked
      ..isStarred = liked
      ..likesCount = count
      ..starCount = count;
    _syncArticleInState(item);
  }

  void _syncArticleInState(EditorialNewsItem updated) {
    if (state.allArticles.isEmpty) return;
    final nextArticles = state.allArticles
        .map((a) => a.id == updated.id ? updated.copyWith() : a)
        .toList();
    _safeEmit(state.copyWith(allArticles: nextArticles));
  }

  void selectTopic(String topic) =>
      _safeEmit(state.copyWith(selectedTopic: topic));
}
