import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

enum ArticleReaderStatus { initial, loading, ready, error }

class ArticleReaderState extends Equatable {
  final ArticleReaderStatus status;
  final EditorialNewsItem? item;
  final bool isStarred;
  final int starCount;
  final bool isSaved;
  final bool isDownloaded;
  final String? errorMessage;
  final String? userFeedback;

  const ArticleReaderState({
    this.status = ArticleReaderStatus.initial,
    this.item,
    this.isStarred = false,
    this.starCount = 0,
    this.isSaved = false,
    this.isDownloaded = false,
    this.errorMessage,
    this.userFeedback,
  });

  ArticleReaderState copyWith({
    ArticleReaderStatus? status,
    EditorialNewsItem? item,
    bool? isStarred,
    int? starCount,
    bool? isSaved,
    bool? isDownloaded,
    String? errorMessage,
    String? userFeedback,
    bool clearFeedback = false,
  }) {
    return ArticleReaderState(
      status: status ?? this.status,
      item: item ?? this.item,
      isStarred: isStarred ?? this.isStarred,
      starCount: starCount ?? this.starCount,
      isSaved: isSaved ?? this.isSaved,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      errorMessage: errorMessage ?? this.errorMessage,
      userFeedback: clearFeedback ? null : (userFeedback ?? this.userFeedback),
    );
  }

  @override
  List<Object?> get props => [
        status,
        item?.id,
        item?.content,
        isStarred,
        starCount,
        isSaved,
        isDownloaded,
        errorMessage,
        userFeedback,
      ];
}
