import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'home_feed_state.dart';

class HomeFeedCubit extends Cubit<HomeFeedState> {
  final GetHomeFeedUseCase? _getHomeFeedUseCase;
  final ProfileRepository? _profileRepository;
  final String? _currentUserId;
  final GetSavedArticlesUseCase? _getSavedArticlesUseCase;
  final ToggleBookmarkUseCase? _toggleBookmarkUseCase;
  final ToggleStarUseCase? _toggleStarUseCase;
  final ToggleArticleLikeUseCase? _toggleArticleLikeUseCase;
  final String? Function()? _userIdResolver;

  HomeFeedCubit({
    GetHomeFeedUseCase? getHomeFeedUseCase,
    ProfileRepository? profileRepository,
    String? currentUserId,
    GetSavedArticlesUseCase? getSavedArticlesUseCase,
    ToggleBookmarkUseCase? toggleBookmarkUseCase,
    ToggleStarUseCase? toggleStarUseCase,
    ToggleArticleLikeUseCase? toggleArticleLikeUseCase,
    String? Function()? userIdResolver,
  })  : _getHomeFeedUseCase = getHomeFeedUseCase,
        _profileRepository = profileRepository,
        _currentUserId = currentUserId,
        _getSavedArticlesUseCase = getSavedArticlesUseCase,
        _toggleBookmarkUseCase = toggleBookmarkUseCase,
        _toggleStarUseCase = toggleStarUseCase,
        _toggleArticleLikeUseCase = toggleArticleLikeUseCase,
        _userIdResolver = userIdResolver,
        super(HomeFeedState(topics: _resolveInitialTopics()));

  static List<String> _resolveInitialTopics() {
    final cached =
        CurrentUserSession.resolveCachedUserEntity()?.favoriteCategories;
    if (cached == null || cached.isEmpty) {
      return const ['All'];
    }
    final topics = <String>['All'];
    for (final cat in cached) {
      final trimmed = cat.trim();
      if (trimmed.isNotEmpty && !topics.contains(trimmed)) {
        topics.add(trimmed);
      }
    }
    return topics;
  }

  String? get _resolvedUserId =>
      _userIdResolver != null
          ? _userIdResolver()
          : (_currentUserId ?? CurrentUserSession.currentUserId);

  Future<void> loadFeed() => fetchFeed();

  Future<void> fetchFeed() async {
    emit(state.copyWith(status: HomeFeedStatus.loading, clearError: true));
    final feedUseCase = _resolveFeedUseCase();
    if (feedUseCase == null) {
      emit(
        state.copyWith(
          status: HomeFeedStatus.error,
          errorMessage: 'Feed service unavailable.',
        ),
      );
      return;
    }

    final preferredCategoryIds = <String>[];
    final dynamicFavoriteTopics = <String>[];
    final profileRepo = _resolveProfileRepo();
    final userId = _resolvedUserId;

    if (profileRepo != null && (userId != null || _userIdResolver == null)) {
      try {
        final favsResult = await profileRepo.getFavoriteCategories(
          userId ?? '',
        );
        favsResult.when(
          success: (favs) {
            for (final f in favs) {
              final catId = f['category_id'] as String?;
              if (catId != null &&
                  catId.isNotEmpty &&
                  !preferredCategoryIds.contains(catId)) {
                preferredCategoryIds.add(catId);
              }
              final rawName =
                  (f['name'] as String?) ??
                  (f['category_name'] as String?) ??
                  (f['categories'] as Map<String, dynamic>?)?['name']
                      as String?;
              final name = rawName?.trim();
              if (name != null &&
                  name.isNotEmpty &&
                  name != 'All' &&
                  !dynamicFavoriteTopics.contains(name)) {
                dynamicFavoriteTopics.add(name);
              }
            }
          },
          failure: (_) {},
        );
      } catch (_) {}
    }

    if (dynamicFavoriteTopics.isEmpty) {
      final favNames =
          CurrentUserSession.resolveCachedUserEntity()?.favoriteCategories;
      if (favNames != null) {
        for (final rawName in favNames) {
          final name = rawName.trim();
          if (name.isNotEmpty &&
              name != 'All' &&
              !dynamicFavoriteTopics.contains(name)) {
            dynamicFavoriteTopics.add(name);
          }
        }
      }
    }

    if (preferredCategoryIds.isEmpty &&
        dynamicFavoriteTopics.isNotEmpty &&
        profileRepo != null) {
      try {
        final catResult = await profileRepo.getCategories();
        catResult.when(
          success: (allCats) {
            final lowerFavs = dynamicFavoriteTopics
                .map((e) => e.toLowerCase())
                .toSet();
            for (final c in allCats) {
              final name = (c['name'] as String?)?.trim();
              final id = c['id'] as String?;
              if (name != null &&
                  id != null &&
                  lowerFavs.contains(name.toLowerCase()) &&
                  !preferredCategoryIds.contains(id)) {
                preferredCategoryIds.add(id);
              }
            }
          },
          failure: (_) {},
        );
      } catch (_) {}
    }

    final result = await feedUseCase.call(
      preferredCategoryIds: preferredCategoryIds.isNotEmpty
          ? preferredCategoryIds
          : null,
    );

    await result.when(
      success: (articles) async {
        final topics = <String>['All', ...dynamicFavoriteTopics];
        final selectedTopic = topics.contains(state.selectedTopic)
            ? state.selectedTopic
            : 'All';

        final savedUseCase = _resolveSavedArticlesUseCase();
        final savedIds = <String>{};
        if (userId != null && userId.isNotEmpty && savedUseCase != null) {
          try {
            final savedResult = await savedUseCase(userId);
            savedResult.when(
              success: (saved) => savedIds.addAll(saved.map((a) => a.id)),
              failure: (_) {},
            );
          } catch (_) {}
        }

        final editorialItems = articles.map((a) {
          final item = a.toEditorialNewsItem();
          if (savedIds.contains(item.id)) item.isSaved = true;
          return item;
        }).toList();

        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeFeedStatus.success,
              allArticles: editorialItems,
              topics: topics,
              selectedTopic: selectedTopic,
              clearError: true,
            ),
          );
        }
      },
      failure: (failure) async {
        final msg = failure.message.toLowerCase();
        final isOffline =
            msg.contains('offline') ||
            msg.contains('network') ||
            msg.contains('connection') ||
            msg.contains('socket');
        final err = isOffline
            ? 'You are currently offline. Please check your internet connection.'
            : (failure.message.isNotEmpty
                  ? failure.message
                  : 'Failed to load stories.');
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeFeedStatus.error,
              errorMessage: err,
              topics: <String>['All', ...dynamicFavoriteTopics],
            ),
          );
        }
      },
    );
  }

  Future<bool> saveArticleOnSwipeRight(EditorialNewsItem item) async {
    final userId = _resolvedUserId;
    if (userId == null || userId.isEmpty) return false;
    final useCase = _resolveToggleBookmarkUseCase();
    if (useCase == null) return false;
    item.isSaved = true;
    try {
      final res = await useCase.call(
        articleId: item.id,
        userId: userId,
        isCurrentlySaved: false,
      );
      return res.when<bool>(
        success: (_) => true,
        failure: (_) {
          item.isSaved = false;
          return false;
        },
      );
    } catch (_) {
      item.isSaved = false;
      return false;
    }
  }

  Future<bool> toggleBookmark(EditorialNewsItem item) async {
    final userId = _resolvedUserId;
    if (userId == null || userId.isEmpty) return false;
    final useCase = _resolveToggleBookmarkUseCase();
    if (useCase == null) return false;
    final prev = item.isSaved;
    item.isSaved = !prev;
    try {
      final res = await useCase.call(
        articleId: item.id,
        userId: userId,
        isCurrentlySaved: prev,
      );
      return res.when<bool>(
        success: (saved) {
          item.isSaved = saved;
          return true;
        },
        failure: (_) {
          item.isSaved = prev;
          return false;
        },
      );
    } catch (_) {
      item.isSaved = prev;
      return false;
    }
  }

  Future<bool> toggleStar(EditorialNewsItem item) async {
    final userId = _resolvedUserId;
    if (userId == null || userId.isEmpty) return false;
    final prevLiked = item.isLiked || item.isStarred;
    final prevCount = item.likesCount > 0 ? item.likesCount : item.starCount;
    final newLiked = !prevLiked;
    final newCount = newLiked
        ? prevCount + 1
        : (prevCount > 0 ? prevCount - 1 : 0);
    item
      ..isLiked = newLiked
      ..isStarred = newLiked
      ..likesCount = newCount
      ..starCount = newCount;

    final likeUseCase = _resolveToggleArticleLikeUseCase();
    if (likeUseCase != null) {
      try {
        final res = await likeUseCase.call(
          articleId: item.id,
          userId: userId,
          isCurrentlyLiked: prevLiked,
        );
        return res.when<bool>(
          success: (l) {
            item
              ..isLiked = l
              ..isStarred = l;
            return true;
          },
          failure: (_) {
            item
              ..isLiked = prevLiked
              ..isStarred = prevLiked
              ..likesCount = prevCount
              ..starCount = prevCount;
            return false;
          },
        );
      } catch (_) {
        item
          ..isLiked = prevLiked
          ..isStarred = prevLiked
          ..likesCount = prevCount
          ..starCount = prevCount;
        return false;
      }
    }

    final starUseCase = _resolveToggleStarUseCase();
    if (starUseCase == null) {
      item
        ..isLiked = prevLiked
        ..isStarred = prevLiked
        ..likesCount = prevCount
        ..starCount = prevCount;
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
          item
            ..isStarred = starred
            ..isLiked = starred;
          return true;
        },
        failure: (_) {
          item
            ..isStarred = prevLiked
            ..isLiked = prevLiked
            ..starCount = prevCount
            ..likesCount = prevCount;
          return false;
        },
      );
    } catch (_) {
      item
        ..isStarred = prevLiked
        ..isLiked = prevLiked
        ..starCount = prevCount
        ..likesCount = prevCount;
      return false;
    }
  }

  Future<bool> toggleLike(EditorialNewsItem item) => toggleStar(item);
  void selectTopic(String topic) => emit(state.copyWith(selectedTopic: topic));

  GetHomeFeedUseCase? _resolveFeedUseCase() =>
      _getHomeFeedUseCase ??
      (getIt.isRegistered<GetHomeFeedUseCase>()
          ? getIt<GetHomeFeedUseCase>()
          : null);
  ProfileRepository? _resolveProfileRepo() =>
      _profileRepository ??
      (getIt.isRegistered<ProfileRepository>()
          ? getIt<ProfileRepository>()
          : null);
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
