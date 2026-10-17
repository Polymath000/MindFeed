import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

enum ArticleReaderStatus { initial, loading, ready, error }

class ArticleReaderState extends Equatable {
  final ArticleReaderStatus status;
  final EditorialNewsItem? item;
  final bool isStarred;
  final int starCount;
  final bool isLiked;
  final int likeCount;
  final bool isSaved;
  final bool isDownloaded;
  final bool isSlowScrolling;
  final double scrollPace;
  final bool isScrollBarRetracted;
  final double authorRatingAvg;
  final int authorRatingCount;
  final int userAuthorStars;
  final String? errorMessage;
  final String? userFeedback;

  const ArticleReaderState({
    this.status = ArticleReaderStatus.initial,
    this.item,
    this.isStarred = false,
    this.starCount = 0,
    this.isLiked = false,
    this.likeCount = 0,
    this.isSaved = false,
    this.isDownloaded = false,
    this.isSlowScrolling = false,
    this.scrollPace = 1.0,
    this.isScrollBarRetracted = false,
    this.authorRatingAvg = 0.0,
    this.authorRatingCount = 0,
    this.userAuthorStars = 0,
    this.errorMessage,
    this.userFeedback,
  });

  ArticleReaderState copyWith({
    ArticleReaderStatus? status,
    EditorialNewsItem? item,
    bool? isStarred,
    int? starCount,
    bool? isLiked,
    int? likeCount,
    bool? isSaved,
    bool? isDownloaded,
    bool? isSlowScrolling,
    double? scrollPace,
    bool? isScrollBarRetracted,
    double? authorRatingAvg,
    int? authorRatingCount,
    int? userAuthorStars,
    String? errorMessage,
    String? userFeedback,
    bool clearFeedback = false,
  }) {
    return ArticleReaderState(
      status: status ?? this.status,
      item: item ?? this.item,
      isStarred: isStarred ?? this.isStarred,
      starCount: starCount ?? this.starCount,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      isSaved: isSaved ?? this.isSaved,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isSlowScrolling: isSlowScrolling ?? this.isSlowScrolling,
      scrollPace: scrollPace ?? this.scrollPace,
      isScrollBarRetracted: isScrollBarRetracted ?? this.isScrollBarRetracted,
      authorRatingAvg: authorRatingAvg ?? this.authorRatingAvg,
      authorRatingCount: authorRatingCount ?? this.authorRatingCount,
      userAuthorStars: userAuthorStars ?? this.userAuthorStars,
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
        isLiked,
        likeCount,
        isSaved,
        isDownloaded,
        isSlowScrolling,
        scrollPace,
        isScrollBarRetracted,
        authorRatingAvg,
        authorRatingCount,
        userAuthorStars,
        errorMessage,
        userFeedback,
      ];
}
