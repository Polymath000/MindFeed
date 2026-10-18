import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/features/search/presentation/helpers/search_filter_helper.dart';
import 'package:mind_feed/features/search/presentation/controllers/search_cubit.dart';

void main() {
  final item1 = EditorialNewsItem(
    id: '1',
    badge: 'TECH',
    badgeColor: AppColors.ink,
    title: 'Flutter Architecture',
    updated: '5 min read',
    authorName: 'Author',
    authorRole: 'Dev',
    authorAvatar: 'avatar.png',
    excerpt: 'Clean code and SRP',
    color: AppColors.cream,
    isLive: false,
    tags: const ['flutter', 'mobile'],
  );

  final item2 = EditorialNewsItem(
    id: '2',
    badge: 'AI',
    badgeColor: AppColors.ink,
    title: 'Deep Learning',
    updated: '7 min read',
    authorName: 'Author 2',
    authorRole: 'Researcher',
    authorAvatar: 'avatar2.png',
    excerpt: 'Neural networks',
    color: AppColors.cream,
    isLive: false,
    tags: const ['ai', 'python'],
  );

  group('SearchFilterHelper.filterByTags', () {
    test('returns all items when tag list is empty', () {
      final results = SearchFilterHelper.filterByTags([item1, item2], []);
      expect(results.length, equals(2));
    });

    test('filters items matching single tag case-insensitively', () {
      final results = SearchFilterHelper.filterByTags([item1, item2], ['FLUTTER']);
      expect(results.length, equals(1));
      expect(results.first.id, equals('1'));
    });

    test('filters items matching all required tags', () {
      final results = SearchFilterHelper.filterByTags([item1, item2], ['flutter', 'mobile']);
      expect(results.length, equals(1));
      expect(results.first.id, equals('1'));

      final noMatch = SearchFilterHelper.filterByTags([item1, item2], ['flutter', 'ai']);
      expect(noMatch.isEmpty, isTrue);
    });
  });

  group('SearchFilterHelper.mapFailureMessage', () {
    test('returns offline message for network related failures', () {
      expect(
        SearchFilterHelper.mapFailureMessage('SocketException failed'),
        equals('You are currently offline. Please check your internet connection.'),
      );
      expect(
        SearchFilterHelper.mapFailureMessage('Network timeout'),
        equals('You are currently offline. Please check your internet connection.'),
      );
    });

    test('returns raw message when available and not network related', () {
      expect(
        SearchFilterHelper.mapFailureMessage('Server 500 error'),
        equals('Server 500 error'),
      );
    });

    test('returns default fallback message when raw is empty', () {
      expect(
        SearchFilterHelper.mapFailureMessage(''),
        equals('Failed to search articles.'),
      );
    });
  });

  group('SearchFilterHelper.toggleTag', () {
    test('adds tag if not present and removes if present', () {
      final added = SearchFilterHelper.toggleTag(['tech'], 'mobile');
      expect(added, equals(['tech', 'mobile']));

      final removed = SearchFilterHelper.toggleTag(added, 'tech');
      expect(removed, equals(['mobile']));
    });
  });

  group('SearchFilterHelper.copyStateWithFilters', () {
    const cat = CategoryEntity(id: 'c1', name: 'Tech', slug: 'tech');
    const tag = TagEntity(id: 't1', name: 'flutter', slug: 'flutter');

    test('copies loaded state preserving results and updating filters', () {
      final initial = SearchLoaded(
        results: [item1],
        query: 'test',
        selectedCategory: null,
        selectedTags: const [],
        categories: const [],
        tags: const [],
      );

      final updated = SearchFilterHelper.copyStateWithFilters(
        currentState: initial,
        categories: [cat],
        tags: [tag],
        selectedCategory: cat,
        selectedTags: ['flutter'],
      );

      expect(updated, isA<SearchLoaded>());
      final loaded = updated as SearchLoaded;
      expect(loaded.categories.length, equals(1));
      expect(loaded.tags.length, equals(1));
      expect(loaded.selectedCategory?.id, equals('c1'));
      expect(loaded.selectedTags, equals(['flutter']));
      expect(loaded.results.first.id, equals('1'));
    });
  });
}
