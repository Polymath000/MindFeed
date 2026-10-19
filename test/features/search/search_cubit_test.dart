import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/search/domain/usecases/get_articles_by_category_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/features/search/domain/usecases/search_articles_use_case.dart';
import 'package:mind_feed/features/search/presentation/controllers/search_cubit.dart';

const sampleCategory1 = CategoryEntity(
  id: 'cat_1',
  name: 'Technology',
  slug: 'technology',
);

const sampleCategory2 = CategoryEntity(
  id: 'cat_2',
  name: 'Science',
  slug: 'science',
);

const sampleTag1 = TagEntity(
  id: 'tag_1',
  name: 'flutter',
  slug: 'flutter',
);

const sampleTag2 = TagEntity(
  id: 'tag_2',
  name: 'ai',
  slug: 'ai',
);

const sampleArticle1 = ArticleEntity(
  id: 'art_1',
  title: 'Flutter in Action',
  slug: 'flutter-in-action',
  excerpt: 'Building cross platform apps',
  tags: ['flutter', 'tech'],
  categoryId: 'cat_1',
  categorySlug: 'technology',
);

const sampleArticle2 = ArticleEntity(
  id: 'art_2',
  title: 'AI Revolution',
  slug: 'ai-revolution',
  excerpt: 'Exploring deep learning',
  tags: ['ai', 'tech'],
  categoryId: 'cat_1',
  categorySlug: 'technology',
);

const sampleArticle3 = ArticleEntity(
  id: 'art_3',
  title: 'Quantum Physics',
  slug: 'quantum-physics',
  excerpt: 'Inside atoms and particles',
  tags: ['physics', 'science'],
  categoryId: 'cat_2',
  categorySlug: 'science',
);

class FakeArticlesRepository implements ArticlesRepository {
  Future<ApiResult<List<ArticleEntity>>> Function(String query)? onSearchArticles;
  Future<ApiResult<List<ArticleEntity>>> Function(String categoryId)?
      onGetArticlesByCategory;
  Future<ApiResult<List<CategoryEntity>>> Function()? onGetCategories;
  Future<ApiResult<List<TagEntity>>> Function()? onGetFixedTags;
  Future<ApiResult<List<ArticleEntity>>> Function({
    List<String>? preferredCategoryIds,
    int limit,
    int offset,
  })? onGetHomeFeed;
  Future<ApiResult<List<ArticleEntity>>> Function(String userId)?
      onGetSavedArticles;
  Future<ApiResult<void>> Function(String articleId, String userId)?
      onSaveBookmark;
  Future<ApiResult<void>> Function(String articleId, String userId)?
      onRemoveBookmark;

  @override
  Future<ApiResult<List<ArticleEntity>>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (onSearchArticles != null) {
      return onSearchArticles!(query);
    }
    return const Success([]);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) async {
    return const Success([]);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (onGetArticlesByCategory != null) {
      return onGetArticlesByCategory!(categoryId);
    }
    return const Success([]);
  }

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async {
    if (onGetCategories != null) {
      return onGetCategories!();
    }
    return const Success([sampleCategory1, sampleCategory2]);
  }

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async {
    if (onGetFixedTags != null) {
      return onGetFixedTags!();
    }
    return const Success([sampleTag1, sampleTag2]);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    if (onGetHomeFeed != null) {
      return onGetHomeFeed!(
        preferredCategoryIds: preferredCategoryIds,
        limit: limit,
        offset: offset,
      );
    }
    return const Success([sampleArticle1]);
  }

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async {
    return const Success(sampleArticle1);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    return const Success([]);
  }

  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<bool>> isArticleStarred(
      String articleId, String userId) async {
    return const Success(false);
  }

  @override
  Future<ApiResult<void>> saveBookmark(
      String articleId, String userId) async {
    if (onSaveBookmark != null) {
      return onSaveBookmark!(articleId, userId);
    }
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> removeBookmark(
      String articleId, String userId) async {
    if (onRemoveBookmark != null) {
      return onRemoveBookmark!(articleId, userId);
    }
    return const Success(null);
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) async {
    if (onGetSavedArticles != null) {
      return onGetSavedArticles!(userId);
    }
    return const Success([sampleArticle1]);
  }

  @override
  Future<ApiResult<bool>> isArticleSaved(
      String articleId, String userId) async {
    return const Success(false);
  }

  @override
  Future<ApiResult<ArticleEntity>> saveDraft(
      Map<String, dynamic> draftData) async {
    return const Success(sampleArticle1);
  }

  @override
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId) async {
    return const Success(sampleArticle1);
  }

  @override
  Future<ApiResult<ArticleEntity>> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    return const Success(sampleArticle1);
  }

  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async {
    return const Success(null);
  }

  @override
  Future<void> clearDownloadedArticles() async {}
}

void main() {
  late FakeArticlesRepository fakeRepo;
  late SearchArticlesUseCase searchArticlesUseCase;
  late GetArticlesByCategoryUseCase getArticlesByCategoryUseCase;
  late GetCategoriesUseCase getCategoriesUseCase;
  late GetFixedTagsUseCase getFixedTagsUseCase;

  setUp(() {
    fakeRepo = FakeArticlesRepository();
    searchArticlesUseCase = SearchArticlesUseCase(fakeRepo);
    getArticlesByCategoryUseCase = GetArticlesByCategoryUseCase(fakeRepo);
    getCategoriesUseCase = GetCategoriesUseCase(fakeRepo);
    getFixedTagsUseCase = GetFixedTagsUseCase(fakeRepo);
  });

  SearchCubit createCubit() {
    return SearchCubit(
      searchArticlesUseCase: searchArticlesUseCase,
      getArticlesByCategoryUseCase: getArticlesByCategoryUseCase,
      getCategoriesUseCase: getCategoriesUseCase,
      getFixedTagsUseCase: getFixedTagsUseCase,
    );
  }

  test('loads categories and fixed tags on initialization', () async {
    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(cubit.state, isA<SearchInitial>());
    expect(cubit.state.categories.length, equals(2));
    expect(cubit.state.tags.length, equals(2));
    expect(cubit.categories.first.name, equals('Technology'));
    expect(cubit.tags.first.name, equals('flutter'));

    await cubit.close();
  });

  test('debounces search queries by 350ms', () async {
    int callCount = 0;
    fakeRepo.onSearchArticles = (query) async {
      callCount++;
      return const Success([sampleArticle1]);
    };

    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    cubit.onQueryChanged('f');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    cubit.onQueryChanged('fl');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    cubit.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(callCount, equals(0));

    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(callCount, equals(1));
    expect(cubit.state, isA<SearchLoaded>());
    final loaded = cubit.state as SearchLoaded;
    expect(loaded.results.first.title, equals('Flutter in Action'));

    await cubit.close();
  });

  test('category selection fetches articles immediately without debounce', () async {
    fakeRepo.onGetArticlesByCategory = (catId) async {
      return const Success([sampleArticle3]);
    };

    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    await cubit.selectCategory(sampleCategory2);

    expect(cubit.state, isA<SearchLoaded>());
    final loaded = cubit.state as SearchLoaded;
    expect(loaded.selectedCategory?.id, equals('cat_2'));
    expect(loaded.results.first.title, equals('Quantum Physics'));

    await cubit.close();
  });

  test('tag filtering filters loaded results client-side', () async {
    fakeRepo.onSearchArticles = (query) async {
      return const Success([sampleArticle1, sampleArticle2]);
    };

    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    cubit.onQueryChanged('tech');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(cubit.state, isA<SearchLoaded>());
    var loaded = cubit.state as SearchLoaded;
    expect(loaded.results.length, equals(2));

    cubit.toggleTag('flutter');
    expect(cubit.state, isA<SearchLoaded>());
    loaded = cubit.state as SearchLoaded;
    expect(loaded.results.length, equals(1));
    expect(loaded.results.first.id, equals('art_1'));

    cubit.toggleTag('flutter');
    expect(cubit.state, isA<SearchLoaded>());
    loaded = cubit.state as SearchLoaded;
    expect(loaded.results.length, equals(2));

    await cubit.close();
  });

  test('emits SearchEmpty when query yields no results', () async {
    fakeRepo.onSearchArticles = (query) async {
      return const Success([]);
    };

    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    cubit.onQueryChanged('nonexistent');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(cubit.state, isA<SearchEmpty>());

    await cubit.close();
  });

  test('emits SearchError with offline message on network failure', () async {
    fakeRepo.onSearchArticles = (query) async {
      return const FailureResult(ServerFailure('SocketException: network is offline'));
    };

    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    cubit.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(cubit.state, isA<SearchError>());
    final error = cubit.state as SearchError;
    expect(
      error.message,
      equals('You are currently offline. Please check your internet connection.'),
    );

    await cubit.close();
  });

  test('ignores stale responses when newer query finishes first', () async {
    final slowCompleter = Completer<ApiResult<List<ArticleEntity>>>();

    fakeRepo.onSearchArticles = (query) {
      if (query == 'slow') {
        return slowCompleter.future;
      }
      return Future.value(const Success([sampleArticle2]));
    };

    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    cubit.onQueryChanged('slow');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    cubit.onQueryChanged('fast');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(cubit.state, isA<SearchLoaded>());
    var loaded = cubit.state as SearchLoaded;
    expect(loaded.results.first.title, equals('AI Revolution'));

    slowCompleter.complete(const Success([sampleArticle1]));
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(cubit.state, isA<SearchLoaded>());
    loaded = cubit.state as SearchLoaded;
    expect(loaded.results.first.title, equals('AI Revolution'));

    await cubit.close();
  });

  test('clearing query reverts state to SearchInitial', () async {
    fakeRepo.onSearchArticles = (query) async {
      return const Success([sampleArticle1]);
    };

    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    cubit.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(cubit.state, isA<SearchLoaded>());

    cubit.onQueryChanged('');
    expect(cubit.state, isA<SearchInitial>());

    await cubit.close();
  });

  test('retry re-executes last failed query', () async {
    bool fail = true;
    fakeRepo.onSearchArticles = (query) async {
      if (fail) {
        return const FailureResult(ServerFailure('Connection timed out'));
      }
      return const Success([sampleArticle1]);
    };

    final cubit = createCubit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    cubit.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(cubit.state, isA<SearchError>());

    fail = false;
    cubit.retry();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(cubit.state, isA<SearchLoaded>());

    await cubit.close();
  });
}
