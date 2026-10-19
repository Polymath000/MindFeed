import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/article_payload_builder.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';

void main() {
  const testUser = CurrentUserSnapshot(
    id: 'user-builder-test',
    displayName: 'Test Author',
    email: 'test@example.com',
  );

  const techCategory = CategoryEntity(
    id: 'cat-tech',
    name: 'Technology',
    slug: 'tech',
  );

  const scienceCategory = CategoryEntity(
    id: 'cat-sci',
    name: 'Science & Cosmos',
    slug: 'science',
  );

  test(
    'buildDraftPayload includes uppercase badge when category is selected',
    () {
      const state = AddArticleState(
        title: 'Draft Title',
        content: 'Draft content for testing payload builder.',
        selectedCategoryId: 'cat-tech',
        categories: [techCategory, scienceCategory],
        selectedTags: ['flutter', 'dart'],
        coverImageUrl: 'https://example.com/cover.jpg',
      );

      final payload = ArticlePayloadBuilder.buildDraftPayload(
        state: state,
        user: testUser,
        includeSlug: true,
      );

      expect(payload['title'], 'Draft Title');
      expect(payload['category_id'], 'cat-tech');
      expect(payload['category_slug'], 'tech');
      expect(payload['badge'], 'TECHNOLOGY');
      expect(payload['author_name'], 'Test Author');
      expect(payload['cover_image_url'], 'https://example.com/cover.jpg');
      expect(payload['tags'], ['flutter', 'dart']);
    },
  );

  test(
    'buildDraftPayload omits badge and category fields when category is null',
    () {
      const state = AddArticleState(
        title: 'Draft Title',
        content: 'Draft content without category.',
        selectedCategoryId: null,
        categories: [techCategory],
      );

      final payload = ArticlePayloadBuilder.buildDraftPayload(
        state: state,
        user: testUser,
        includeSlug: false,
      );

      expect(payload['badge'], isNull);
      expect(payload['category_id'], isNull);
      expect(payload['category_slug'], isNull);
      expect(payload['slug'], isNull);
    },
  );

  test(
    'buildPublishPayload includes uppercase badge and all publish fields',
    () {
      const state = AddArticleState(
        title: 'Publish Headline',
        content: 'Long article body text...',
        selectedCategoryId: 'cat-sci',
        categories: [techCategory, scienceCategory],
        selectedTags: ['quantum'],
        coverImageUrl:
            'https://images.unsplash.com/photo-1507413245164-6160d8298b31',
      );

      final payload = ArticlePayloadBuilder.buildPublishPayload(
        state: state,
        user: testUser,
        includeSlug: true,
      );

      expect(payload['badge'], 'SCIENCE & COSMOS');
      expect(payload['category_id'], 'cat-sci');
      expect(payload['category_slug'], 'science');
      expect(payload['author_id'], 'user-builder-test');
      expect(payload['author_name'], 'Test Author');
      expect(payload['slug'], isNotNull);
    },
  );
}
