import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

sealed class AuthorState extends Equatable {
  const AuthorState();

  @override
  List<Object?> get props => [];
}

final class AuthorInitial extends AuthorState {
  const AuthorInitial();
}

final class AuthorLoading extends AuthorState {
  const AuthorLoading();
}

final class AuthorLoaded extends AuthorState {
  final List<EditorialNewsItem> articles;
  final List<EditorialNewsItem> filteredArticles;
  final List<String> topics;
  final String? selectedTopic;
  final String displayName;
  final String bio;
  final String avatarUrl;
  final String? authorId;
  final String authorKey;
  final int followersCount;
  final bool isFollowing;
  final bool canFollow;
  final bool isFollowLoading;
  final bool canRate;
  final double ratingAvg;
  final int ratingCount;
  final int userStars;
  final String? feedbackMessage;

  const AuthorLoaded({
    required this.articles,
    List<EditorialNewsItem>? filteredArticles,
    this.topics = const [],
    this.selectedTopic,
    this.displayName = '',
    this.bio = '',
    this.avatarUrl = '',
    this.authorId,
    this.authorKey = '',
    this.followersCount = 0,
    this.isFollowing = false,
    this.canFollow = false,
    this.isFollowLoading = false,
    this.canRate = false,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    this.userStars = 0,
    this.feedbackMessage,
  }) : filteredArticles = filteredArticles ?? articles;

  AuthorLoaded copyWith({
    List<EditorialNewsItem>? articles,
    List<EditorialNewsItem>? filteredArticles,
    List<String>? topics,
    String? selectedTopic,
    bool clearSelectedTopic = false,
    String? displayName,
    String? bio,
    String? avatarUrl,
    String? authorId,
    String? authorKey,
    int? followersCount,
    bool? isFollowing,
    bool? canFollow,
    bool? isFollowLoading,
    bool? canRate,
    double? ratingAvg,
    int? ratingCount,
    int? userStars,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
  }) {
    return AuthorLoaded(
      articles: articles ?? this.articles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      topics: topics ?? this.topics,
      selectedTopic:
          clearSelectedTopic ? null : (selectedTopic ?? this.selectedTopic),
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      authorId: authorId ?? this.authorId,
      authorKey: authorKey ?? this.authorKey,
      followersCount: followersCount ?? this.followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
      canFollow: canFollow ?? this.canFollow,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
      canRate: canRate ?? this.canRate,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      userStars: userStars ?? this.userStars,
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
    );
  }

  @override
  List<Object?> get props => [
    articles,
    filteredArticles,
    topics,
    selectedTopic,
    displayName,
    bio,
    avatarUrl,
    authorId,
    authorKey,
    followersCount,
    isFollowing,
    canFollow,
    isFollowLoading,
    canRate,
    ratingAvg,
    ratingCount,
    userStars,
    feedbackMessage,
  ];
}

final class AuthorEmpty extends AuthorState {
  final List<EditorialNewsItem> articles;
  final List<EditorialNewsItem> filteredArticles;
  final List<String> topics;
  final String? selectedTopic;
  final String displayName;
  final String bio;
  final String avatarUrl;
  final String? authorId;
  final String authorKey;
  final int followersCount;
  final bool isFollowing;
  final bool canFollow;
  final bool isFollowLoading;
  final bool canRate;
  final double ratingAvg;
  final int ratingCount;
  final int userStars;
  final String? feedbackMessage;

  const AuthorEmpty({
    this.articles = const [],
    this.filteredArticles = const [],
    this.topics = const [],
    this.selectedTopic,
    this.displayName = '',
    this.bio = '',
    this.avatarUrl = '',
    this.authorId,
    this.authorKey = '',
    this.followersCount = 0,
    this.isFollowing = false,
    this.canFollow = false,
    this.isFollowLoading = false,
    this.canRate = false,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    this.userStars = 0,
    this.feedbackMessage,
  });

  AuthorEmpty copyWith({
    List<EditorialNewsItem>? articles,
    List<EditorialNewsItem>? filteredArticles,
    List<String>? topics,
    String? selectedTopic,
    bool clearSelectedTopic = false,
    String? displayName,
    String? bio,
    String? avatarUrl,
    String? authorId,
    String? authorKey,
    int? followersCount,
    bool? isFollowing,
    bool? canFollow,
    bool? isFollowLoading,
    bool? canRate,
    double? ratingAvg,
    int? ratingCount,
    int? userStars,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
  }) {
    return AuthorEmpty(
      articles: articles ?? this.articles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      topics: topics ?? this.topics,
      selectedTopic:
          clearSelectedTopic ? null : (selectedTopic ?? this.selectedTopic),
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      authorId: authorId ?? this.authorId,
      authorKey: authorKey ?? this.authorKey,
      followersCount: followersCount ?? this.followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
      canFollow: canFollow ?? this.canFollow,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
      canRate: canRate ?? this.canRate,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      userStars: userStars ?? this.userStars,
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
    );
  }

  @override
  List<Object?> get props => [
    articles,
    filteredArticles,
    topics,
    selectedTopic,
    displayName,
    bio,
    avatarUrl,
    authorId,
    authorKey,
    followersCount,
    isFollowing,
    canFollow,
    isFollowLoading,
    canRate,
    ratingAvg,
    ratingCount,
    userStars,
    feedbackMessage,
  ];
}

final class AuthorError extends AuthorState {
  final String message;

  const AuthorError(this.message);

  @override
  List<Object?> get props => [message];
}
