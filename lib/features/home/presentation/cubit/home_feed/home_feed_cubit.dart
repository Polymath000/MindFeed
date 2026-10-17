import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_user_feed_topics_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

import 'home_feed_state.dart';

class HomeFeedCubit extends Cubit<HomeFeedState> {
  final GetHomeFeedUseCase? _getHomeFeedUseCase;
  final GetUserFeedTopicsUseCase? _getUserFeedTopicsUseCase;
  final ProfileRepository? _profileRepository;
  final String? _currentUserId;
  final GetSavedArticlesUseCase? _getSavedArticlesUseCase;
  final ToggleBookmarkUseCase? _toggleBookmarkUseCase;
  final ToggleStarUseCase? _toggleStarUseCase;
  final ToggleArticleLikeUseCase? _toggleArticleLikeUseCase;
  final String? Function()? _userIdResolver;

  HomeFeedCubit({
    GetHomeFeedUseCase? getHomeFeedUseCase,
    GetUserFeedTopicsUseCase? getUserFeedTopicsUseCase,
    ProfileRepository? profileRepository,
    String? currentUserId,
    GetSavedArticlesUseCase? getSavedArticlesUseCase,
    ToggleBookmarkUseCase? toggleBookmarkUseCase,
    ToggleStarUseCase? toggleStarUseCase,
    ToggleArticleLikeUseCase? toggleArticleLikeUseCase,
    String? Function()? userIdResolver,
  })  : _getHomeFeedUseCase = getHomeFeedUseCase,
        _getUserFeedTopicsUseCase = getUserFeedTopicsUseCase,
        _profileRepository = profileRepository,
        _currentUserId = currentUserId,
        _getSavedArticlesUseCase = getSavedArticlesUseCase,
        _toggleBookmarkUseCase = toggleBookmarkUseCase,
        _toggleStarUseCase = toggleStarUseCase,
        _toggleArticleLikeUseCase = toggleArticleLikeUseCase,
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
    final feedUseCase = _resolveFeedUseCase();
    if (feedUseCase == null) {
      _safeEmit(
        state.copyWith(
          status: HomeFeedStatus.error,
          errorMessage: 'Feed service unavailable.',
        ),
      );
      return;
    }

    final userId = _resolvedUserId;
    final topicsResult = await _resolveTopics(userId);
    final result = await feedUseCase.call(
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
    final useCase = _resolveTopicsUseCase();
    final cached =
        CurrentUserSession.resolveCachedUserEntity()?.favoriteCategories;
    return useCase.call(
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
    final savedUseCase = _resolveSavedArticlesUseCase();
    if (userId == null || userId.isEmpty || savedUseCase == null) {
      return savedIds;
    }
    try {
      final savedResult = await savedUseCase(userId);
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
    final useCase = _resolveToggleBookmarkUseCase();
    if (userId == null || userId.isEmpty || useCase == null) return false;
    _setSavedStatus(item, true);
    try {
      final res = await useCase.call(
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
    final useCase = _resolveToggleBookmarkUseCase();
    if (userId == null || userId.isEmpty || useCase == null) return false;
    final prev = item.isSaved;
    _setSavedStatus(item, !prev);
    try {
      final res = await useCase.call(
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

    final likeUseCase = _resolveToggleArticleLikeUseCase();
    if (likeUseCase != null) {
      return _executeLikeToggle(likeUseCase, item, userId, prevLiked, prevCount);
    }
    return _executeStarToggle(item, userId, prevLiked, prevCount);
  }

  Future<bool> _executeLikeToggle(
    ToggleArticleLikeUseCase useCase,
    EditorialNewsItem item,
    String userId,
    bool prevLiked,
    int prevCount,
  ) async {
    try {
      final res = await useCase.call(
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
    final starUseCase = _resolveToggleStarUseCase();
    if (starUseCase == null) {
      _setLikeStatus(item, prevLiked, prevCount);
      return false;
    }
    try {
      final res = await starUseCase.call(
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

  Future<bool> toggleLike(EditorialNewsItem item) => toggleStar(item);

  void selectTopic(String topic) =>
      _safeEmit(state.copyWith(selectedTopic: topic));

  GetHomeFeedUseCase? _resolveFeedUseCase() =>
      _getHomeFeedUseCase ??
      (getIt.isRegistered<GetHomeFeedUseCase>()
          ? getIt<GetHomeFeedUseCase>()
          : null);

  GetUserFeedTopicsUseCase _resolveTopicsUseCase() {
    if (_getUserFeedTopicsUseCase != null) return _getUserFeedTopicsUseCase;
    if (_profileRepository != null) {
      return GetUserFeedTopicsUseCase(profileRepository: _profileRepository);
    }
    if (getIt.isRegistered<GetUserFeedTopicsUseCase>()) {
      return getIt<GetUserFeedTopicsUseCase>();
    }
    final repo = getIt.isRegistered<ProfileRepository>()
        ? getIt<ProfileRepository>()
        : null;
    return GetUserFeedTopicsUseCase(profileRepository: repo);
  }

  GetSavedArticlesUseCase? _resolveSavedArticlesUseCase() =>
      _getSavedArticlesUseCase ??
      (getIt.isRegistered<GetSavedArticlesUseCase>()
          ? getIt<GetSavedArticlesUseCase>()
          : null);

  ToggleBookmarkUseCase? _resolveToggleBookmarkUseCase() =>
      _toggleBookmarkUseCase ??
      (getIt.isRegistered<ToggleBookmarkUseCase>()
          ? getIt<ToggleBookmarkUseCase>()
          : null);

  ToggleStarUseCase? _resolveToggleStarUseCase() =>
      _toggleStarUseCase ??
      (getIt.isRegistered<ToggleStarUseCase>()
          ? getIt<ToggleStarUseCase>()
          : null);

  ToggleArticleLikeUseCase? _resolveToggleArticleLikeUseCase() =>
      _toggleArticleLikeUseCase ??
      (getIt.isRegistered<ToggleArticleLikeUseCase>()
          ? getIt<ToggleArticleLikeUseCase>()
          : null);
}
