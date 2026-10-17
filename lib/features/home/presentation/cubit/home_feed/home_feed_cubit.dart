import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'home_feed_state.dart';

class HomeFeedCubit extends Cubit<HomeFeedState> {
  final GetHomeFeedUseCase? _getHomeFeedUseCase;
  final ProfileRepository? _profileRepository;
  final String? _currentUserId;

  HomeFeedCubit({
    GetHomeFeedUseCase? getHomeFeedUseCase,
    ProfileRepository? profileRepository,
    String? currentUserId,
  })  : _getHomeFeedUseCase = getHomeFeedUseCase,
        _profileRepository = profileRepository,
        _currentUserId = currentUserId,
        super(const HomeFeedState());

  Future<void> fetchFeed() async {
    emit(state.copyWith(status: HomeFeedStatus.loading, clearError: true));

    final feedUseCase = _resolveFeedUseCase();
    if (feedUseCase == null) {
      emit(state.copyWith(
        status: HomeFeedStatus.error,
        errorMessage: 'Feed service unavailable.',
      ));
      return;
    }

    final preferredCategoryIds = <String>[];
    final dynamicFavoriteTopics = <String>[];
    final profileRepo = _resolveProfileRepo();

    final userId = _currentUserId ?? CurrentUserSession.currentUserId;
    if (userId != null && profileRepo != null) {
      try {
        final favsResult = await profileRepo.getFavoriteCategories(userId);
        favsResult.when(
          success: (favs) {
            for (final f in favs) {
              final catId = f['category_id'] as String?;
              if (catId != null &&
                  catId.isNotEmpty &&
                  !preferredCategoryIds.contains(catId)) {
                preferredCategoryIds.add(catId);
              }
              final catObj = f['categories'] as Map<String, dynamic>?;
              final catName = catObj?['name'] as String?;
              if (catName != null &&
                  catName.isNotEmpty &&
                  !dynamicFavoriteTopics.contains(catName)) {
                dynamicFavoriteTopics.add(catName);
              }
            }
          },
          failure: (_) {},
        );
      } catch (_) {}
    }

    if (preferredCategoryIds.isEmpty && profileRepo != null) {
      final localUser = CurrentUserSession.resolveCachedUserEntity();
      final favNames = localUser?.favoriteCategories;
      if (favNames != null && favNames.isNotEmpty) {
        try {
          final catResult = await profileRepo.getCategories();
          catResult.when(
            success: (allCats) {
              for (final c in allCats) {
                final name = c['name'] as String?;
                final id = c['id'] as String?;
                if (name != null && id != null && favNames.contains(name)) {
                  if (!preferredCategoryIds.contains(id)) {
                    preferredCategoryIds.add(id);
                  }
                  if (!dynamicFavoriteTopics.contains(name)) {
                    dynamicFavoriteTopics.add(name);
                  }
                }
              }
            },
            failure: (_) {},
          );
        } catch (_) {}
      }
    }

    final result = await feedUseCase.call(
      preferredCategoryIds:
          preferredCategoryIds.isNotEmpty ? preferredCategoryIds : null,
    );

    result.when(
      success: (articles) {
        var topics = state.topics;
        if (dynamicFavoriteTopics.isNotEmpty) {
          final newTopics = ['All', 'Trending', ...dynamicFavoriteTopics];
          for (final def in const ['Tech', 'Science', 'Health', 'Sports']) {
            if (!newTopics.contains(def)) {
              newTopics.add(def);
            }
          }
          topics = newTopics;
        }
        emit(state.copyWith(
          status: HomeFeedStatus.success,
          allArticles: articles.map((a) => a.toEditorialNewsItem()).toList(),
          topics: topics,
          clearError: true,
        ));
      },
      failure: (failure) {
        final msg = failure.message.toLowerCase();
        final String err;
        if (msg.contains('offline') ||
            msg.contains('network') ||
            msg.contains('connection') ||
            msg.contains('socket')) {
          err = 'You are currently offline. Please check your internet connection.';
        } else {
          err = failure.message.isNotEmpty
              ? failure.message
              : 'Failed to load stories.';
        }
        emit(state.copyWith(
          status: HomeFeedStatus.error,
          errorMessage: err,
        ));
      },
    );
  }

  void selectTopic(String topic) {
    emit(state.copyWith(selectedTopic: topic));
  }

  GetHomeFeedUseCase? _resolveFeedUseCase() {
    if (_getHomeFeedUseCase != null) return _getHomeFeedUseCase;
    try {
      if (getIt.isRegistered<GetHomeFeedUseCase>()) {
        return getIt<GetHomeFeedUseCase>();
      }
    } catch (_) {}
    return null;
  }

  ProfileRepository? _resolveProfileRepo() {
    if (_profileRepository != null) return _profileRepository;
    try {
      if (getIt.isRegistered<ProfileRepository>()) {
        return getIt<ProfileRepository>();
      }
    } catch (_) {}
    return null;
  }
}
