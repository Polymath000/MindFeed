import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

enum ArticleReaderStatus { initial, loading, ready, error }

sealed class ArticleReaderState extends Equatable {
  const ArticleReaderState();

  ArticleReaderStatus get status => switch (this) {
        ArticleReaderInitial() => ArticleReaderStatus.initial,
        ArticleReaderLoading() => ArticleReaderStatus.loading,
        ArticleReaderLoaded() => ArticleReaderStatus.ready,
        ArticleReaderError() => ArticleReaderStatus.error,
      };

  EditorialNewsItem? get item => switch (this) {
        ArticleReaderLoaded(:final item) => item,
        _ => null,
      };

  bool get isLiked => switch (this) {
        ArticleReaderLoaded(:final isLiked) => isLiked,
        _ => false,
      };

  int get likeCount => switch (this) {
        ArticleReaderLoaded(:final likeCount) => likeCount,
        _ => 0,
      };

  bool get isStarred => switch (this) {
        ArticleReaderLoaded(:final isStarred) => isStarred,
        _ => false,
      };

  int get starCount => switch (this) {
        ArticleReaderLoaded(:final starCount) => starCount,
        _ => 0,
      };

  bool get isSaved => switch (this) {
        ArticleReaderLoaded(:final isSaved) => isSaved,
        _ => false,
      };

  bool get isDownloaded => switch (this) {
        ArticleReaderLoaded(:final isDownloaded) => isDownloaded,
        _ => false,
      };

  bool get isSlowScrolling => switch (this) {
        ArticleReaderLoaded(:final isSlowScrolling) => isSlowScrolling,
        _ => false,
      };

  double get scrollPace => switch (this) {
        ArticleReaderLoaded(:final scrollPace) => scrollPace,
        _ => 1.0,
      };

  bool get isScrollBarRetracted => switch (this) {
        ArticleReaderLoaded(:final isScrollBarRetracted) => isScrollBarRetracted,
        _ => false,
      };

  double get authorRatingAvg => switch (this) {
        ArticleReaderLoaded(:final authorRatingAvg) => authorRatingAvg,
        _ => 0.0,
      };

  int get authorRatingCount => switch (this) {
        ArticleReaderLoaded(:final authorRatingCount) => authorRatingCount,
        _ => 0,
      };

  int get userAuthorStars => switch (this) {
        ArticleReaderLoaded(:final userAuthorStars) => userAuthorStars,
        _ => 0,
      };

  String? get userFeedback => switch (this) {
        ArticleReaderLoaded(:final userFeedback) => userFeedback,
        _ => null,
      };

  String? get errorMessage => switch (this) {
        ArticleReaderError(:final message) => message,
        _ => null,
      };

  ArticleReaderState copyWith({
    EditorialNewsItem? item,
    bool? isLiked,
    int? likeCount,
    bool? isStarred,
    int? starCount,
    bool? isSaved,
    bool? isDownloaded,
    bool? isSlowScrolling,
    double? scrollPace,
    bool? isScrollBarRetracted,
    double? authorRatingAvg,
    int? authorRatingCount,
    int? userAuthorStars,
    String? userFeedback,
    bool clearFeedback = false,
  }) {
    if (this is ArticleReaderLoaded) {
      return (this as ArticleReaderLoaded).copyWith(
        item: item,
        isLiked: isLiked,
        likeCount: likeCount,
        isStarred: isStarred,
        starCount: starCount,
        isSaved: isSaved,
        isDownloaded: isDownloaded,
        isSlowScrolling: isSlowScrolling,
        scrollPace: scrollPace,
        isScrollBarRetracted: isScrollBarRetracted,
        authorRatingAvg: authorRatingAvg,
        authorRatingCount: authorRatingCount,
        userAuthorStars: userAuthorStars,
        userFeedback: userFeedback,
        clearFeedback: clearFeedback,
      );
    }
    return this;
  }

  @override
  List<Object?> get props => [];
}

final class ArticleReaderInitial extends ArticleReaderState {
  const ArticleReaderInitial();
}

final class ArticleReaderLoading extends ArticleReaderState {
  const ArticleReaderLoading();
}

final class ArticleReaderLoaded extends ArticleReaderState {
  @override
  final EditorialNewsItem? item;
  @override
  final bool isLiked;
  @override
  final int likeCount;
  @override
  final bool isStarred;
  @override
  final int starCount;
  @override
  final bool isSaved;
  @override
  final bool isDownloaded;
  @override
  final bool isSlowScrolling;
  @override
  final double scrollPace;
  @override
  final bool isScrollBarRetracted;
  @override
  final double authorRatingAvg;
  @override
  final int authorRatingCount;
  @override
  final int userAuthorStars;
  @override
  final String? userFeedback;

  const ArticleReaderLoaded({
    this.item,
    this.isLiked = false,
    this.likeCount = 0,
    this.isStarred = false,
    this.starCount = 0,
    this.isSaved = false,
    this.isDownloaded = false,
    this.isSlowScrolling = false,
    this.scrollPace = 1.0,
    this.isScrollBarRetracted = false,
    this.authorRatingAvg = 0.0,
    this.authorRatingCount = 0,
    this.userAuthorStars = 0,
    this.userFeedback,
  });

  @override
  ArticleReaderLoaded copyWith({
    EditorialNewsItem? item,
    bool? isLiked,
    int? likeCount,
    bool? isStarred,
    int? starCount,
    bool? isSaved,
    bool? isDownloaded,
    bool? isSlowScrolling,
    double? scrollPace,
    bool? isScrollBarRetracted,
    double? authorRatingAvg,
    int? authorRatingCount,
    int? userAuthorStars,
    String? userFeedback,
    bool clearFeedback = false,
  }) {
    return ArticleReaderLoaded(
      item: item ?? this.item,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      isStarred: isStarred ?? this.isStarred,
      starCount: starCount ?? this.starCount,
      isSaved: isSaved ?? this.isSaved,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isSlowScrolling: isSlowScrolling ?? this.isSlowScrolling,
      scrollPace: scrollPace ?? this.scrollPace,
      isScrollBarRetracted: isScrollBarRetracted ?? this.isScrollBarRetracted,
      authorRatingAvg: authorRatingAvg ?? this.authorRatingAvg,
      authorRatingCount: authorRatingCount ?? this.authorRatingCount,
      userAuthorStars: userAuthorStars ?? this.userAuthorStars,
      userFeedback: clearFeedback ? null : (userFeedback ?? this.userFeedback),
    );
  }

  @override
  List<Object?> get props => [
        item?.id,
        item?.content,
        isLiked,
        likeCount,
        isStarred,
        starCount,
        isSaved,
        isDownloaded,
        isSlowScrolling,
        scrollPace,
        isScrollBarRetracted,
        authorRatingAvg,
        authorRatingCount,
        userAuthorStars,
        userFeedback,
      ];
}

final class ArticleReaderError extends ArticleReaderState {
  final String message;

  const ArticleReaderError(this.message);

  @override
  List<Object?> get props => [message];
}

extension ArticleReaderStateX on ArticleReaderState {}
