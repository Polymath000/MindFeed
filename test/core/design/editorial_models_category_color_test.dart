import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/constants/category_items.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

void main() {
  group('ArticleEntityEditorialMapper category color mapping', () {
    test('resolves category color when badgeColor is default #FFF1C6', () {
      const article = ArticleEntity(
        id: 'a1',
        title: 'Tech Innovation',
        slug: 'tech-innovation',
        excerpt: 'Excerpt',
        categorySlug: 'technology',
        badge: 'TECH',
        badgeColor: '#FFF1C6',
      );

      final item = article.toEditorialNewsItem();
      expect(item.badgeColor, getCategoryColor('technology'));
      expect(item.badgeColor, const Color(0xFF2563EB));
    });

    test('falls back to badge string when categorySlug is empty or null', () {
      const article = ArticleEntity(
        id: 'a2',
        title: 'Science Discovery',
        slug: 'science-discovery',
        excerpt: 'Excerpt',
        categorySlug: null,
        badge: 'SCIENCE',
        badgeColor: '#FFF1C6',
      );

      final item = article.toEditorialNewsItem();
      expect(item.badgeColor, getCategoryColor('SCIENCE'));
      expect(item.badgeColor, const Color(0xFF065F46));
    });

    test('resolves category color when badgeColor is empty', () {
      const article = ArticleEntity(
        id: 'a3',
        title: 'Health Story',
        slug: 'health-story',
        excerpt: 'Excerpt',
        categorySlug: 'health-wellness',
        badge: 'HEALTH',
        badgeColor: '',
      );

      final item = article.toEditorialNewsItem();
      expect(item.badgeColor, getCategoryColor('health-wellness'));
      expect(item.badgeColor, const Color(0xFF0D9488));
    });

    test('preserves custom badgeColor when not empty, null, or #FFF1C6', () {
      const article = ArticleEntity(
        id: 'a4',
        title: 'Custom Badge Story',
        slug: 'custom-badge-story',
        excerpt: 'Excerpt',
        categorySlug: 'technology',
        badge: 'TECH',
        badgeColor: '#E11D48',
      );

      final item = article.toEditorialNewsItem();
      expect(item.badgeColor, const Color(0xFFE11D48));
    });
  });

  group('DownloadedArticleEntityEditorialMapper category color mapping', () {
    test('assigns badgeColor based on categorySlug', () {
      final downloaded = DownloadedArticleEntity(
        id: 'd1',
        title: 'Downloaded Science Story',
        excerpt: 'Excerpt',
        content: 'Content',
        authorName: 'Author',
        authorRole: 'Writer',
        authorAvatar: '',
        categoryId: 'cat-sci',
        categorySlug: 'science',
        tags: const [],
        publishedAt: DateTime(2026, 1, 1),
        readingTimeMinutes: 5,
        downloadedAt: DateTime(2026, 1, 2),
      );

      final item = downloaded.toEditorialNewsItem();
      expect(item.badgeColor, getCategoryColor('science'));
      expect(item.badgeColor, const Color(0xFF065F46));
    });

    test('assigns default color when categorySlug is empty', () {
      final downloaded = DownloadedArticleEntity(
        id: 'd2',
        title: 'Downloaded Offline Story',
        excerpt: 'Excerpt',
        content: 'Content',
        authorName: 'Author',
        authorRole: 'Writer',
        authorAvatar: '',
        categoryId: 'cat-none',
        categorySlug: '',
        tags: const [],
        publishedAt: DateTime(2026, 1, 1),
        readingTimeMinutes: 5,
        downloadedAt: DateTime(2026, 1, 2),
      );

      final item = downloaded.toEditorialNewsItem();
      expect(item.badgeColor, const Color(0xFF171614));
    });
  });
}
