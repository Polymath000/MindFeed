import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/categories_cubit/categories_cubit.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mind_feed/features/profile/data/repos/profile_repo_impl.dart';
import 'package:mind_feed/features/profile/domain/usecases/save_favorite_categories_use_case.dart';

class MockProfileRemoteDataSource extends Fake implements ProfileRemoteDataSource {
  final List<Map<String, dynamic>> categoriesList = [
    {'id': 'cat-1-uuid', 'name': 'Technology', 'slug': 'technology'},
    {'id': 'cat-2-uuid', 'name': 'Business', 'slug': 'business'},
    {'id': 'cat-3-uuid', 'name': 'Science', 'slug': 'science'},
  ];
  List<String> lastSyncedCategoryIds = [];
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
      throw const PostgrestException(message: 'Remote RPC network failure');
    }
    lastSyncedCategoryIds = List.from(categoryIds);
  }

  @override
  Future<void> saveFavoriteCategoriesToProfile({
    required String userId,
    required List<String> categories,
  }) async {
    if (shouldThrow) {
      throw const PostgrestException(message: 'Remote profile save failure');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFavoriteCategories(String userId) async => [];
}

class FakePostgrestFilterBuilder<T> extends Fake implements PostgrestFilterBuilder<T> {
  @override
  Future<U> then<U>(FutureOr<U> Function(T value) onValue, {Function? onError}) async {
    return onValue(null as T);
  }
}

class FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {}

class MockSupabaseClientWithRpc extends Fake implements SupabaseClient {
  String? invokedRpc;
  Map<String, dynamic>? invokedParams;
  bool shouldThrowRpc = false;
  bool fromInvoked = false;

  @override
  PostgrestFilterBuilder<T> rpc<T>(
    String fn, {
    Map<String, dynamic>? params,
    dynamic headers,
    dynamic count,
    dynamic get,
  }) {
    invokedRpc = fn;
    invokedParams = params;
    if (shouldThrowRpc) {
      throw const PostgrestException(message: 'RPC error');
    }
    return FakePostgrestFilterBuilder<T>();
  }

  @override
  SupabaseQueryBuilder from(String table) {
    fromInvoked = true;
    return FakeSupabaseQueryBuilder();
  }
}

class FakeAuthRepository extends Fake implements AuthRepository {
  bool logoutCalled = false;

  @override
  Future<ApiResult<void>> logout() async {
    logoutCalled = true;
    return const Success(null);
  }
}

class FakeArticlesRepository extends Fake implements ArticlesRepository {
  bool clearOfflineCalled = false;

  @override
  Future<void> clearDownloadedArticles() async {
    clearOfflineCalled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late MockProfileRemoteDataSource mockRemote;
  late ProfileRepoImpl profileRepo;
  late SaveFavoriteCategoriesUseCase saveCategoriesUseCase;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesSingleton.init();

    tempDir = await Directory.systemTemp.createTemp('cat_arch_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserEntityAdapter());
    }
    await Hive.openBox<UserEntity>(AppConstants.userKey);

    mockRemote = MockProfileRemoteDataSource();
    profileRepo = ProfileRepoImpl(remoteDataSource: mockRemote);
    saveCategoriesUseCase = SaveFavoriteCategoriesUseCase(profileRepo);
  });

  tearDown(() async {
    if (Hive.isBoxOpen(AppConstants.userKey)) {
      await Hive.box<UserEntity>(AppConstants.userKey).close();
    }
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });

  group('ProfileRepository Category Synchronization Contract', () {
    test('saveLocalCategories persists desired selection to Hive box', () async {
      final userBox = Hive.box<UserEntity>(AppConstants.userKey);
      await userBox.put(
        AppConstants.userKey,
        const UserEntity(
          email: 'reader@mindfeed.com',
          userName: 'Reader',
          favoriteCategories: [],
          token: 'tok_001',
        ),
      );

      final result = await profileRepo.saveLocalCategories(
        userId: 'user-001',
        categoryNames: ['Technology', 'Science'],
      );

      expect(result, isA<Success<void>>());
      final updated = userBox.get(AppConstants.userKey);
      expect(updated?.favoriteCategories, equals(['Technology', 'Science']));
    });

    test('syncFavoriteCategories sets pending flag, maps catalog names to UUIDs, and clears pending flag on success', () async {
      final result = await profileRepo.syncFavoriteCategories(
        userId: 'user-001',
        categoryNames: ['Technology', 'Science'],
      );

      expect(result, isA<Success<void>>());
      expect(mockRemote.setCallCount, equals(1));
      expect(mockRemote.lastSyncedCategoryIds, equals(['cat-1-uuid', 'cat-3-uuid']));
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-001'), isFalse);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync'), isFalse);
    });

    test('syncFavoriteCategories handles empty selection by sending empty list and clears pending flag', () async {
      final result = await profileRepo.syncFavoriteCategories(
        userId: 'user-001',
        categoryNames: [],
      );

      expect(result, isA<Success<void>>());
      expect(mockRemote.setCallCount, equals(1));
      expect(mockRemote.lastSyncedCategoryIds, isEmpty);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-001'), isFalse);
    });

    test('syncFavoriteCategories preserves pending flag when remote call fails', () async {
      mockRemote.shouldThrow = true;

      final result = await profileRepo.syncFavoriteCategories(
        userId: 'user-001',
        categoryNames: ['Technology'],
      );

      expect(result, isA<FailureResult<void>>());
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-001'), isTrue);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync'), isTrue);
    });

    test('user pending state isolation prevents cross-user pollution', () async {
      await SharedPreferencesSingleton.setBool('pending_category_sync_user-A', value: true);
      await SharedPreferencesSingleton.setBool('pending_category_sync_user-B', value: false);

      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-A'), isTrue);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_user-B'), isFalse);

      final reconciledB = await profileRepo.reconcilePendingCategorySync(userId: 'user-B');
      expect(reconciledB, isFalse);
      expect(mockRemote.setCallCount, equals(0));
    });

    test('concurrent reconciliation calls prevent overlapping executions', () async {
      await SharedPreferencesSingleton.setBool('pending_category_sync_user-001', value: true);
      final userBox = Hive.box<UserEntity>(AppConstants.userKey);
      await userBox.put(
        AppConstants.userKey,
        const UserEntity(
          email: 'reader@mindfeed.com',
          userName: 'Reader',
          favoriteCategories: ['Technology'],
          token: 'tok_001',
        ),
      );

      final future1 = profileRepo.reconcilePendingCategorySync(userId: 'user-001');
      final future2 = profileRepo.reconcilePendingCategorySync(userId: 'user-001');

      final results = await Future.wait([future1, future2]);
      expect(results, contains(true));
      expect(results, contains(false));
    });
  });

  group('SaveFavoriteCategoriesUseCase Application Operation', () {
    test('saves locally first and then synchronizes remotely', () async {
      final userBox = Hive.box<UserEntity>(AppConstants.userKey);
      await userBox.put(
        AppConstants.userKey,
        const UserEntity(
          email: 'editor@mindfeed.com',
          userName: 'Editor',
          favoriteCategories: [],
          token: 'tok_002',
        ),
      );

      final result = await saveCategoriesUseCase(
        userId: 'editor-1',
        categoryNames: ['Business'],
      );

      expect(result.isLocalSaved, isTrue);
      expect(result.isRemoteSynced, isTrue);
      expect(result.isPendingSync, isFalse);
      final cached = userBox.get(AppConstants.userKey);
      expect(cached?.favoriteCategories, equals(['Business']));
      expect(mockRemote.lastSyncedCategoryIds, equals(['cat-2-uuid']));
    });

    test('offline resilience: remote failure preserves local state and marks pending', () async {
      mockRemote.shouldThrow = true;

      final result = await saveCategoriesUseCase(
        userId: 'offline-user',
        categoryNames: ['Science'],
      );

      expect(result.isLocalSaved, isTrue);
      expect(result.isRemoteSynced, isFalse);
      expect(result.isPendingSync, isTrue);
      final cached = Hive.box<UserEntity>(AppConstants.userKey).get(AppConstants.userKey);
      expect(cached?.favoriteCategories, equals(['Science']));
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_offline-user'), isTrue);
    });
  });

  group('CategoriesCubit Presentation State Management', () {
    test('initializes with given selection and updates on toggle', () {
      final cubit = CategoriesCubit(
        saveFavoriteCategoriesUseCase: saveCategoriesUseCase,
        initialCategories: ['Technology'],
      );

      expect(cubit.selectedCategories, contains('Technology'));
      expect(cubit.selectedCategories.length, equals(1));

      cubit.toggleCategory('Science');
      expect(cubit.selectedCategories, contains('Science'));
      expect(cubit.selectedCategories.length, equals(2));

      cubit.toggleCategory('Technology');
      expect(cubit.selectedCategories, isNot(contains('Technology')));
      expect(cubit.selectedCategories.length, equals(1));

      cubit.close();
    });

    test('saveCategories emits loading then success with remote synced', () async {
      final cubit = CategoriesCubit(
        saveFavoriteCategoriesUseCase: saveCategoriesUseCase,
      );

      final states = <CategoriesState>[];
      cubit.stream.listen(states.add);

      cubit.toggleCategory('Business');
      await cubit.saveCategories(userId: 'cubit-user');
      await Future<void>.delayed(Duration.zero);

      expect(states.any((s) => s is CategoriesLoading), isTrue);
      expect(cubit.state, isA<CategoriesSuccess>());
      final success = cubit.state as CategoriesSuccess;
      expect(success.selectedCategories, equals(['Business']));
      expect(success.isRemoteSynced, isTrue);
      expect(success.isPendingSync, isFalse);

      cubit.close();
    });

    test('saveCategories emits success when offline to permit onboarding navigation', () async {
      mockRemote.shouldThrow = true;
      final cubit = CategoriesCubit(
        saveFavoriteCategoriesUseCase: saveCategoriesUseCase,
      );

      cubit.toggleCategory('Science');
      await cubit.saveCategories(userId: 'offline-cubit-user');
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<CategoriesSuccess>());
      final success = cubit.state as CategoriesSuccess;
      expect(success.selectedCategories, equals(['Science']));
      expect(success.isRemoteSynced, isFalse);
      expect(success.isPendingSync, isTrue);
      expect(SharedPreferencesSingleton.getBool('pending_category_sync_offline-cubit-user'), isTrue);

      cubit.close();
    });
  });

  group('Atomic RPC and Fallback Elimination Check', () {
    test('ProfileRemoteDataSourceImpl calls atomic RPC set_user_favorite_categories without silent fallback on error', () async {
      final mockClient = MockSupabaseClientWithRpc();
      final dataSource = ProfileRemoteDataSourceImpl(supabaseClient: mockClient);

      await dataSource.setFavoriteCategories(
        userId: 'test-user',
        categoryIds: ['uuid-1', 'uuid-2'],
      );

      expect(mockClient.invokedRpc, equals('set_user_favorite_categories'));
      expect(mockClient.invokedParams, equals({'p_category_ids': ['uuid-1', 'uuid-2']}));
      expect(mockClient.fromInvoked, isFalse);

      mockClient.shouldThrowRpc = true;
      expect(
        () => dataSource.setFavoriteCategories(
          userId: 'test-user',
          categoryIds: ['uuid-1'],
        ),
        throwsA(isA<PostgrestException>()),
      );
      expect(mockClient.fromInvoked, isFalse);
    });
  });

  group('Clean Architecture LogoutUseCase Decoupling', () {
    test('LogoutUseCase invokes domain repositories without direct infrastructure dependencies', () async {
      final fakeAuth = FakeAuthRepository();
      final fakeArticles = FakeArticlesRepository();
      final logout = LogoutUseCase(
        authRepo: fakeAuth,
        articlesRepo: fakeArticles,
      );

      final result = await logout();

      expect(result, isA<Success<void>>());
      expect(fakeAuth.logoutCalled, isTrue);
      expect(fakeArticles.clearOfflineCalled, isTrue);
    });
  });
}
