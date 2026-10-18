import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/collections/domain/usecases/delete_downloaded_article_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';
import 'downloads_state.dart';

class DownloadsCubit extends Cubit<DownloadsState> {
  final GetDownloadedArticlesUseCase _getDownloadedArticlesUseCase;
  final DeleteDownloadedArticleUseCase _deleteDownloadedArticleUseCase;

  DownloadsCubit({
    required GetDownloadedArticlesUseCase getDownloadedArticlesUseCase,
    required DeleteDownloadedArticleUseCase deleteDownloadedArticleUseCase,
  })  : _getDownloadedArticlesUseCase = getDownloadedArticlesUseCase,
        _deleteDownloadedArticleUseCase = deleteDownloadedArticleUseCase,
        super(const DownloadsState());

  Future<void> loadDownloads() async {
    emit(state.copyWith(
      status: DownloadsStatus.loading,
      clearFeedback: true,
    ));

    try {
      final articles = await _getDownloadedArticlesUseCase.call();
      if (!isClosed) {
        final filtered = _applyFilter(articles, state.searchQuery);
        emit(state.copyWith(
          status: DownloadsStatus.loaded,
          allArticles: articles,
          filteredArticles: filtered,
        ));
      }
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(
          status: DownloadsStatus.error,
          errorMessage: 'Failed to load downloaded articles',
        ));
      }
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
    try {
      await _deleteDownloadedArticleUseCase.call(articleId);
      if (!isClosed) {
        final updatedAll =
            state.allArticles.where((a) => a.id != articleId).toList();
        final updatedFiltered = _applyFilter(updatedAll, state.searchQuery);
        emit(state.copyWith(
          allArticles: updatedAll,
          filteredArticles: updatedFiltered,
          feedbackMessage: 'Article removed from downloads',
        ));
      }
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(
          feedbackMessage: 'Failed to delete downloaded article',
        ));
      }
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
}
