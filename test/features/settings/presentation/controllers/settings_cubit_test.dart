import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/settings/domain/usecases/clear_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_archive_cache_size_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_settings_profile_use_case.dart';
import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeProfileRepository profileRepo;
  late _FakeOfflineArticlesRepository offlineRepo;
  late _FakeAuthRepository authRepo;
  late SettingsCubit cubit;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'pref_font_scale': 'Editorial',
      'pref_serif_mode': false,
      'pref_bionic_guide': true,
      'pref_morning_briefing': false,
      'pref_breaking_alerts': true,
      'pref_data_preservation': true,
      'pref_wifi_only': false,
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
      expect(s.serifMode, isFalse);
      expect(s.bionicGuide, isTrue);
      expect(s.morningBriefing, isFalse);
      expect(s.breakingAlerts, isTrue);
      expect(s.dataPreservation, isTrue);
      expect(s.wifiOnly, isFalse);
    });

    test('setFontScale persists and updates state', () {
      cubit.setFontScale('Large');
      expect(cubit.state.fontScale, equals('Large'));
      expect(SharedPreferencesSingleton.getString('pref_font_scale'), equals('Large'));
    });

    test('toggle toggles and persists preference boolean values', () {
      cubit.setSerifMode(true);
      expect(cubit.state.serifMode, isTrue);

      cubit.setBionicGuide(false);
      expect(cubit.state.bionicGuide, isFalse);

      cubit.setMorningBriefing(true);
      expect(cubit.state.morningBriefing, isTrue);

      cubit.setBreakingAlerts(false);
      expect(cubit.state.breakingAlerts, isFalse);

      cubit.setDataPreservation(false);
      expect(cubit.state.dataPreservation, isFalse);

      cubit.setWifiOnly(true);
      expect(cubit.state.wifiOnly, isTrue);

      cubit.toggleDataPreservation(true);
      expect(cubit.state.dataPreservation, isTrue);

      cubit.toggleWifiOnly(false);
      expect(cubit.state.wifiOnly, isFalse);
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
}
