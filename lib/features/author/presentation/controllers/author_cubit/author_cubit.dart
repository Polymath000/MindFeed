import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/author/domain/entities/author_dossier_entity.dart';
import 'package:mind_feed/features/author/domain/usecases/load_author_profile_dossier_use_case.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_state.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';

class AuthorCubit extends Cubit<AuthorState> {
  final LoadAuthorProfileDossierUseCase _loadAuthorProfileDossierUseCase;
  final ToggleAuthorFollowUseCase? _toggleAuthorFollowUseCase;
  final RateAuthorUseCase? _rateAuthorUseCase;
  final String? _viewerUserId;

  AuthorCubit({
    GetHomeFeedUseCase? getHomeFeedUseCase,
    GetArticlesByAuthorUseCase? getArticlesByAuthorUseCase,
    LoadAuthorProfileDossierUseCase? loadAuthorProfileDossierUseCase,
    ToggleAuthorFollowUseCase? toggleAuthorFollowUseCase,
    RateAuthorUseCase? rateAuthorUseCase,
    String? viewerUserId,
  })  : _loadAuthorProfileDossierUseCase = loadAuthorProfileDossierUseCase ??
            _createDefaultDossierUseCase(
              getHomeFeedUseCase: getHomeFeedUseCase,
              getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
            ),
        _toggleAuthorFollowUseCase = toggleAuthorFollowUseCase,
        _rateAuthorUseCase = rateAuthorUseCase,
        _viewerUserId = viewerUserId,
        super(const AuthorInitial());

  static LoadAuthorProfileDossierUseCase _createDefaultDossierUseCase({
    GetHomeFeedUseCase? getHomeFeedUseCase,
    GetArticlesByAuthorUseCase? getArticlesByAuthorUseCase,
  }) {
    if (getHomeFeedUseCase == null) {
      throw ArgumentError(
        'Either loadAuthorProfileDossierUseCase or getHomeFeedUseCase must be provided.',
      );
    }
    return LoadAuthorProfileDossierUseCase(
      getHomeFeedUseCase: getHomeFeedUseCase,
      getArticlesByAuthorUseCase: getArticlesByAuthorUseCase,
    );
  }

  String? _resolveViewerUserId() {
    return _viewerUserId ?? CurrentUserSession.currentUserId;
  }

  Future<void> loadAuthorArticles(
    String authorName, {
    String? authorId,
    String? authorRole,
    String? authorAvatar,
  }) async {
    if (!isClosed) emit(const AuthorLoading());

    try {
      final result = await _loadAuthorProfileDossierUseCase(
        authorName: authorName,
        authorId: authorId,
        fallbackRole: authorRole,
        fallbackAvatar: authorAvatar,
        viewerUserId: _resolveViewerUserId(),
      );

      if (isClosed) return;

      result.when(
        failure: (failure) {
          if (!isClosed) emit(AuthorError(failure.message));
        },
        success: (dossier) {
          if (!isClosed) _emitDossierState(dossier);
        },
      );
    } catch (e) {
      if (!isClosed) emit(AuthorError(e.toString()));
    }
  }

  void _emitDossierState(AuthorDossierEntity dossier) {
    final items = dossier.publishedArticles
        .map((a) => a.toEditorialNewsItem())
        .toList();

    if (items.isEmpty) {
      emit(
        AuthorEmpty(
          articles: const [],
          filteredArticles: const [],
          topics: dossier.topics,
          selectedTopic: null,
          displayName: dossier.displayName,
          bio: dossier.bio,
          avatarUrl: dossier.avatarUrl,
          authorId: dossier.authorId,
          authorKey: dossier.authorKey,
          followersCount: dossier.followSummary.followersCount,
          isFollowing: dossier.followSummary.isFollowing,
          canFollow: dossier.canFollow,
          isFollowLoading: false,
          canRate: dossier.canRate,
          ratingAvg: dossier.ratingSummary.ratingAvg,
          ratingCount: dossier.ratingSummary.ratingCount,
          userStars: dossier.ratingSummary.userStars,
        ),
      );
    } else {
      final unmodifiableItems = List<EditorialNewsItem>.unmodifiable(items);
      emit(
        AuthorLoaded(
          articles: unmodifiableItems,
          filteredArticles: unmodifiableItems,
          topics: dossier.topics,
          selectedTopic: null,
          displayName: dossier.displayName,
          bio: dossier.bio,
          avatarUrl: dossier.avatarUrl,
          authorId: dossier.authorId,
          authorKey: dossier.authorKey,
          followersCount: dossier.followSummary.followersCount,
          isFollowing: dossier.followSummary.isFollowing,
          canFollow: dossier.canFollow,
          isFollowLoading: false,
          canRate: dossier.canRate,
          ratingAvg: dossier.ratingSummary.ratingAvg,
          ratingCount: dossier.ratingSummary.ratingCount,
          userStars: dossier.ratingSummary.userStars,
        ),
      );
    }
  }

  void selectTopic(String? topic) {
    final s = state;
    if (s is AuthorLoaded) {
      final filtered = topic == null
          ? s.articles
          : s.articles
              .where((item) =>
                  item.badge.trim().toLowerCase() ==
                  topic.trim().toLowerCase())
              .toList();
      emit(
        s.copyWith(
          selectedTopic: topic,
          clearSelectedTopic: topic == null,
          filteredArticles: List.unmodifiable(filtered),
        ),
      );
    } else if (s is AuthorEmpty) {
      emit(
        s.copyWith(
          selectedTopic: topic,
          clearSelectedTopic: topic == null,
        ),
      );
    }
  }

  Future<void> toggleFollow() async {
    final s = state;
    final (canFollow, isFollowLoading, authorId, isFollowing) = switch (s) {
      AuthorLoaded() => (
          s.canFollow,
          s.isFollowLoading,
          s.authorId,
          s.isFollowing,
        ),
      AuthorEmpty() => (
          s.canFollow,
          s.isFollowLoading,
          s.authorId,
          s.isFollowing,
        ),
      _ => (false, false, null, false),
    };

    if (!canFollow || isFollowLoading || authorId == null) return;

    _updateState(
      (loaded) => loaded.copyWith(isFollowLoading: true),
      (empty) => empty.copyWith(isFollowLoading: true),
    );

    if (_toggleAuthorFollowUseCase == null) {
      _updateState(
        (loaded) => loaded.copyWith(isFollowLoading: false),
        (empty) => empty.copyWith(isFollowLoading: false),
      );
      return;
    }

    final result = await _toggleAuthorFollowUseCase(
      followerId: _resolveViewerUserId(),
      authorId: authorId,
      currentlyFollowing: isFollowing,
    );

    if (isClosed) return;

    result.when(
      failure: (failure) {
        if (!isClosed) {
          _updateState(
            (loaded) => loaded.copyWith(
              isFollowLoading: false,
              feedbackMessage: failure.message,
            ),
            (empty) => empty.copyWith(
              isFollowLoading: false,
              feedbackMessage: failure.message,
            ),
          );
        }
      },
      success: (summary) {
        if (!isClosed) {
          _updateState(
            (loaded) => loaded.copyWith(
              isFollowLoading: false,
              isFollowing: summary.isFollowing,
              followersCount: summary.followersCount,
            ),
            (empty) => empty.copyWith(
              isFollowLoading: false,
              isFollowing: summary.isFollowing,
              followersCount: summary.followersCount,
            ),
          );
        }
      },
    );
  }

  Future<void> rateAuthor(int stars) async {
    final s = state;
    final (canRate, authorKey, authorId, displayName) = switch (s) {
      AuthorLoaded() => (s.canRate, s.authorKey, s.authorId, s.displayName),
      AuthorEmpty() => (s.canRate, s.authorKey, s.authorId, s.displayName),
      _ => (false, '', null, ''),
    };

    if (!canRate || authorKey.isEmpty || _rateAuthorUseCase == null) return;

    final result = await _rateAuthorUseCase(
      authorKey: authorKey,
      stars: stars,
      authorId: authorId,
      authorName: displayName,
    );

    if (isClosed) return;

    result.when(
      failure: (failure) {
        if (!isClosed) {
          _updateState(
            (loaded) => loaded.copyWith(feedbackMessage: failure.message),
            (empty) => empty.copyWith(feedbackMessage: failure.message),
          );
        }
      },
      success: (summary) {
        if (!isClosed) {
          _updateState(
            (loaded) => loaded.copyWith(
              userStars: summary.userStars,
              ratingAvg: summary.ratingAvg,
              ratingCount: summary.ratingCount,
              feedbackMessage: 'Rating submitted ($stars★)',
            ),
            (empty) => empty.copyWith(
              userStars: summary.userStars,
              ratingAvg: summary.ratingAvg,
              ratingCount: summary.ratingCount,
              feedbackMessage: 'Rating submitted ($stars★)',
            ),
          );
        }
      },
    );
  }

  void _updateState(
    AuthorLoaded Function(AuthorLoaded) onLoaded,
    AuthorEmpty Function(AuthorEmpty) onEmpty,
  ) {
    final s = state;
    if (s is AuthorLoaded) {
      emit(onLoaded(s));
    } else if (s is AuthorEmpty) {
      emit(onEmpty(s));
    }
  }
}
