import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';
import 'article_reader_deps.dart';
import 'article_reader_state.dart';

class ArticleReaderCubit extends Cubit<ArticleReaderState> {
  final ArticleReaderDependencies _deps;
  final String? _currentUserId;

  ArticleReaderCubit({
    ArticlesRepository? articlesRepository,
    ToggleStarUseCase? toggleStarUseCase,
    ToggleBookmarkUseCase? toggleBookmarkUseCase,
    GetArticleDetailsUseCase? getArticleDetailsUseCase,
    DownloadArticleTextUseCase? downloadArticleTextUseCase,
    ArticlesLocalDataSource? localDataSource,
    String? currentUserId,
  })  : _deps = ArticleReaderDependencies(
          articlesRepository: articlesRepository,
          toggleStarUseCase: toggleStarUseCase,
          toggleBookmarkUseCase: toggleBookmarkUseCase,
          getArticleDetailsUseCase: getArticleDetailsUseCase,
          downloadArticleTextUseCase: downloadArticleTextUseCase,
          localDataSource: localDataSource,
        ),
        _currentUserId = currentUserId,
        super(const ArticleReaderState());

  String? _getUserId() => _currentUserId ?? CurrentUserSession.currentUserId;

  Future<void> initArticle(EditorialNewsItem? item) async {
    if (item == null) {
      emit(state.copyWith(
        status: ArticleReaderStatus.error,
        errorMessage: 'Article not found',
      ));
      return;
    }

    emit(state.copyWith(
      status: ArticleReaderStatus.ready,
      item: item,
      isStarred: item.isStarred,
      starCount: item.starCount,
      isSaved: item.isSaved,
      clearFeedback: true,
    ));

    final localDs = _deps.resolveLocalDataSource();
    if (localDs != null) {
      try {
        final downloaded = await localDs.getDownloadedArticleById(item.id);
        if (downloaded != null) {
          emit(state.copyWith(isDownloaded: true));
        }
      } catch (_) {}
    }

    final userId = _getUserId();
    final repo = _deps.resolveArticlesRepo();
    if (userId != null && repo != null) {
      try {
        final starredResult = await repo.isArticleStarred(item.id, userId);
        starredResult.when(
          success: (starred) {
            item.isStarred = starred;
            emit(state.copyWith(isStarred: starred));
          },
          failure: (_) {},
        );
      } catch (_) {}

      try {
        final savedResult = await repo.isArticleSaved(item.id, userId);
        savedResult.when(
          success: (saved) {
            item.isSaved = saved;
            emit(state.copyWith(isSaved: saved));
          },
          failure: (_) {},
        );
      } catch (_) {}
    }

    if (item.content == null || item.content!.isEmpty) {
      final detailsUseCase = _deps.resolveGetArticleDetailsUseCase();
      if (detailsUseCase != null) {
        try {
          final result = await detailsUseCase.call(item.id);
          result.when(
            success: (entity) {
              final mapped = entity.toEditorialNewsItem()
                ..isStarred = state.isStarred
                ..isSaved = state.isSaved
                ..starCount = entity.starCount;
              emit(state.copyWith(item: mapped, starCount: entity.starCount));
            },
            failure: (_) {},
          );
        } catch (_) {}
      }
    }
  }

  Future<void> toggleStar() async {
    final currentItem = state.item;
    if (currentItem == null) return;

    final prevStarred = state.isStarred;
    final prevCount = state.starCount;
    final newStarred = !prevStarred;
    final newCount =
        newStarred ? prevCount + 1 : (prevCount > 0 ? prevCount - 1 : 0);

    emit(state.copyWith(
      isStarred: newStarred,
      starCount: newCount,
      clearFeedback: true,
    ));

    final userId = _getUserId();
    if (userId == null) {
      emit(state.copyWith(
        isStarred: prevStarred,
        starCount: prevCount,
        userFeedback: 'Please sign in to endorse stories',
      ));
      return;
    }

    final useCase = _deps.resolveToggleStarUseCase();
    if (useCase == null) {
      emit(state.copyWith(
        isStarred: prevStarred,
        starCount: prevCount,
        userFeedback: 'Star action unavailable',
      ));
      return;
    }

    try {
      final result = await useCase.call(
        articleId: currentItem.id,
        userId: userId,
        isCurrentlyStarred: prevStarred,
      );
      result.when(
        success: (starred) {
          currentItem
            ..isStarred = starred
            ..starCount = newCount;
          emit(state.copyWith(isStarred: starred, starCount: newCount));
        },
        failure: (f) => emit(state.copyWith(
          isStarred: prevStarred,
          starCount: prevCount,
          userFeedback: f.message.isNotEmpty ? f.message : 'Failed to update star',
        )),
      );
    } catch (_) {
      emit(state.copyWith(
        isStarred: prevStarred,
        starCount: prevCount,
        userFeedback: 'Failed to update star',
      ));
    }
  }

  Future<void> toggleBookmark() async {
    final currentItem = state.item;
    if (currentItem == null) return;

    final prevSaved = state.isSaved;
    final newSaved = !prevSaved;
    emit(state.copyWith(isSaved: newSaved, clearFeedback: true));

    final userId = _getUserId();
    if (userId == null) {
      emit(state.copyWith(
        isSaved: prevSaved,
        userFeedback: 'Please sign in to save stories',
      ));
      return;
    }

    final useCase = _deps.resolveToggleBookmarkUseCase();
    if (useCase == null) {
      emit(state.copyWith(
        isSaved: prevSaved,
        userFeedback: 'Bookmark action unavailable',
      ));
      return;
    }

    try {
      final result = await useCase.call(
        articleId: currentItem.id,
        userId: userId,
        isCurrentlySaved: prevSaved,
      );
      result.when(
        success: (saved) {
          currentItem.isSaved = saved;
          emit(state.copyWith(
            isSaved: saved,
            userFeedback:
                saved ? 'Added to Saved Stories' : 'Removed from Saved Stories',
          ));
        },
        failure: (f) => emit(state.copyWith(
          isSaved: prevSaved,
          userFeedback:
              f.message.isNotEmpty ? f.message : 'Failed to update bookmark',
        )),
      );
    } catch (_) {
      emit(state.copyWith(
        isSaved: prevSaved,
        userFeedback: 'Failed to update bookmark',
      ));
    }
  }

  Future<void> downloadArticle() async {
    final currentItem = state.item;
    if (currentItem == null) return;

    final useCase = _deps.resolveDownloadArticleTextUseCase();
    if (useCase == null) {
      emit(state.copyWith(userFeedback: 'Download service unavailable'));
      return;
    }

    try {
      await useCase.call(ArticleReaderDependencies.mapToDownloadedEntity(currentItem));
      emit(state.copyWith(
        isDownloaded: true,
        userFeedback: 'Article saved for offline reading',
      ));
    } catch (_) {
      emit(state.copyWith(userFeedback: 'Failed to download article'));
    }
  }
}
