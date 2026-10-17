import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_downloaded_article_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_downloaded_articles_use_case.dart';
import 'downloads_state.dart';

class DownloadsCubit extends Cubit<DownloadsState> {
  final GetDownloadedArticlesUseCase? _getDownloadedArticlesUseCase;
  final DeleteDownloadedArticleUseCase? _deleteDownloadedArticleUseCase;
  final ArticlesLocalDataSource? _localDataSource;

  DownloadsCubit({
    GetDownloadedArticlesUseCase? getDownloadedArticlesUseCase,
    DeleteDownloadedArticleUseCase? deleteDownloadedArticleUseCase,
    ArticlesLocalDataSource? localDataSource,
  })  : _getDownloadedArticlesUseCase = getDownloadedArticlesUseCase,
        _deleteDownloadedArticleUseCase = deleteDownloadedArticleUseCase,
        _localDataSource = localDataSource,
        super(const DownloadsState());

  Future<void> loadDownloads() async {
    emit(state.copyWith(
      status: DownloadsStatus.loading,
      clearFeedback: true,
    ));

    final useCase = _resolveGetDownloadedArticlesUseCase();
    if (useCase == null) {
      emit(state.copyWith(
        status: DownloadsStatus.error,
        errorMessage: 'Offline storage unavailable',
      ));
      return;
    }

    try {
      final articles = await useCase.call();
      final filtered = _applyFilter(articles, state.searchQuery);
      emit(state.copyWith(
        status: DownloadsStatus.loaded,
        allArticles: articles,
        filteredArticles: filtered,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: DownloadsStatus.error,
        errorMessage: 'Failed to load downloaded articles',
      ));
    }
  }

  void filterArticles(String query) {
    final filtered = _applyFilter(state.allArticles, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredArticles: filtered,
    ));
  }

  Future<void> deleteDownload(String articleId) async {
    final useCase = _resolveDeleteDownloadedArticleUseCase();
    if (useCase == null) {
      emit(state.copyWith(
        feedbackMessage: 'Delete action unavailable',
      ));
      return;
    }

    try {
      await useCase.call(articleId);
      final updatedAll =
          state.allArticles.where((a) => a.id != articleId).toList();
      final updatedFiltered = _applyFilter(updatedAll, state.searchQuery);
      emit(state.copyWith(
        allArticles: updatedAll,
        filteredArticles: updatedFiltered,
        feedbackMessage: 'Article removed from downloads',
      ));
    } catch (_) {
      emit(state.copyWith(
        feedbackMessage: 'Failed to delete downloaded article',
      ));
    }
  }

  List<DownloadedArticleEntity> _applyFilter(
    List<DownloadedArticleEntity> list,
    String query,
  ) {
    if (query.trim().isEmpty) return list;
    final q = query.trim().toLowerCase();
    return list.where((a) {
      return a.title.toLowerCase().contains(q) ||
          a.excerpt.toLowerCase().contains(q) ||
          a.categorySlug.toLowerCase().contains(q) ||
          a.authorName.toLowerCase().contains(q) ||
          a.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  GetDownloadedArticlesUseCase? _resolveGetDownloadedArticlesUseCase() {
    if (_getDownloadedArticlesUseCase != null) {
      return _getDownloadedArticlesUseCase;
    }
    try {
      if (getIt.isRegistered<GetDownloadedArticlesUseCase>()) {
        return getIt<GetDownloadedArticlesUseCase>();
      }
    } catch (_) {}
    final ds = _resolveLocalDataSource();
    if (ds != null) return GetDownloadedArticlesUseCase(ds);
    return null;
  }

  DeleteDownloadedArticleUseCase? _resolveDeleteDownloadedArticleUseCase() {
    if (_deleteDownloadedArticleUseCase != null) {
      return _deleteDownloadedArticleUseCase;
    }
    try {
      if (getIt.isRegistered<DeleteDownloadedArticleUseCase>()) {
        return getIt<DeleteDownloadedArticleUseCase>();
      }
    } catch (_) {}
    final ds = _resolveLocalDataSource();
    if (ds != null) return DeleteDownloadedArticleUseCase(ds);
    return null;
  }

  ArticlesLocalDataSource? _resolveLocalDataSource() {
    if (_localDataSource != null) return _localDataSource;
    try {
      if (getIt.isRegistered<ArticlesLocalDataSource>()) {
        return getIt<ArticlesLocalDataSource>();
      }
    } catch (_) {}
    return null;
  }
}
