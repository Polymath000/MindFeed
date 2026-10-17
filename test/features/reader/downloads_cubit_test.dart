import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/collections/presentation/cubit/downloads/downloads_cubit.dart';
import 'package:mind_feed/features/collections/presentation/cubit/downloads/downloads_state.dart';
import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_local_data_source.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_downloaded_article_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_downloaded_articles_use_case.dart';

class FakeArticlesLocalDataSource implements ArticlesLocalDataSource {
  final Map<String, DownloadedArticleEntity> storage = {};
  bool shouldThrowOnGet = false;
  bool shouldThrowOnDelete = false;

  @override
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article) async {
    storage[article.id] = article;
  }

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async {
    if (shouldThrowOnGet) throw Exception('Storage error');
    return storage.values.toList();
  }

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async {
    return storage[id];
  }

  @override
  Future<void> deleteDownloadedArticle(String id) async {
    if (shouldThrowOnDelete) throw Exception('Delete error');
    storage.remove(id);
  }

  @override
  Future<void> clearAllDownloadedArticles() async {
    storage.clear();
  }
}

DownloadedArticleEntity createTestArticle({
  required String id,
  required String title,
  String slug = 'tech',
  String author = 'John Doe',
}) {
  return DownloadedArticleEntity(
    id: id,
    title: title,
    excerpt: 'Test excerpt',
    content: 'Full markdown content here',
    authorName: author,
    authorRole: 'Writer',
    authorAvatar: '',
    categoryId: 'cat_1',
    categorySlug: slug,
    tags: const ['AI', 'Mobile'],
    publishedAt: DateTime(2026, 3, 1),
    readingTimeMinutes: 4,
    downloadedAt: DateTime(2026, 3, 2),
  );
}

void main() {
  late FakeArticlesLocalDataSource fakeDataSource;
  late GetDownloadedArticlesUseCase getUseCase;
  late DeleteDownloadedArticleUseCase deleteUseCase;
  late DownloadsCubit cubit;

  setUp(() {
    fakeDataSource = FakeArticlesLocalDataSource();
    getUseCase = GetDownloadedArticlesUseCase(fakeDataSource);
    deleteUseCase = DeleteDownloadedArticleUseCase(fakeDataSource);
    cubit = DownloadsCubit(
      getDownloadedArticlesUseCase: getUseCase,
      deleteDownloadedArticleUseCase: deleteUseCase,
      localDataSource: fakeDataSource,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has correct defaults', () {
    expect(cubit.state.status, equals(DownloadsStatus.initial));
    expect(cubit.state.allArticles, isEmpty);
    expect(cubit.state.filteredArticles, isEmpty);
    expect(cubit.state.searchQuery, isEmpty);
  });

  test('loadDownloads fetches articles from storage and updates state',
      () async {
    final art1 = createTestArticle(id: '1', title: 'First Article');
    final art2 = createTestArticle(id: '2', title: 'Second Article');
    await fakeDataSource.saveDownloadedArticle(art1);
    await fakeDataSource.saveDownloadedArticle(art2);

    await cubit.loadDownloads();

    expect(cubit.state.status, equals(DownloadsStatus.loaded));
    expect(cubit.state.allArticles.length, equals(2));
    expect(cubit.state.filteredArticles.length, equals(2));
  });

  test('loadDownloads handles empty storage', () async {
    await cubit.loadDownloads();

    expect(cubit.state.status, equals(DownloadsStatus.loaded));
    expect(cubit.state.allArticles, isEmpty);
    expect(cubit.state.filteredArticles, isEmpty);
  });

  test('filterArticles filters by title, author, category and tags', () async {
    final art1 = createTestArticle(
      id: '1',
      title: 'Quantum Computing Frontiers',
      slug: 'physics',
      author: 'Alice Smith',
    );
    final art2 = createTestArticle(
      id: '2',
      title: 'Mobile Architecture Essentials',
      slug: 'tech',
      author: 'Bob Jones',
    );
    await fakeDataSource.saveDownloadedArticle(art1);
    await fakeDataSource.saveDownloadedArticle(art2);
    await cubit.loadDownloads();

    cubit.filterArticles('Quantum');
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.filteredArticles.first.id, equals('1'));

    cubit.filterArticles('Bob');
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.filteredArticles.first.id, equals('2'));

    cubit.filterArticles('physics');
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.filteredArticles.first.id, equals('1'));

    cubit.filterArticles('nonexistent');
    expect(cubit.state.filteredArticles, isEmpty);

    cubit.filterArticles('');
    expect(cubit.state.filteredArticles.length, equals(2));
  });

  test('deleteDownload removes article from storage and updates lists',
      () async {
    final art1 = createTestArticle(id: '1', title: 'Article One');
    final art2 = createTestArticle(id: '2', title: 'Article Two');
    await fakeDataSource.saveDownloadedArticle(art1);
    await fakeDataSource.saveDownloadedArticle(art2);
    await cubit.loadDownloads();

    await cubit.deleteDownload('1');

    expect(cubit.state.allArticles.length, equals(1));
    expect(cubit.state.filteredArticles.length, equals(1));
    expect(cubit.state.allArticles.first.id, equals('2'));
    expect(cubit.state.feedbackMessage, isNotNull);
    final stored = await fakeDataSource.getDownloadedArticles();
    expect(stored.length, equals(1));
    expect(stored.first.id, equals('2'));
  });

  test('deleteDownload handles failure gracefully', () async {
    final art = createTestArticle(id: '1', title: 'Resilient Article');
    await fakeDataSource.saveDownloadedArticle(art);
    await cubit.loadDownloads();

    fakeDataSource.shouldThrowOnDelete = true;
    await cubit.deleteDownload('1');

    expect(cubit.state.feedbackMessage, contains('Failed to delete'));
  });
}
