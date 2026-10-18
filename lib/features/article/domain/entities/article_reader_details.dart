import 'package:equatable/equatable.dart';

import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';

class ArticleReaderDetails extends Equatable {
  final ArticleEntity article;
  final bool isLiked;
  final int likeCount;
  final bool isSaved;
  final bool isDownloaded;
  final AuthorRatingSummary authorRating;

  static const AuthorRatingSummary defaultAuthorRating = AuthorRatingSummary(
    authorKey: '',
    userStars: 0,
    ratingAvg: 0.0,
    ratingCount: 0,
  );

  const ArticleReaderDetails({
    required this.article,
    this.isLiked = false,
    this.likeCount = 0,
    this.isSaved = false,
    this.isDownloaded = false,
    this.authorRating = defaultAuthorRating,
  });

  ArticleReaderDetails copyWith({
    ArticleEntity? article,
    bool? isLiked,
    int? likeCount,
    bool? isSaved,
    bool? isDownloaded,
    AuthorRatingSummary? authorRating,
  }) {
    return ArticleReaderDetails(
      article: article ?? this.article,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      isSaved: isSaved ?? this.isSaved,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      authorRating: authorRating ?? this.authorRating,
    );
  }

  @override
  List<Object?> get props => [
        article,
        isLiked,
        likeCount,
        isSaved,
        isDownloaded,
        authorRating.authorKey,
        authorRating.userStars,
        authorRating.ratingAvg,
        authorRating.ratingCount,
      ];
}
