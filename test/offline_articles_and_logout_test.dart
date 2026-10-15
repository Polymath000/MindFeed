import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/home/data/datasources/articles_local_data_source.dart';
import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_downloaded_article_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/database/cache/cache_helper.dart';
import 'package:mind_feed/core/networking/network_info.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart';
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import 'package:mind_feed/features/auth/data/repos/auth_repo_impl.dart';

class FakeNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

class FakeArticlesLocalDataSource implements ArticlesLocalDataSource {
  final Map<String, DownloadedArticleEntity> storage = {};
  bool clearAllCalled = false;

  @override
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article) async {
    storage[article.id] = article;
  }

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async {
    return storage.values.toList();
  }

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async {
    return storage[id];
  }

  @override
  Future<void> deleteDownloadedArticle(String id) async {
    storage.remove(id);
  }

  @override
  Future<void> clearAllDownloadedArticles() async {
    clearAllCalled = true;
    storage.clear();
  }
}

class TestAuthClient extends Fake implements GoTrueClient {
  final bool shouldThrow;
  bool signOutCalled = false;

  TestAuthClient({this.shouldThrow = false});

  @override
  Future<void> signOut({SignOutScope scope = SignOutScope.global}) async {
    signOutCalled = true;
    if (shouldThrow) {
      throw const AuthException('Network disconnect');
    }
  }
}

class TestSupabaseClient extends Fake implements SupabaseClient {
  final TestAuthClient authClient;

  TestSupabaseClient(this.authClient);

  @override
  GoTrueClient get auth => authClient;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('mindfeed_hive_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(DownloadedArticleEntityAdapter());
    }
    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesSingleton.init();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  DownloadedArticleEntity createArticle({
    String id = 'art_1',
    String title = 'Test Title',
    String slug = 'tech',
  }) {
    return DownloadedArticleEntity(
      id: id,
      title: title,
      excerpt: 'Short excerpt of the story',
      content: 'Full editorial content for offline reading without network images.',
      authorName: 'Jane Doe',
      authorRole: 'Tech Journalist',
      authorAvatar: '',
      categoryId: 'cat_tech',
      categorySlug: slug,
      tags: const ['AI', 'Mobile'],
      publishedAt: DateTime(2026, 3, 15, 10, 0),
      readingTimeMinutes: 4,
      downloadedAt: DateTime(2026, 3, 15, 12, 0),
    );
  }

  group('DownloadedArticleEntity', () {
    test('converts cleanly to EditorialNewsItem for UI rendering', () {
      final article = createArticle();
      final item = article.toEditorialNewsItem();

      expect(item.id, equals('art_1'));
      expect(item.badge, equals('TECH'));
      expect(item.title, equals('Test Title'));
      expect(item.updated, equals('4 min read'));
      expect(item.authorName, equals('Jane Doe'));
      expect(item.isSaved, isTrue);
      expect(item.isLive, isFalse);
      expect(item.authorAvatar, isNotEmpty);
    });

    test('supports copyWith and equality by id', () {
      final a1 = createArticle(id: 'same_id', title: 'A');
      final a2 = createArticle(id: 'same_id', title: 'B');
      final a3 = createArticle(id: 'other_id');

      expect(a1, equals(a2));
      expect(a1 == a3, isFalse);

      final updated = a1.copyWith(title: 'Updated Title');
      expect(updated.title, equals('Updated Title'));
      expect(updated.id, equals(a1.id));
    });
  });

  group('ArticlesLocalDataSource with Hive Box', () {
    late Box<DownloadedArticleEntity> testBox;
    late ArticlesLocalDataSourceImpl dataSource;

    setUp(() async {
      testBox = await Hive.openBox<DownloadedArticleEntity>('test_articles_box_${DateTime.now().microsecondsSinceEpoch}');
      dataSource = ArticlesLocalDataSourceImpl(box: testBox);
    });

    tearDown(() async {
      await testBox.deleteFromDisk();
    });

    test('save, retrieve, and delete downloaded article', () async {
      final article1 = createArticle(id: '1', title: 'First');
      final article2 = createArticle(id: '2', title: 'Second');

      await dataSource.saveDownloadedArticle(article1);
      await dataSource.saveDownloadedArticle(article2);

      final list = await dataSource.getDownloadedArticles();
      expect(list.length, equals(2));

      final retrieved = await dataSource.getDownloadedArticleById('1');
      expect(retrieved?.title, equals('First'));

      await dataSource.deleteDownloadedArticle('1');
      final afterDelete = await dataSource.getDownloadedArticles();
      expect(afterDelete.length, equals(1));
      expect(afterDelete.first.id, equals('2'));

      await dataSource.clearAllDownloadedArticles();
      final afterClear = await dataSource.getDownloadedArticles();
      expect(afterClear.isEmpty, isTrue);
    });
  });

  group('Offline Use Cases', () {
    late FakeArticlesLocalDataSource fakeDataSource;
    late DownloadArticleTextUseCase downloadUseCase;
    late GetDownloadedArticlesUseCase getArticlesUseCase;
    late DeleteDownloadedArticleUseCase deleteUseCase;

    setUp(() {
      fakeDataSource = FakeArticlesLocalDataSource();
      downloadUseCase = DownloadArticleTextUseCase(fakeDataSource);
      getArticlesUseCase = GetDownloadedArticlesUseCase(fakeDataSource);
      deleteUseCase = DeleteDownloadedArticleUseCase(fakeDataSource);
    });

    test('download use case saves article', () async {
      final article = createArticle(id: 'offline_1');
      await downloadUseCase(article);

      final stored = await fakeDataSource.getDownloadedArticleById('offline_1');
      expect(stored?.id, equals('offline_1'));
    });

    test('get downloaded articles returns all saved items', () async {
      await fakeDataSource.saveDownloadedArticle(createArticle(id: '1'));
      await fakeDataSource.saveDownloadedArticle(createArticle(id: '2'));

      final results = await getArticlesUseCase();
      expect(results.length, equals(2));
    });

    test('delete downloaded article removes target item', () async {
      await fakeDataSource.saveDownloadedArticle(createArticle(id: 'to_delete'));
      await deleteUseCase('to_delete');

      final results = await fakeDataSource.getDownloadedArticles();
      expect(results.isEmpty, isTrue);
    });
  });

  group('LogoutUseCase fail-safe purge (BR-06)', () {
    late FakeArticlesLocalDataSource fakeDataSource;
    late Box<UserEntity> userBox;

    setUp(() async {
      await SharedPreferencesSingleton.setString(
        AppConstants.tokenKey,
        'cached_jwt_token',
      );

      userBox = await Hive.openBox<UserEntity>(AppConstants.userKey);
      await userBox.put(
        'current_user',
        const UserEntity(
          userName: 'Test User',
          email: 'test@example.com',
          favoriteCategories: ['tech'],
          token: 'token_123',
        ),
      );

      fakeDataSource = FakeArticlesLocalDataSource();
      await fakeDataSource.saveDownloadedArticle(createArticle(id: 'offline_story'));
    });

    tearDown(() async {
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        await userBox.deleteFromDisk();
      }
    });

    test('successful signOut purges local cache, user box, and auth token', () async {
      final authClient = TestAuthClient(shouldThrow: false);
      final supabaseClient = TestSupabaseClient(authClient);
      final authApiSource = AuthApiSource(supabaseClient: supabaseClient);
      final authRepo = AuthRepoImpl(
        authApiSource: authApiSource,
        networkInfo: FakeNetworkInfo(),
        userCacheDataSource: UserCacheDataSource(
          cacheHelper: CacheHelper(kBoxName: AppConstants.userKey),
        ),
      );
      final logout = LogoutUseCase(
        authRepo: authRepo,
        localDataSource: fakeDataSource,
      );

      final result = await logout();

      expect(result, isA<Success<void>>());
      expect(authClient.signOutCalled, isTrue);
      expect(fakeDataSource.clearAllCalled, isTrue);
      expect(userBox.isEmpty, isTrue);
      expect(SharedPreferencesSingleton.getString(AppConstants.tokenKey), isNull);
    });

    test('failed network signOut still purges local cache, user box, and auth token in finally', () async {
      final authClient = TestAuthClient(shouldThrow: true);
      final supabaseClient = TestSupabaseClient(authClient);
      final authApiSource = AuthApiSource(supabaseClient: supabaseClient);
      final authRepo = AuthRepoImpl(
        authApiSource: authApiSource,
        networkInfo: FakeNetworkInfo(),
        userCacheDataSource: UserCacheDataSource(
          cacheHelper: CacheHelper(kBoxName: AppConstants.userKey),
        ),
      );
      final logout = LogoutUseCase(
        authRepo: authRepo,
        localDataSource: fakeDataSource,
      );

      final result = await logout();

      expect(result, isA<Success<void>>());
      expect(authClient.signOutCalled, isTrue);
      expect(fakeDataSource.clearAllCalled, isTrue);
      expect(userBox.isEmpty, isTrue);
      expect(SharedPreferencesSingleton.getString(AppConstants.tokenKey), isNull);
    });
  });
}
