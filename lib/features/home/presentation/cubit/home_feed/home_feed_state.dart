import 'package:equatable/equatable.dart';

import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/home/domain/usecases/filter_articles_by_topic_use_case.dart';

enum HomeFeedStatus { initial, loading, success, error }

enum SwipeSaveStatus { saved, unauthenticated, failed }

sealed class HomeFeedState extends Equatable {
  final HomeFeedStatus status;
  final List<EditorialNewsItem> allArticles;
  final List<String> topics;
  final String selectedTopic;
  final String? errorMessage;

  const HomeFeedState({
    required this.status,
    this.allArticles = const [],
    this.topics = const ['All'],
    this.selectedTopic = 'All',
    this.errorMessage,
  });

  List<EditorialNewsItem> get filteredArticles =>
      FilterArticlesByTopicUseCase.filterItems<EditorialNewsItem>(
        items: allArticles,
        selectedTopic: selectedTopic,
        badgeOf: (s) => s.badge,
        categorySlugOf: (s) => s.categorySlug,
        tagsOf: (s) => s.tags,
        isLiveOf: (s) => s.isLive,
      );

  HomeFeedState copyWith({
    HomeFeedStatus? status,
    List<EditorialNewsItem>? allArticles,
    List<String>? topics,
    String? selectedTopic,
    String? errorMessage,
    bool clearError = false,
  }) {
    final nextStatus = status ?? this.status;
    final nextArticles = allArticles ?? this.allArticles;
    final nextTopics = topics ?? this.topics;
    final nextTopic = selectedTopic ?? this.selectedTopic;
    final nextError = clearError ? null : (errorMessage ?? this.errorMessage);

    return switch (nextStatus) {
      HomeFeedStatus.initial => HomeFeedInitial(
          allArticles: nextArticles,
          topics: nextTopics,
          selectedTopic: nextTopic,
        ),
      HomeFeedStatus.loading => HomeFeedLoading(
          allArticles: nextArticles,
          topics: nextTopics,
          selectedTopic: nextTopic,
        ),
      HomeFeedStatus.success => HomeFeedLoaded(
          allArticles: nextArticles,
          topics: nextTopics,
          selectedTopic: nextTopic,
        ),
      HomeFeedStatus.error => HomeFeedError(
          errorMessage: nextError ?? 'Failed to load stories.',
          allArticles: nextArticles,
          topics: nextTopics,
          selectedTopic: nextTopic,
        ),
    };
  }

  @override
  List<Object?> get props => [
        status,
        allArticles,
        topics,
        selectedTopic,
        errorMessage,
      ];
}

final class HomeFeedInitial extends HomeFeedState {
  const HomeFeedInitial({
    super.allArticles,
    super.topics,
    super.selectedTopic,
  }) : super(status: HomeFeedStatus.initial);
}

final class HomeFeedLoading extends HomeFeedState {
  const HomeFeedLoading({
    super.allArticles,
    super.topics,
    super.selectedTopic,
  }) : super(status: HomeFeedStatus.loading);
}

final class HomeFeedLoaded extends HomeFeedState {
  const HomeFeedLoaded({
    required super.allArticles,
    super.topics,
    super.selectedTopic,
  }) : super(status: HomeFeedStatus.success);
}

final class HomeFeedError extends HomeFeedState {
  const HomeFeedError({
    required String errorMessage,
    super.allArticles,
    super.topics,
    super.selectedTopic,
  }) : super(status: HomeFeedStatus.error, errorMessage: errorMessage);
}
