import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';

enum DownloadsStatus { initial, loading, loaded, error }

class DownloadsState extends Equatable {
  final DownloadsStatus status;
  final List<DownloadedArticleEntity> allArticles;
  final List<DownloadedArticleEntity> filteredArticles;
  final String searchQuery;
  final String? errorMessage;
  final String? feedbackMessage;

  const DownloadsState({
    this.status = DownloadsStatus.initial,
    this.allArticles = const [],
    this.filteredArticles = const [],
    this.searchQuery = '',
    this.errorMessage,
    this.feedbackMessage,
  });

  DownloadsState copyWith({
    DownloadsStatus? status,
    List<DownloadedArticleEntity>? allArticles,
    List<DownloadedArticleEntity>? filteredArticles,
    String? searchQuery,
    String? errorMessage,
    String? feedbackMessage,
    bool clearFeedback = false,
  }) {
    return DownloadsState(
      status: status ?? this.status,
      allArticles: allArticles ?? this.allArticles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      feedbackMessage:
          clearFeedback ? null : (feedbackMessage ?? this.feedbackMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        allArticles,
        filteredArticles,
        searchQuery,
        errorMessage,
        feedbackMessage,
      ];
}
