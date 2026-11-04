import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/upload_profile_avatar_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetFavoriteCategoriesUseCase _getFavoriteCategoriesUseCase;
  final GetArticlesByAuthorUseCase _getArticlesByAuthorUseCase;
  final GetAuthorFollowSummaryUseCase? _getAuthorFollowSummaryUseCase;
  final UploadProfileAvatarUseCase? _uploadProfileAvatarUseCase;
  final String? _configuredUserId;

  ProfileInfoCubit({
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetFavoriteCategoriesUseCase getFavoriteCategoriesUseCase,
    required GetArticlesByAuthorUseCase getArticlesByAuthorUseCase,
    GetAuthorFollowSummaryUseCase? getAuthorFollowSummaryUseCase,
    UploadProfileAvatarUseCase? uploadProfileAvatarUseCase,
    String? userId,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _getFavoriteCategoriesUseCase = getFavoriteCategoriesUseCase,
        _getArticlesByAuthorUseCase = getArticlesByAuthorUseCase,
        _getAuthorFollowSummaryUseCase = getAuthorFollowSummaryUseCase,
        _uploadProfileAvatarUseCase = uploadProfileAvatarUseCase,
        _configuredUserId = userId,
        super(_createInitialState());

  static ProfileInfoState _createInitialState() {
    final sessionUser = CurrentUserSession.resolveCurrentUser();
    final localUser = CurrentUserSession.resolveCachedUserEntity();

    final initialName = sessionUser?.displayName ??
        localUser?.userName ??
        (sessionUser?.email != null ? sessionUser!.email!.split('@').first : '');
    final initialSubtitle = sessionUser?.email ?? localUser?.email ?? '';

    return ProfileInfoInitial(
      displayName: initialName,
      userSubtitle: initialSubtitle,
      avatarUrl: sessionUser?.avatarUrl ?? AppConstants.defaultAvatarUrl,
      followingCount: localUser?.favoriteCategories?.length ?? 0,
      followersCount: 0,
      followingAuthorsCount: 0,
      articlesCount: 0,
    );
  }

  Future<void> loadProfileData({String? userId}) async {
    String? targetUserId = userId ?? _configuredUserId;
    if (targetUserId == null || targetUserId.isEmpty) {
      targetUserId = CurrentUserSession.currentUserId ??
          CurrentUserSession.resolveCurrentUser()?.id;
    }

    if (targetUserId == null || targetUserId.isEmpty) {
      return;
    }

    final resolvedUserId = targetUserId;

    if (!isClosed) {
      emit(ProfileInfoLoading(
        displayName: state.displayName,
        userSubtitle: state.userSubtitle,
        avatarUrl: state.avatarUrl,
        followingCount: state.followingCount,
        followersCount: state.followersCount,
        followingAuthorsCount: state.followingAuthorsCount,
        articlesCount: state.articlesCount,
        isUploadingAvatar: state.isUploadingAvatar,
        avatarErrorMessage: null,
      ));
    }

    var currentName = state.displayName;
    var currentBio = state.userSubtitle;
    var currentAvatar = state.avatarUrl;
    var currentFollowing = state.followingCount;
    var currentFollowers = state.followersCount;
    var currentFollowingAuthors = state.followingAuthorsCount;
    var currentArticles = state.articlesCount;

    await Future.wait([
      _fetchProfile(resolvedUserId, (name, bio, avatar) {
        if (name != null && name.isNotEmpty) currentName = name;
        if (bio != null && bio.isNotEmpty) currentBio = bio;
        if (avatar != null && avatar.isNotEmpty) currentAvatar = avatar;
      }),
      _fetchCategories(resolvedUserId, (count) => currentFollowing = count),
      _fetchFollowSummary(resolvedUserId, (followers, following) {
        currentFollowers = followers;
        currentFollowingAuthors = following;
      }),
      _fetchArticles(resolvedUserId, (count) => currentArticles = count),
    ]);

    if (!isClosed) {
      emit(ProfileInfoLoaded(
        displayName: currentName,
        userSubtitle: currentBio,
        avatarUrl: currentAvatar,
        followingCount: currentFollowing,
        followersCount: currentFollowers,
        followingAuthorsCount: currentFollowingAuthors,
        articlesCount: currentArticles,
        isUploadingAvatar: false,
        avatarErrorMessage: null,
      ));
    }
  }

  Future<void> _fetchProfile(
    String userId,
    void Function(String?, String?, String?) onLoaded,
  ) async {
    try {
      final profileResult = await _getUserProfileUseCase(userId);
      profileResult.when(
        success: (profile) => onLoaded(
          profile['display_name'] as String?,
          profile['bio'] as String?,
          profile['avatar_url'] as String?,
        ),
        failure: (_) {},
      );
    } catch (_) {
      const failure = CacheFailure("there's an error, Please try again later");
      debugPrint(failure.message);
    }
  }

  Future<void> _fetchCategories(
    String userId,
    void Function(int) onLoaded,
  ) async {
    try {
      final favsResult = await _getFavoriteCategoriesUseCase(userId);
      favsResult.when(
        success: (favs) => onLoaded(favs.length),
        failure: (_) {},
      );
    } catch (_) {
      const failure = CacheFailure("there's an error, Please try again later");
      debugPrint(failure.message);
    }
  }

  Future<void> _fetchFollowSummary(
    String userId,
    void Function(int, int) onLoaded,
  ) async {
    if (_getAuthorFollowSummaryUseCase == null) return;
    try {
      final followResult = await _getAuthorFollowSummaryUseCase(
        targetUserId: userId,
      );
      followResult.when(
        success: (summary) =>
            onLoaded(summary.followersCount, summary.followingCount),
        failure: (_) {},
      );
    } catch (_) {
      const failure = CacheFailure("there's an error, Please try again later");
      debugPrint(failure.message);
    }
  }

  Future<void> _fetchArticles(
    String userId,
    void Function(int) onLoaded,
  ) async {
    try {
      final articlesResult = await _getArticlesByAuthorUseCase(userId);
      articlesResult.when(
        success: (articles) => onLoaded(
          articles.where((a) => a.status == 'published').length,
        ),
        failure: (_) {},
      );
    } catch (_) {
      const failure = CacheFailure("there's an error, Please try again later");
      debugPrint(failure.message);
    }
  }

  Future<void> uploadAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async {
    String? targetUserId = _configuredUserId;
    if (targetUserId == null || targetUserId.isEmpty) {
      targetUserId = CurrentUserSession.currentUserId ??
          CurrentUserSession.resolveCurrentUser()?.id;
    }

    if (targetUserId == null ||
        targetUserId.isEmpty ||
        _uploadProfileAvatarUseCase == null) {
      return;
    }

    emit(ProfileInfoLoaded(
      displayName: state.displayName,
      userSubtitle: state.userSubtitle,
      avatarUrl: state.avatarUrl,
      followingCount: state.followingCount,
      followersCount: state.followersCount,
      followingAuthorsCount: state.followingAuthorsCount,
      articlesCount: state.articlesCount,
      isUploadingAvatar: true,
      avatarErrorMessage: null,
    ));

    final result = await _uploadProfileAvatarUseCase(
      userId: targetUserId,
      bytes: bytes,
      fileExtension: fileName,
      previousAvatarUrl: state.avatarUrl,
    );

    if (isClosed) return;

    result.when(
      success: (newUrl) {
        emit(ProfileInfoLoaded(
          displayName: state.displayName,
          userSubtitle: state.userSubtitle,
          avatarUrl: newUrl,
          followingCount: state.followingCount,
          followersCount: state.followersCount,
          followingAuthorsCount: state.followingAuthorsCount,
          articlesCount: state.articlesCount,
          isUploadingAvatar: false,
          avatarErrorMessage: null,
        ));
      },
      failure: (failure) {
        emit(ProfileInfoLoaded(
          displayName: state.displayName,
          userSubtitle: state.userSubtitle,
          avatarUrl: state.avatarUrl,
          followingCount: state.followingCount,
          followersCount: state.followersCount,
          followingAuthorsCount: state.followingAuthorsCount,
          articlesCount: state.articlesCount,
          isUploadingAvatar: false,
          avatarErrorMessage: failure.message,
        ));
      },
    );
  }
}
