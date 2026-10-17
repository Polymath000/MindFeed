import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

enum HomeFeedStatus { initial, loading, success, error }

class HomeFeedState extends Equatable {
  final HomeFeedStatus status;
  final List<EditorialNewsItem> allArticles;
  final List<String> topics;
  final String selectedTopic;
  final String? errorMessage;

  const HomeFeedState({
    this.status = HomeFeedStatus.initial,
    this.allArticles = const [],
    this.topics = const [
      'All',
      'Trending',
      'Tech',
      'Science',
      'Health',
      'Sports',
    ],
    this.selectedTopic = 'All',
    this.errorMessage,
  });

  List<EditorialNewsItem> get filteredArticles {
    if (selectedTopic == 'All') return allArticles;
    if (selectedTopic == 'Trending') {
      return allArticles
          .where((s) => s.isLive || s.badge == 'LIVE' || s.badge == 'TECH')
          .toList();
    }

    final topicLower = selectedTopic.toLowerCase();
    final matching = allArticles.where((s) {
      if (s.badge.toLowerCase() == topicLower) return true;
      if (s.categorySlug != null &&
          s.categorySlug!.toLowerCase() == topicLower) {
        return true;
      }
      if (s.tags.any((t) => t.toLowerCase() == topicLower)) return true;
      return false;
    }).toList();
    if (matching.isNotEmpty) return matching;

    if (selectedTopic == 'Tech') {
      return allArticles
          .where((s) => s.badge == 'TECH' || s.badge == 'AI')
          .toList();
    }
    if (selectedTopic == 'Science') {
      return allArticles
          .where((s) => s.badge == 'SCIENCE' || s.badge == 'SPACE')
          .toList();
    }
    if (selectedTopic == 'Health') {
      return allArticles.where((s) => s.badge == 'HEALTH').toList();
    }
    if (selectedTopic == 'Sports') {
      return allArticles.where((s) => s.badge == 'SPORT').toList();
    }
    return allArticles;
  }

  HomeFeedState copyWith({
    HomeFeedStatus? status,
    List<EditorialNewsItem>? allArticles,
    List<String>? topics,
    String? selectedTopic,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeFeedState(
      status: status ?? this.status,
      allArticles: allArticles ?? this.allArticles,
      topics: topics ?? this.topics,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
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
