import 'package:mind_feed/features/home/domain/entities/article_entity.dart';

class FilterArticlesByTopicUseCase {
  const FilterArticlesByTopicUseCase();

  List<ArticleEntity> call(List<ArticleEntity> articles, String selectedTopic) {
    return filterItems<ArticleEntity>(
      items: articles,
      selectedTopic: selectedTopic,
      badgeOf: (a) => a.badge,
      categorySlugOf: (a) => a.categorySlug,
      tagsOf: (a) => a.tags,
      isLiveOf: (a) => a.isLive,
    );
  }

  static List<T> filterItems<T>({
    required List<T> items,
    required String selectedTopic,
    required String Function(T) badgeOf,
    required String? Function(T) categorySlugOf,
    required List<String> Function(T) tagsOf,
    required bool Function(T) isLiveOf,
  }) {
    if (selectedTopic == 'All') return items;
    if (selectedTopic == 'Trending') {
      return items
          .where((s) => isLiveOf(s) || badgeOf(s) == 'LIVE' || badgeOf(s) == 'TECH')
          .toList();
    }

    final topicLower = selectedTopic.toLowerCase().trim();
    final topicSlug = _toSlug(topicLower);
    final topicKeywords = _extractKeywords(topicLower);

    final matching = items
        .where((s) => _matchesItem(
              item: s,
              topicLower: topicLower,
              topicSlug: topicSlug,
              topicKeywords: topicKeywords,
              badgeOf: badgeOf,
              categorySlugOf: categorySlugOf,
              tagsOf: tagsOf,
            ))
        .toList();
    if (matching.isNotEmpty) return matching;

    return _fallbackCategoryMatch(items, topicLower, badgeOf);
  }

  static String _toSlug(String topicLower) => topicLower
      .replaceAll('&', 'and')
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');

  static List<String> _extractKeywords(String topicLower) => topicLower
      .split(RegExp(r'[^a-z0-9]+'))
      .where((w) => w.length >= 3 && w != 'and')
      .toList();

  static bool _matchesItem<T>({
    required T item,
    required String topicLower,
    required String topicSlug,
    required List<String> topicKeywords,
    required String Function(T) badgeOf,
    required String? Function(T) categorySlugOf,
    required List<String> Function(T) tagsOf,
  }) {
    final badgeLower = badgeOf(item).toLowerCase().trim();
    final slugLower = categorySlugOf(item)?.toLowerCase().trim();
    final tags = tagsOf(item);

    if (badgeLower == topicLower || badgeLower == topicSlug) return true;
    if (slugLower != null && (slugLower == topicLower || slugLower == topicSlug)) {
      return true;
    }
    if (tags.any((t) {
      final tagLower = t.toLowerCase().trim();
      return tagLower == topicLower || tagLower == topicSlug;
    })) {
      return true;
    }
    return topicKeywords.any(
      (kw) =>
          badgeLower == kw ||
          (badgeLower.length >= 3 && kw.startsWith(badgeLower)) ||
          (slugLower != null && slugLower.contains(kw)) ||
          tags.any((t) => t.toLowerCase().trim() == kw),
    );
  }

  static List<T> _fallbackCategoryMatch<T>(
    List<T> items,
    String topicLower,
    String Function(T) badgeOf,
  ) {
    if (topicLower == 'tech' || topicLower == 'technology') {
      return items.where((s) {
        final b = badgeOf(s).toUpperCase();
        return b == 'TECH' || b == 'TECHNOLOGY' || b == 'AI';
      }).toList();
    }
    if (topicLower == 'science') {
      return items.where((s) {
        final b = badgeOf(s).toUpperCase();
        return b == 'SCIENCE' || b == 'SPACE';
      }).toList();
    }
    if (topicLower == 'health' || topicLower.startsWith('health')) {
      return items
          .where((s) => badgeOf(s).toUpperCase().startsWith('HEALTH'))
          .toList();
    }
    if (topicLower == 'sports' || topicLower == 'sport') {
      return items
          .where((s) => badgeOf(s).toUpperCase().startsWith('SPORT'))
          .toList();
    }
    return items;
  }
}
