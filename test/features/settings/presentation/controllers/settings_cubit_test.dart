import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/settings/domain/entities/reader_preferences_entity.dart';
import 'package:mind_feed/features/settings/domain/usecases/clear_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_archive_cache_size_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_reader_preferences_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_settings_profile_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/update_reader_preferences_use_case.dart';
import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';

class _FakeProfileRepository extends Fake implements ProfileRepository {
  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId) async =>
      const Success({'display_name': 'Alice Editorial', 'avatar_url': 'https://example.com/avatar.jpg'});

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(String userId) async =>
      const Success([{'name': 'Design'}, {'name': 'Culture'}]);
}

class _FakeOfflineArticlesRepository extends Fake implements OfflineArticlesRepository {
  List<DownloadedArticleEntity> items = [];

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async => items;

  @override
  Future<void> clearAllDownloadedArticles() async {
    items.clear();
  }
}

class _FakeAuthRepository extends Fake implements AuthRepository {
  bool loggedOut = false;

  @override
  Future<ApiResult<void>> logout() async {
    loggedOut = true;
    return const Success(null);
  }
}

class _MockGetReaderPreferencesUseCase extends Fake implements GetReaderPreferencesUseCase {
  int callCount = 0;
  ReaderPreferencesEntity preferences = const ReaderPreferencesEntity(
    fontScale: 'Compact',
  );

  @override
  Future<ApiResult<ReaderPreferencesEntity>> call() async {
    callCount++;
    return Success(preferences);
  }
}

class _MockUpdateReaderPreferencesUseCase extends Fake implements UpdateReaderPreferencesUseCase {
  int callCount = 0;
  String? lastFontScale;
  ReaderPreferencesEntity current = const ReaderPreferencesEntity();

  @override
  Future<ApiResult<ReaderPreferencesEntity>> call({
    String? fontScale,
  }) async {
    callCount++;
    lastFontScale = fontScale;
    current = current.copyWith(
      fontScale: fontScale,
    );
    return Success(current);
  }
}

class _FailingUpdateReaderPreferencesUseCase extends Fake
    implements UpdateReaderPreferencesUseCase {
  @override
  Future<ApiResult<ReaderPreferencesEntity>> call({
    String? fontScale,
  }) async {
    return const FailureResult(CacheFailure('Failed to update reader preferences'));
  }
}

class _FailingClearDownloadedArticlesUseCase extends Fake
    implements ClearDownloadedArticlesUseCase {
  @override
  Future<ApiResult<void>> call() async {
    return const FailureResult(CacheFailure('Failed to clear cache'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeProfileRepository profileRepo;
  late _FakeOfflineArticlesRepository offlineRepo;
  late _FakeAuthRepository authRepo;
  late SettingsCubit cubit;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      AppConstants.fontScaleKey: 'Editorial',
    });
    await SharedPreferencesSingleton.init();
  });

  setUp(() {
    profileRepo = _FakeProfileRepository();
    offlineRepo = _FakeOfflineArticlesRepository();
    authRepo = _FakeAuthRepository();

    final getProfileUseCase = GetSettingsProfileUseCase(profileRepo);
    final getCacheSizeUseCase = GetArchiveCacheSizeUseCase(GetDownloadedArticlesUseCase(offlineRepo));
    final clearCacheUseCase = ClearDownloadedArticlesUseCase(offlineRepo);
    final logoutUseCase = LogoutUseCase(authRepo: authRepo);

    cubit = SettingsCubit(
      getSettingsProfileUseCase: getProfileUseCase,
      getArchiveCacheSizeUseCase: getCacheSizeUseCase,
      clearDownloadedArticlesUseCase: clearCacheUseCase,
      logoutUseCase: logoutUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SettingsCubit', () {
    test('initial state is SettingsInitial with defaults', () {
      expect(cubit.state, isA<SettingsInitial>());
      expect(cubit.state.cachedMegabytes, equals(0.0));
      expect(cubit.state.fontScale, equals('Standard'));
    });

    test('loadSettings reads shared preferences and updates state to SettingsLoaded', () async {
      await cubit.loadSettings();

      expect(cubit.state, isA<SettingsLoaded>());
      final s = cubit.state as SettingsLoaded;
      expect(s.fontScale, equals('Editorial'));
    });

    test('setFontScale persists and updates state', () {
      cubit.setFontScale('Large');
      expect(cubit.state.fontScale, equals('Large'));
      expect(SharedPreferencesSingleton.getString(AppConstants.fontScaleKey), equals('Large'));
    });

    test('clearCache resets cachedMegabytes to 0.0 and delegates to use case', () async {
      offlineRepo.items.add(DownloadedArticleEntity(
        id: 'story_1',
        title: 'Title',
        excerpt: 'Excerpt',
        content: 'Content',
        authorName: 'Author',
        authorRole: 'Role',
        authorAvatar: '',
        categoryId: 'cat',
        categorySlug: 'slug',
        tags: const [],
        publishedAt: DateTime(2026, 1, 1),
        readingTimeMinutes: 2,
        downloadedAt: DateTime(2026, 1, 2),
      ));

      await cubit.loadCacheSize();
      expect(cubit.state.cachedMegabytes, greaterThan(0.0));

      await cubit.clearCache();
      expect(cubit.state.cachedMegabytes, equals(0.0));
      expect(offlineRepo.items.isEmpty, isTrue);
    });

    test('signOut delegates to LogoutUseCase', () async {
      final result = await cubit.signOut();
      expect(result, isA<Success<void>>());
      expect(authRepo.loggedOut, isTrue);
    });
  });

  group('SettingsCubit with injected ReaderPreferences use cases', () {
    late _MockGetReaderPreferencesUseCase mockGetPrefsUseCase;
    late _MockUpdateReaderPreferencesUseCase mockUpdatePrefsUseCase;
    late SettingsCubit injectedCubit;

    setUp(() {
      mockGetPrefsUseCase = _MockGetReaderPreferencesUseCase();
      mockUpdatePrefsUseCase = _MockUpdateReaderPreferencesUseCase();

      injectedCubit = SettingsCubit(
        getSettingsProfileUseCase: GetSettingsProfileUseCase(profileRepo),
        getArchiveCacheSizeUseCase: GetArchiveCacheSizeUseCase(GetDownloadedArticlesUseCase(offlineRepo)),
        clearDownloadedArticlesUseCase: ClearDownloadedArticlesUseCase(offlineRepo),
        logoutUseCase: LogoutUseCase(authRepo: authRepo),
        getReaderPreferencesUseCase: mockGetPrefsUseCase,
        updateReaderPreferencesUseCase: mockUpdatePrefsUseCase,
      );
    });

    tearDown(() {
      injectedCubit.close();
    });

    test('loadSettings uses injected GetReaderPreferencesUseCase and updates state', () async {
      await injectedCubit.loadSettings();

      expect(mockGetPrefsUseCase.callCount, equals(1));
      expect(injectedCubit.state, isA<SettingsLoaded>());
      final state = injectedCubit.state as SettingsLoaded;
      expect(state.fontScale, equals('Compact'));
    });

    test('setFontScale uses injected UpdateReaderPreferencesUseCase', () async {
      await injectedCubit.setFontScale('Large');

      expect(mockUpdatePrefsUseCase.callCount, equals(1));
      expect(mockUpdatePrefsUseCase.lastFontScale, equals('Large'));
      expect(injectedCubit.state.fontScale, equals('Large'));
    });

    test('emits SettingsError when updateReaderPreferencesUseCase fails on setFontScale', () async {
      final failingUpdateUseCase = _FailingUpdateReaderPreferencesUseCase();
      final cubitWithFailingUpdate = SettingsCubit(
        getSettingsProfileUseCase: GetSettingsProfileUseCase(profileRepo),
        getArchiveCacheSizeUseCase: GetArchiveCacheSizeUseCase(GetDownloadedArticlesUseCase(offlineRepo)),
        clearDownloadedArticlesUseCase: ClearDownloadedArticlesUseCase(offlineRepo),
        logoutUseCase: LogoutUseCase(authRepo: authRepo),
        getReaderPreferencesUseCase: mockGetPrefsUseCase,
        updateReaderPreferencesUseCase: failingUpdateUseCase,
      );

      await cubitWithFailingUpdate.setFontScale('Large');
      expect(cubitWithFailingUpdate.state, isA<SettingsError>());
      expect((cubitWithFailingUpdate.state as SettingsError).message,
          equals('Failed to update reader preferences'));

      cubitWithFailingUpdate.close();
    });

    test('emits SettingsError when clearCache fails', () async {
      final failingClearUseCase = _FailingClearDownloadedArticlesUseCase();
      final cubitWithFailingClear = SettingsCubit(
        getSettingsProfileUseCase: GetSettingsProfileUseCase(profileRepo),
        getArchiveCacheSizeUseCase: GetArchiveCacheSizeUseCase(GetDownloadedArticlesUseCase(offlineRepo)),
        clearDownloadedArticlesUseCase: failingClearUseCase,
        logoutUseCase: LogoutUseCase(authRepo: authRepo),
      );

      await cubitWithFailingClear.clearCache();
      expect(cubitWithFailingClear.state, isA<SettingsError>());
      expect((cubitWithFailingClear.state as SettingsError).message,
          equals('Failed to clear cache'));

      cubitWithFailingClear.close();
    });
  });
}
