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
    this.topics = const ['All'],
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

    final topicLower = selectedTopic.toLowerCase().trim();
    final topicSlug = topicLower
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    final topicKeywords = topicLower
        .split(RegExp(r'[^a-z0-9]+'))
        .where((w) => w.length >= 3 && w != 'and')
        .toList();

    final matching = allArticles.where((s) {
      final badgeLower = s.badge.toLowerCase().trim();
      final slugLower = s.categorySlug?.toLowerCase().trim();

      if (badgeLower == topicLower || badgeLower == topicSlug) return true;
      if (slugLower != null &&
          (slugLower == topicLower || slugLower == topicSlug)) {
        return true;
      }
      if (s.tags.any((t) {
        final tagLower = t.toLowerCase().trim();
        return tagLower == topicLower || tagLower == topicSlug;
      })) {
        return true;
      }
      if (topicKeywords.any((kw) =>
          badgeLower == kw ||
          (badgeLower.length >= 3 && kw.startsWith(badgeLower)) ||
          (slugLower != null && slugLower.contains(kw)) ||
          s.tags.any((t) => t.toLowerCase().trim() == kw))) {
        return true;
      }
      return false;
    }).toList();
    if (matching.isNotEmpty) return matching;

    if (topicLower == 'tech' || topicLower == 'technology') {
      return allArticles
          .where((s) =>
              s.badge.toUpperCase() == 'TECH' ||
              s.badge.toUpperCase() == 'TECHNOLOGY' ||
              s.badge.toUpperCase() == 'AI')
          .toList();
    }
    if (topicLower == 'science') {
      return allArticles
          .where((s) =>
              s.badge.toUpperCase() == 'SCIENCE' ||
              s.badge.toUpperCase() == 'SPACE')
          .toList();
    }
    if (topicLower == 'health' || topicLower.startsWith('health')) {
      return allArticles
          .where((s) => s.badge.toUpperCase().startsWith('HEALTH'))
          .toList();
    }
    if (topicLower == 'sports' || topicLower == 'sport') {
      return allArticles
          .where((s) => s.badge.toUpperCase().startsWith('SPORT'))
          .toList();
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
