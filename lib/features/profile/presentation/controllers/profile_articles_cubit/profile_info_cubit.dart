import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/upload_profile_avatar_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetFavoriteCategoriesUseCase _getFavoriteCategoriesUseCase;
  final GetArticlesByAuthorUseCase _getArticlesByAuthorUseCase;
  final UploadProfileAvatarUseCase? _uploadProfileAvatarUseCase;
  final String? _configuredUserId;

  ProfileInfoCubit({
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetFavoriteCategoriesUseCase getFavoriteCategoriesUseCase,
    required GetArticlesByAuthorUseCase getArticlesByAuthorUseCase,
    UploadProfileAvatarUseCase? uploadProfileAvatarUseCase,
    String? userId,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _getFavoriteCategoriesUseCase = getFavoriteCategoriesUseCase,
        _getArticlesByAuthorUseCase = getArticlesByAuthorUseCase,
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
      avatarUrl: sessionUser?.avatarUrl,
      followingCount: localUser?.favoriteCategories?.length ?? 0,
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

    var currentName = state.displayName;
    var currentBio = state.userSubtitle;
    var currentAvatar = state.avatarUrl;
    var currentFollowing = state.followingCount;
    var currentArticles = state.articlesCount;

    // 1. Fetch remote profile
    try {
      final profileResult = await _getUserProfileUseCase(targetUserId);
      if (isClosed) return;
      profileResult.when(
        success: (profile) {
          final remoteName = profile['display_name'] as String?;
          final remoteBio = profile['bio'] as String?;
          final remoteAvatar = profile['avatar_url'] as String?;
          if (remoteName != null && remoteName.isNotEmpty) {
            currentName = remoteName;
          }
          if (remoteBio != null && remoteBio.isNotEmpty) {
            currentBio = remoteBio;
          }
          if (remoteAvatar != null && remoteAvatar.isNotEmpty) {
            final resolved =
                SupabaseStorageService.resolveAvatarUrl(remoteAvatar);
            if (resolved != null && resolved.isNotEmpty) {
              currentAvatar = resolved;
              CurrentUserSession.cacheUserAvatarUrl(currentAvatar!);
            }
          }
        },
        failure: (_) {},
      );
    } catch (_) {}

    // 2. Fetch favorite categories
    try {
      final favsResult = await _getFavoriteCategoriesUseCase(targetUserId);
      if (isClosed) return;
      favsResult.when(
        success: (favs) {
          currentFollowing = favs.length;
        },
        failure: (_) {},
      );
    } catch (_) {}

    // 3. Fetch articles count
    try {
      final articlesResult = await _getArticlesByAuthorUseCase(targetUserId);
      if (isClosed) return;
      articlesResult.when(
        success: (articles) {
          currentArticles = articles.length;
        },
        failure: (_) {},
      );
    } catch (_) {}

    if (!isClosed) {
      emit(ProfileInfoLoaded(
        displayName: currentName,
        userSubtitle: currentBio,
        avatarUrl: currentAvatar,
        followingCount: currentFollowing,
        articlesCount: currentArticles,
        isUploadingAvatar: false,
        avatarErrorMessage: null,
      ));
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
          articlesCount: state.articlesCount,
          isUploadingAvatar: false,
          avatarErrorMessage: failure.message,
        ));
      },
    );
  }
}
