import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/entities/author_rating_summary.dart';

class AuthorDossierEntity extends Equatable {
  final String displayName;
  final String bio;
  final String avatarUrl;
  final String authorKey;
  final String? authorId;
  final List<ArticleEntity> publishedArticles;
  final List<String> topics;
  final AuthorFollowSummary followSummary;
  final bool canFollow;
  final bool canRate;
  final AuthorRatingSummary ratingSummary;

  const AuthorDossierEntity({
    required this.displayName,
    this.bio = '',
    this.avatarUrl = '',
    required this.authorKey,
    this.authorId,
    this.publishedArticles = const [],
    this.topics = const [],
    this.followSummary = const AuthorFollowSummary(),
    this.canFollow = false,
    this.canRate = false,
    this.ratingSummary = const AuthorRatingSummary(
      authorKey: '',
      userStars: 0,
      ratingAvg: 0.0,
      ratingCount: 0,
    ),
  });

  AuthorDossierEntity copyWith({
    String? displayName,
    String? bio,
    String? avatarUrl,
    String? authorKey,
    String? authorId,
    List<ArticleEntity>? publishedArticles,
    List<String>? topics,
    AuthorFollowSummary? followSummary,
    bool? canFollow,
    bool? canRate,
    AuthorRatingSummary? ratingSummary,
  }) {
    return AuthorDossierEntity(
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      authorKey: authorKey ?? this.authorKey,
      authorId: authorId ?? this.authorId,
      publishedArticles: publishedArticles ?? this.publishedArticles,
      topics: topics ?? this.topics,
      followSummary: followSummary ?? this.followSummary,
      canFollow: canFollow ?? this.canFollow,
      canRate: canRate ?? this.canRate,
      ratingSummary: ratingSummary ?? this.ratingSummary,
    );
  }

  @override
  List<Object?> get props => [
    displayName,
    bio,
    avatarUrl,
    authorKey,
    authorId,
    publishedArticles,
    topics,
    followSummary,
    canFollow,
    canRate,
    ratingSummary,
  ];
}
