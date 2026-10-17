import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/network_info.dart';
import 'package:mind_feed/features/home/data/datasources/articles_remote_data_source.dart';
import 'package:mind_feed/features/home/data/models/article_model.dart';
import 'package:mind_feed/features/home/data/models/category_model.dart';
import 'package:mind_feed/features/home/data/models/tag_model.dart';
import 'package:mind_feed/features/home/data/repos/articles_repo_impl.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/publish_article_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';

class MockNetworkInfo implements NetworkInfo {
  final bool connected;
  MockNetworkInfo({this.connected = true});

  @override
  Future<bool> get isConnected async => connected;
}

class FakeArticlesRemoteDataSource implements ArticlesRemoteDataSource {
  final List<ArticleModel> articles;
  final List<CategoryModel> categories;
  final List<TagModel> tags;
  final Set<String> starredArticles = {};
  final Set<String> savedArticles = {};

  FakeArticlesRemoteDataSource({
    List<ArticleModel>? articles,
    List<CategoryModel>? categories,
    List<TagModel>? tags,
  })  : articles = articles ?? [],
        categories = categories ?? [],
        tags = tags ?? [];

  @override
  Future<List<ArticleModel>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    return articles.take(limit).toList();
  }

  @override
  Future<ArticleModel> getArticleById(String id) async {
    return articles.firstWhere((a) => a.id == id);
  }

  @override
  Future<List<ArticleModel>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async {
    return articles.where((a) => a.categoryId == categoryId).toList();
  }

  @override
  Future<List<ArticleModel>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    return articles.where((a) => a.authorId == authorId).toList();
  }

  @override
  Future<List<ArticleModel>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    final lower = query.toLowerCase();
    return articles.where((a) => a.title.toLowerCase().contains(lower)).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return categories;
  }

  @override
  Future<List<TagModel>> getFixedTags() async {
    return tags;
  }

  @override
  Future<void> starArticle(String articleId, String userId) async {
    starredArticles.add('$userId:$articleId');
  }

  @override
  Future<void> unstarArticle(String articleId, String userId) async {
    starredArticles.remove('$userId:$articleId');
  }

  @override
  Future<bool> isArticleStarred(String articleId, String userId) async {
    return starredArticles.contains('$userId:$articleId');
  }

  @override
  Future<void> likeArticle(String articleId, String userId) async {
    starredArticles.add('$userId:$articleId');
  }

  @override
  Future<void> unlikeArticle(String articleId, String userId) async {
    starredArticles.remove('$userId:$articleId');
  }

  @override
  Future<bool> isArticleLiked(String articleId, String userId) async {
    return starredArticles.contains('$userId:$articleId');
  }

  @override
  Future<AuthorRatingSummary> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    return AuthorRatingSummary(
      authorKey: authorKey,
      userStars: stars,
      ratingAvg: stars.toDouble(),
      ratingCount: 1,
    );
  }

  @override
  Future<AuthorRatingSummary> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    return AuthorRatingSummary(
      authorKey: authorKey,
      userStars: 0,
      ratingAvg: 0.0,
      ratingCount: 0,
    );
  }

  @override
  Future<void> saveBookmark(String articleId, String userId) async {
    savedArticles.add('$userId:$articleId');
  }

  @override
  Future<void> removeBookmark(String articleId, String userId) async {
    savedArticles.remove('$userId:$articleId');
  }

  @override
  Future<List<ArticleModel>> getSavedArticles(String userId) async {
    return articles.where((a) => savedArticles.contains('$userId:${a.id}')).toList();
  }

  @override
  Future<bool> isArticleSaved(String articleId, String userId) async {
    return savedArticles.contains('$userId:$articleId');
  }

  @override
  Future<ArticleModel> saveDraft(Map<String, dynamic> draftData) async {
    final model = ArticleModel.fromJson(draftData);
    articles.add(model);
    return model;
  }

  @override
  Future<ArticleModel> publishArticle(String articleId) async {
    final index = articles.indexWhere((a) => a.id == articleId);
    final updated = articles[index].copyWith(
      status: 'published',
      publishedAt: DateTime.now(),
    );
    articles[index] = updated;
    return updated;
  }

  @override
  Future<ArticleModel> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    final index = articles.indexWhere((a) => a.id == articleId);
    final current = articles[index];
    final updated = current.copyWith(
      title: updates['title'] as String?,
      excerpt: updates['excerpt'] as String?,
    );
    articles[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteArticle(String articleId) async {
    articles.removeWhere((a) => a.id == articleId);
  }
}

void main() {
  group('Category and Tag models & entities', () {
    test('CategoryModel serializes and deserializes cleanly', () {
      final json = {
        'id': 'cat-1',
        'name': 'Technology',
        'slug': 'technology',
        'description': 'Tech articles',
      };
      final model = CategoryModel.fromJson(json);
      expect(model.id, 'cat-1');
      expect(model.name, 'Technology');
      expect(model.slug, 'technology');
      expect(model.description, 'Tech articles');

      final serialized = model.toJson();
      expect(serialized['id'], 'cat-1');
      expect(serialized['name'], 'Technology');

      final entity = CategoryModel.fromEntity(model);
      expect(entity, model);
    });

    test('TagModel serializes and deserializes cleanly', () {
      final json = {
        'id': 'tag-1',
        'name': 'AI',
        'slug': 'ai',
      };
      final model = TagModel.fromJson(json);
      expect(model.id, 'tag-1');
      expect(model.name, 'AI');
      expect(model.slug, 'ai');

      final serialized = model.toJson();
      expect(serialized['slug'], 'ai');

      final entity = TagModel.fromEntity(model);
      expect(entity, model);
    });
  });

  group('ArticleModel & ArticleEntity', () {
    test('ArticleModel parses PostgreSQL text[] array tags and string array formats', () {
      final json1 = {
        'id': 'art-1',
        'title': 'Test Article',
        'slug': 'test-article',
        'excerpt': 'Excerpt text',
        'tags': ['Tech', 'Design'],
        'status': 'published',
      };
      final model1 = ArticleModel.fromJson(json1);
      expect(model1.tags, ['Tech', 'Design']);

      final json2 = {
        'id': 'art-2',
        'title': 'Test 2',
        'slug': 'test-2',
        'excerpt': 'Excerpt 2',
        'tags': '{"AI","Machine Learning"}',
      };
      final model2 = ArticleModel.fromJson(json2);
      expect(model2.tags, ['AI', 'Machine Learning']);
    });

    test('toEditorialNewsItem maps all properties properly', () {
      final article = ArticleEntity(
        id: 'art-3',
        title: 'Title line 1\nTitle line 2',
        slug: 'title-line-1',
        excerpt: 'Some excerpt',
        badge: 'SCIENCE',
        badgeColor: '#059669',
        cardColor: '#FFF1C6',
        authorName: 'Dr. Jane Doe',
        authorRole: 'Chief Scientist',
        authorAvatar: 'assets/custom.png',
        isLive: true,
        isLiked: true,
        isSaved: false,
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      );

      final editorial = article.toEditorialNewsItem();
      expect(editorial.id, 'art-3');
      expect(editorial.badge, 'SCIENCE');
      expect(editorial.badgeColor.toARGB32(), 0xFF059669);
      expect(editorial.color.toARGB32(), 0xFFFFF1C6);
      expect(editorial.title, 'Title line 1\nTitle line 2');
      expect(editorial.authorName, 'Dr. Jane Doe');
      expect(editorial.authorAvatar, 'assets/custom.png');
      expect(editorial.isLive, true);
      expect(editorial.isLiked, true);
      expect(editorial.isSaved, false);
      expect(editorial.updated, contains('minutes ago'));
    });
  });

  group('PublishArticleUseCase ceiling and floor validations', () {
    late FakeArticlesRemoteDataSource dataSource;
    late ArticlesRepository repo;
    late PublishArticleUseCase publishUseCase;

    setUp(() {
      final longBody = List.generate(350, (i) => 'word$i').join(' ');
      final draft = ArticleModel(
        id: 'draft-1',
        title: 'Short valid title',
        slug: 'short-valid-title',
        excerpt: 'Excerpt',
        content: longBody,
        status: 'draft',
      );
      dataSource = FakeArticlesRemoteDataSource(articles: [draft]);
      repo = ArticlesRepositoryImpl(
        remoteDataSource: dataSource,
        networkInfo: MockNetworkInfo(connected: true),
      );
      publishUseCase = PublishArticleUseCase(repo);
    });

    test('Fails when title exceeds 12 words ceiling', () async {
      final tooLongTitle = 'One two three four five six seven eight nine ten eleven twelve thirteen';
      final validBody = List.generate(310, (i) => 'word').join(' ');

      final result = await publishUseCase.call(
        articleId: 'draft-1',
        title: tooLongTitle,
        content: validBody,
      );

      result.when(
        success: (_) => fail('Should have failed validation'),
        failure: (f) {
          expect(f, isA<ValidationFailure>());
          expect(f.message, contains('cannot exceed 12 words'));
        },
      );
    });

    test('Fails when body has less than 300 words floor', () async {
      final shortBody = List.generate(150, (i) => 'word').join(' ');

      final result = await publishUseCase.call(
        articleId: 'draft-1',
        title: 'Valid Title',
        content: shortBody,
      );

      result.when(
        success: (_) => fail('Should have failed validation'),
        failure: (f) {
          expect(f, isA<ValidationFailure>());
          expect(f.message, contains('at least 300 words'));
        },
      );
    });

    test('Passes and publishes article when title <= 12 and body >= 300 words', () async {
      final validTitle = 'Valid Eleven Word Title For Editorial Feed Production Release MindFeed Today';
      final validBody = List.generate(320, (i) => 'content').join(' ');

      final result = await publishUseCase.call(
        articleId: 'draft-1',
        title: validTitle,
        content: validBody,
      );

      result.when(
        success: (article) {
          expect(article.status, 'published');
          expect(article.publishedAt, isNotNull);
        },
        failure: (f) => fail('Publishing should succeed: ${f.message}'),
      );
    });

    test('Resolves draft content when not passed directly and validates', () async {
      final result = await publishUseCase.call(articleId: 'draft-1');

      result.when(
        success: (article) {
          expect(article.status, 'published');
        },
        failure: (f) => fail('Publishing should succeed with existing draft content: ${f.message}'),
      );
    });
  });

  group('ToggleStar and ToggleBookmark use cases', () {
    late FakeArticlesRemoteDataSource dataSource;
    late ArticlesRepository repo;
    late ToggleStarUseCase toggleStarUseCase;
    late ToggleBookmarkUseCase toggleBookmarkUseCase;

    setUp(() {
      final article = const ArticleModel(
        id: 'article-fav',
        title: 'Fav Article',
        slug: 'fav-article',
        excerpt: 'Excerpt',
        status: 'published',
      );
      dataSource = FakeArticlesRemoteDataSource(articles: [article]);
      repo = ArticlesRepositoryImpl(
        remoteDataSource: dataSource,
        networkInfo: MockNetworkInfo(connected: true),
      );
      toggleStarUseCase = ToggleStarUseCase(repo);
      toggleBookmarkUseCase = ToggleBookmarkUseCase(repo);
    });

    test('Toggle star from unstarred to starred', () async {
      final res = await toggleStarUseCase.call(
        articleId: 'article-fav',
        userId: 'user-1',
        isCurrentlyStarred: false,
      );
      res.when(
        success: (starred) => expect(starred, true),
        failure: (f) => fail(f.message),
      );
      expect(await dataSource.isArticleStarred('article-fav', 'user-1'), true);
    });

    test('Toggle star from starred to unstarred', () async {
      await dataSource.starArticle('article-fav', 'user-1');
      final res = await toggleStarUseCase.call(
        articleId: 'article-fav',
        userId: 'user-1',
        isCurrentlyStarred: true,
      );
      res.when(
        success: (starred) => expect(starred, false),
        failure: (f) => fail(f.message),
      );
      expect(await dataSource.isArticleStarred('article-fav', 'user-1'), false);
    });

    test('Toggle bookmark from unsaved to saved and back', () async {
      final saveRes = await toggleBookmarkUseCase.call(
        articleId: 'article-fav',
        userId: 'user-1',
        isCurrentlySaved: false,
      );
      saveRes.when(
        success: (saved) => expect(saved, true),
        failure: (f) => fail(f.message),
      );
      expect(await dataSource.isArticleSaved('article-fav', 'user-1'), true);

      final unsaveRes = await toggleBookmarkUseCase.call(
        articleId: 'article-fav',
        userId: 'user-1',
        isCurrentlySaved: true,
      );
      unsaveRes.when(
        success: (saved) => expect(saved, false),
        failure: (f) => fail(f.message),
      );
      expect(await dataSource.isArticleSaved('article-fav', 'user-1'), false);
    });
  });

  group('Offline handling in ArticlesRepositoryImpl', () {
    test('Returns ServerFailure with "You are Offline" when disconnected', () async {
      final repo = ArticlesRepositoryImpl(
        remoteDataSource: FakeArticlesRemoteDataSource(),
        networkInfo: MockNetworkInfo(connected: false),
      );

      final result = await repo.getHomeFeed();
      result.when(
        success: (_) => fail('Expected offline failure'),
        failure: (f) {
          expect(f, isA<ServerFailure>());
          expect(f.message, 'You are Offline');
        },
      );
    });
  });
}
