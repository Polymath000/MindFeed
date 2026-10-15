import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/home/data/datasources/articles_local_data_source.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mind_feed/features/profile/data/services/category_sync_reconciler.dart';

class MockProfileRemoteDataSource extends Fake implements ProfileRemoteDataSource {
  final List<Map<String, dynamic>> categoriesList = [
    {'id': 'tech-id', 'name': 'Technology', 'slug': 'technology'},
    {'id': 'science-id', 'name': 'Science', 'slug': 'science'},
  ];
  List<String> lastSyncedIds = [];
  bool shouldThrow = false;
  int setCallCount = 0;

  @override
  Future<List<Map<String, dynamic>>> getCategories() async => categoriesList;

  @override
  Future<void> setFavoriteCategories({
    required String userId,
    required List<String> categoryIds,
  }) async {
    setCallCount++;
    if (shouldThrow) {
      throw Exception('Remote network failure');
    }
    lastSyncedIds = categoryIds;
  }
}

class FakeAuthRepository extends Fake implements AuthRepository {
  @override
  Future<ApiResult<void>> logout() async {
    try {
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        await Hive.box<UserEntity>(AppConstants.userKey).clear();
      }
    } catch (_) {}
    try {
      await SharedPreferencesSingleton.remove(AppConstants.tokenKey);
    } catch (_) {}
    try {
      final allKeys = SharedPreferencesSingleton.getKeys();
      for (final k in allKeys) {
        if (k.startsWith('pending_category_sync')) {
          await SharedPreferencesSingleton.remove(k);
        }
      }
    } catch (_) {}
    return const Success(null);
  }
}

class MockArticlesLocalDataSource extends Fake implements ArticlesLocalDataSource {
  bool cleared = false;
  @override
  Future<void> clearAllDownloadedArticles() async {
    cleared = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late MockProfileRemoteDataSource mockRemote;
  late MockArticlesLocalDataSource mockLocal;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesSingleton.init();

    tempDir = await Directory.systemTemp.createTemp('cat_sync_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserEntityAdapter());
    }
    await Hive.openBox<UserEntity>(AppConstants.userKey);

    mockRemote = MockProfileRemoteDataSource();
    mockLocal = MockArticlesLocalDataSource();
  });

  tearDown(() async {
    if (Hive.isBoxOpen(AppConstants.userKey)) {
      await Hive.box<UserEntity>(AppConstants.userKey).close();
    }
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });

  group('CategorySyncReconciler Tests', () {
    test('reconcilePendingSync exits immediately and returns false if no sync is pending', () async {
      final reconciler = CategorySyncReconciler(remoteDataSource: mockRemote);
      final result = await reconciler.reconcilePendingSync(userId: 'user-123');

      expect(result, isFalse);
      expect(mockRemote.setCallCount, 0);
    });

    test('reconcilePendingSync synchronizes categories from Hive when dirty flag is true and clears flag on success', () async {
      await SharedPreferencesSingleton.setBool('pending_category_sync_user-123', value: true);
      final userBox = Hive.box<UserEntity>(AppConstants.userKey);
      await userBox.put(
        AppConstants.userKey,
        const UserEntity(
          email: 'test@example.com',
          userName: 'Tester',
          token: 'tok-123',
          favoriteCategories: ['Technology', 'Science'],
        ),
      );

      final reconciler = CategorySyncReconciler(remoteDataSource: mockRemote);
      final result = await reconciler.reconcilePendingSync(userId: 'user-123');

      expect(result, isTrue);
      expect(mockRemote.setCallCount, 1);
      expect(mockRemote.lastSyncedIds, equals(['tech-id', 'science-id']));
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-123'), isFalse);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync'), isFalse);
    });

    test('reconcilePendingSync preserves dirty flag when remote call throws', () async {
      await SharedPreferencesSingleton.setBool('pending_category_sync_user-123', value: true);
      final userBox = Hive.box<UserEntity>(AppConstants.userKey);
      await userBox.put(
        AppConstants.userKey,
        const UserEntity(
          email: 'test@example.com',
          userName: 'Tester',
          token: 'tok-123',
          favoriteCategories: ['Technology'],
        ),
      );

      mockRemote.shouldThrow = true;
      final reconciler = CategorySyncReconciler(remoteDataSource: mockRemote);
      final result = await reconciler.reconcilePendingSync(userId: 'user-123');

      expect(result, isFalse);
      expect(mockRemote.setCallCount, 1);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-123'), isTrue);
    });
  });

  group('LogoutUseCase Isolation Tests', () {
    test('LogoutUseCase purges all pending_category_sync keys', () async {
      await SharedPreferencesSingleton.setBool('pending_category_sync_user-123', value: true);
      await SharedPreferencesSingleton.setBool('pending_category_sync_user-456', value: true);
      await SharedPreferencesSingleton.setBool('pending_category_sync', value: true);
      await SharedPreferencesSingleton.setString(AppConstants.tokenKey, 'token-abc');

      final logoutUseCase = LogoutUseCase(
        authRepo: FakeAuthRepository(),
        localDataSource: mockLocal,
      );

      final result = await logoutUseCase.call();

      expect(result, isA<Success<void>>());
      expect(mockLocal.cleared, isTrue);
      expect(SharedPreferencesSingleton.getString(AppConstants.tokenKey), isNull);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-123'), isNull);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-456'), isNull);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync'), isNull);
    });
  });
}
