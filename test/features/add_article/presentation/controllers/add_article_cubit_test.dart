import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/publish_article_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/save_draft_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/update_article_use_case.dart';

class FakeArticlesRepository implements ArticlesRepository {
  final List<CategoryEntity> categories = [
    const CategoryEntity(id: 'cat-1', name: 'Technology', slug: 'tech'),
    const CategoryEntity(id: 'cat-2', name: 'Science', slug: 'science'),
  ];

  final List<TagEntity> tags = [
    const TagEntity(id: 't-1', name: 'flutter', slug: 'flutter'),
    const TagEntity(id: 't-2', name: 'dart', slug: 'dart'),
    const TagEntity(id: 't-3', name: 'ai', slug: 'ai'),
  ];

  final Map<String, ArticleEntity> articles = {};
  int idCounter = 1;

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async =>
      Success(categories);

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async => Success(tags);

  @override
  Future<ApiResult<ArticleEntity>> saveDraft(
    Map<String, dynamic> draftData,
  ) async {
    final id = 'art_${idCounter++}';
    final article = ArticleEntity(
      id: id,
      title: draftData['title'] as String? ?? '',
      slug: draftData['slug'] as String? ?? 'draft-$id',
      excerpt: draftData['excerpt'] as String? ?? '',
      content: draftData['content'] as String?,
      authorId: draftData['author_id'] as String?,
      authorName: draftData['author_name'] as String? ?? 'Author',
      categoryId: draftData['category_id'] as String?,
      categorySlug: draftData['category_slug'] as String?,
      coverImageUrl: draftData['cover_image_url'] as String?,
      tags: List<String>.from(draftData['tags'] as List? ?? []),
      readingTimeMinutes: draftData['reading_time_minutes'] as int? ?? 1,
      status: 'draft',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    articles[id] = article;
    return Success(article);
  }

  @override
  Future<ApiResult<ArticleEntity>> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    final existing = articles[articleId];
    if (existing == null) {
      return const FailureResult(ServerFailure('Article not found'));
    }
    final updated = existing.copyWith(
      title: updates['title'] as String? ?? existing.title,
      content: updates['content'] as String? ?? existing.content,
      excerpt: updates['excerpt'] as String? ?? existing.excerpt,
      coverImageUrl:
          updates['cover_image_url'] as String? ?? existing.coverImageUrl,
      categoryId: updates['category_id'] as String? ?? existing.categoryId,
      categorySlug:
          updates['category_slug'] as String? ?? existing.categorySlug,
      tags: updates['tags'] != null
          ? List<String>.from(updates['tags'] as List)
          : existing.tags,
      readingTimeMinutes: updates['reading_time_minutes'] as int? ??
          existing.readingTimeMinutes,
      updatedAt: DateTime.now(),
    );
    articles[articleId] = updated;
    return Success(updated);
  }

  @override
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId) async {
    final existing = articles[articleId];
    if (existing == null) {
      return const FailureResult(ServerFailure('Article not found'));
    }
    final published = existing.copyWith(
      status: 'published',
      publishedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    articles[articleId] = published;
    return Success(published);
  }

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async {
    final article = articles[id];
    if (article == null) {
      return const FailureResult(ServerFailure('Not found'));
    }
    return Success(article);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final list = articles.values.where((a) => a.authorId == authorId).toList();
    return Success(list);
  }

  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async {
    articles.remove(articleId);
    return const Success(null);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async =>
      Success(articles.values.toList());

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async =>
      Success(
        articles.values.where((a) => a.categoryId == categoryId).toList(),
      );

  @override
  Future<ApiResult<List<ArticleEntity>>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async =>
      Success(articles.values.where((a) => a.title.contains(query)).toList());

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) async =>
      Success(articles.values.where((a) => a.tags.contains(tag)).toList());

  @override
  Future<ApiResult<void>> starArticle(
    String articleId,
    String userId,
  ) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> unstarArticle(
    String articleId,
    String userId,
  ) async =>
      const Success(null);

  @override
  Future<ApiResult<bool>> isArticleStarred(
    String articleId,
    String userId,
  ) async =>
      const Success(false);

  @override
  Future<ApiResult<void>> saveBookmark(
    String articleId,
    String userId,
  ) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> removeBookmark(
    String articleId,
    String userId,
  ) async =>
      const Success(null);

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(
    String userId,
  ) async =>
      const Success([]);

  @override
  Future<ApiResult<bool>> isArticleSaved(
    String articleId,
    String userId,
  ) async =>
      const Success(false);

  @override
  Future<void> clearDownloadedArticles() async {}
}

void main() {
  late FakeArticlesRepository repo;
  late AddArticleCubit cubit;

  const testUser = CurrentUserSnapshot(
    id: 'user-42',
    displayName: 'Subagent Author',
    email: 'subagent@example.com',
  );

  setUp(() {
    repo = FakeArticlesRepository();

    cubit = AddArticleCubit(
      getCategoriesUseCase: GetCategoriesUseCase(repo),
      getFixedTagsUseCase: GetFixedTagsUseCase(repo),
      saveDraftUseCase: SaveDraftUseCase(repo),
      publishArticleUseCase: PublishArticleUseCase(repo),
      updateArticleUseCase: UpdateArticleUseCase(repo),
      userResolver: () => testUser,
      dimensionResolver: (url, {timeout = const Duration(seconds: 5)}) async =>
          const Size(1200, 630),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initializes categories and fixed tags', () async {
    await cubit.initialize();
    expect(cubit.state.categories.length, 2);
    expect(cubit.state.availableTags.length, 3);
  });

  test('saves draft when new', () async {
    await cubit.initialize();
    cubit.onTitleChanged('My New Draft');
    cubit.onContentChanged('Short notes for now');
    cubit.onCategorySelected('cat-1');
    cubit.onTagToggled('flutter');

    await cubit.saveDraft();

    expect(cubit.state.isSuccess, isTrue);
    expect(cubit.state.editingItemId, isNotNull);
    expect(cubit.state.editingItemStatus, 'draft');
    expect(cubit.state.lastSavedArticle, isNotNull);
    expect(cubit.state.successMessage, 'Draft saved successfully');
    expect(repo.articles.length, 1);
    expect(repo.articles.values.first.title, 'My New Draft');
  });

  test('saves draft updates existing draft', () async {
    await cubit.initialize();
    cubit.onTitleChanged('Initial Draft');
    await cubit.saveDraft();

    final draftId = cubit.state.editingItemId!;

    cubit.onTitleChanged('Updated Draft Title');
    await cubit.saveDraft();

    expect(cubit.state.editingItemId, draftId);
    expect(repo.articles[draftId]?.title, 'Updated Draft Title');
  });

  test('publish validation failure when requirements are not met', () async {
    await cubit.initialize();
    cubit.onTitleChanged('Valid Title');
    cubit.onContentChanged('Only four words here');

    await cubit.publish();

    expect(cubit.state.formErrors.hasErrors, isTrue);
    expect(cubit.state.formErrors.contentError, isNotNull);
    expect(cubit.state.isSuccess, isFalse);
    expect(repo.articles.isEmpty, isTrue);
  });

  test('publish success when all requirements are met', () async {
    await cubit.initialize();
    cubit.onTitleChanged('Breaking Tech Story');
    final validBody = List.filled(310, 'editorial').join(' ');
    cubit.onContentChanged(validBody);
    cubit.onCoverImageUrlChanged('https://example.com/cover.jpg');
    cubit.onCategorySelected('cat-1');
    cubit.onTagToggled('flutter');

    await cubit.publish();

    expect(cubit.state.isSuccess, isTrue);
    expect(cubit.state.editingItemStatus, 'published');
    expect(cubit.state.publishedAt, isNotNull);
    expect(cubit.state.lastSavedArticle, isNotNull);
    expect(cubit.state.successMessage, 'Article published successfully');
    expect(repo.articles.length, 1);
    expect(repo.articles.values.first.status, 'published');
  });

  test('edit window rejection for published article older than 30 days', () async {
    final oldPublishedDate =
        DateTime.now().subtract(const Duration(days: 35));
    final oldArticle = ArticleEntity(
      id: 'art-old',
      title: 'Old Story',
      slug: 'old-story',
      excerpt: 'Excerpt',
      content: List.filled(300, 'word').join(' '),
      authorId: testUser.id,
      categoryId: 'cat-1',
      tags: const ['flutter'],
      coverImageUrl: 'https://example.com/cover.jpg',
      status: 'published',
      publishedAt: oldPublishedDate,
    );
    repo.articles[oldArticle.id] = oldArticle;

    await cubit.initialize(editingItem: oldArticle.toEditorialNewsItem());

    expect(
      cubit.state.errorMessage,
      contains('Published articles can only be edited within 30 days of publication'),
    );

    cubit.onTitleChanged('Trying to edit title');
    await cubit.publish();

    expect(cubit.state.isSuccess, isFalse);
    expect(
      cubit.state.errorMessage,
      contains('Published articles can only be edited within 30 days of publication'),
    );
  });
}
