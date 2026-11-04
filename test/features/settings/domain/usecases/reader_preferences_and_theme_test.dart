import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_markdown_body.dart';
import 'package:mind_feed/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:mind_feed/features/settings/data/repos/settings_repo_impl.dart';
import 'package:mind_feed/features/settings/domain/entities/reader_preferences_entity.dart';
import 'package:mind_feed/features/settings/domain/repos/settings_repo.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_reader_preferences_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/update_reader_preferences_use_case.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class _ThrowingSettingsLocalDataSource implements SettingsLocalDataSource {
  @override
  Future<ReaderPreferencesEntity> getReaderPreferences() async {
    throw Exception('Local storage read failure');
  }

  @override
  Future<ReaderPreferencesEntity> updateReaderPreferences({
    String? fontScale,
  }) async {
    throw Exception('Local storage write failure');
  }
}

class _FailingSettingsRepository implements SettingsRepository {
  @override
  Future<ApiResult<ReaderPreferencesEntity>> getReaderPreferences() async {
    return const FailureResult(CacheFailure('Repository load failed'));
  }

  @override
  Future<ApiResult<ReaderPreferencesEntity>> updateReaderPreferences({
    String? fontScale,
  }) async {
    return const FailureResult(CacheFailure('Repository update failed'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      AppConstants.fontScaleKey: AppConstants.defaultFontScale,
    });
    await SharedPreferencesSingleton.init();
    await const SettingsLocalDataSourceImpl().updateReaderPreferences(
      fontScale: AppConstants.defaultFontScale,
    );
  });

  group('SettingsLocalDataSourceImpl and SettingsRepositoryImpl', () {
    late SettingsLocalDataSource localDataSource;
    late SettingsRepository repository;

    setUp(() {
      localDataSource = const SettingsLocalDataSourceImpl();
      repository = SettingsRepositoryImpl(localDataSource);
    });

    test('localDataSource gets fallback reader preferences when cache is empty', () async {
      final prefs = await localDataSource.getReaderPreferences();
      expect(prefs.fontScale, equals('Standard'));
    });

    test('localDataSource updates fontScale and persists to storage', () async {
      final updated = await localDataSource.updateReaderPreferences(
        fontScale: 'Large',
      );
      expect(updated.fontScale, equals('Large'));

      final fetched = await localDataSource.getReaderPreferences();
      expect(fetched.fontScale, equals('Large'));
      expect(SharedPreferencesSingleton.getString(AppConstants.fontScaleKey), equals('Large'));
    });

    test('repository getReaderPreferences returns Success<ReaderPreferencesEntity>', () async {
      await localDataSource.updateReaderPreferences(fontScale: 'Compact');

      final result = await repository.getReaderPreferences();
      expect(result, isA<Success<ReaderPreferencesEntity>>());
      result.when(
        success: (prefs) {
          expect(prefs.fontScale, equals('Compact'));
        },
        failure: (f) => fail('Expected Success but got $f'),
      );
    });

    test('repository updateReaderPreferences returns Success<ReaderPreferencesEntity>', () async {
      final result = await repository.updateReaderPreferences(
        fontScale: 'Editorial',
      );
      expect(result, isA<Success<ReaderPreferencesEntity>>());
      result.when(
        success: (prefs) {
          expect(prefs.fontScale, equals('Editorial'));
        },
        failure: (f) => fail('Expected Success but got $f'),
      );

      final storedScale = SharedPreferencesSingleton.getString(AppConstants.fontScaleKey);
      expect(storedScale, equals('Editorial'));
    });

    test('repository returns FailureResult when local data source throws on get', () async {
      final failingRepo = SettingsRepositoryImpl(_ThrowingSettingsLocalDataSource());
      final result = await failingRepo.getReaderPreferences();
      expect(result, isA<FailureResult<ReaderPreferencesEntity>>());
      result.when(
        success: (_) => fail('Expected FailureResult'),
        failure: (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Local storage read failure'));
        },
      );
    });

    test('repository returns FailureResult when local data source throws on update', () async {
      final failingRepo = SettingsRepositoryImpl(_ThrowingSettingsLocalDataSource());
      final result = await failingRepo.updateReaderPreferences(fontScale: 'Large');
      expect(result, isA<FailureResult<ReaderPreferencesEntity>>());
      result.when(
        success: (_) => fail('Expected FailureResult'),
        failure: (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Local storage write failure'));
        },
      );
    });
  });

  group('GetReaderPreferencesUseCase and UpdateReaderPreferencesUseCase', () {
    late SettingsLocalDataSource localDataSource;
    late SettingsRepository repository;
    late GetReaderPreferencesUseCase getUseCase;
    late UpdateReaderPreferencesUseCase updateUseCase;

    setUp(() {
      localDataSource = const SettingsLocalDataSourceImpl();
      repository = SettingsRepositoryImpl(localDataSource);
      getUseCase = GetReaderPreferencesUseCase(repository);
      updateUseCase = UpdateReaderPreferencesUseCase(repository);
    });

    test('GetReaderPreferencesUseCase returns default preferences successfully', () async {
      final result = await getUseCase();
      expect(result, isA<Success<ReaderPreferencesEntity>>());
      result.when(
        success: (prefs) {
          expect(prefs.fontScale, equals('Standard'));
        },
        failure: (f) => fail('Expected Success but got $f'),
      );
    });

    test('UpdateReaderPreferencesUseCase propagates fontScale updates', () async {
      final updateResult = await updateUseCase(fontScale: 'Large');
      expect(updateResult, isA<Success<ReaderPreferencesEntity>>());
      updateResult.when(
        success: (prefs) {
          expect(prefs.fontScale, equals('Large'));
        },
        failure: (f) => fail('Expected Success but got $f'),
      );

      final getResult = await getUseCase();
      expect(getResult, isA<Success<ReaderPreferencesEntity>>());
      getResult.when(
        success: (prefs) {
          expect(prefs.fontScale, equals('Large'));
        },
        failure: (f) => fail('Expected Success but got $f'),
      );
    });

    test('use cases propagate FailureResult on repository error', () async {
      final failingRepo = _FailingSettingsRepository();
      final failingGetUseCase = GetReaderPreferencesUseCase(failingRepo);
      final failingUpdateUseCase = UpdateReaderPreferencesUseCase(failingRepo);

      final getResult = await failingGetUseCase();
      expect(getResult, isA<FailureResult<ReaderPreferencesEntity>>());

      final updateResult = await failingUpdateUseCase(fontScale: 'Editorial');
      expect(updateResult, isA<FailureResult<ReaderPreferencesEntity>>());
    });
  });

  group('ThemeModeCubit', () {
    test('initializes with ThemeModeLight when preference is unset', () {
      final cubit = ThemeModeCubit();
      expect(cubit.state, isA<ThemeModeLight>());
      cubit.close();
    });

    test('initializes with ThemeModeLight when stored preference is light', () async {
      await SharedPreferencesSingleton.setString(AppConstants.themeModeKey, ThemeMode.light.name);
      final cubit = ThemeModeCubit();
      expect(cubit.state, isA<ThemeModeLight>());
      cubit.close();
    });

    test('initializes with ThemeModeDark when stored preference is dark', () async {
      await SharedPreferencesSingleton.setString(AppConstants.themeModeKey, ThemeMode.dark.name);
      final cubit = ThemeModeCubit();
      expect(cubit.state, isA<ThemeModeDark>());
      cubit.close();
    });

    test('emits ThemeModeLight when ThemeMode.light is selected and persists value', () async {
      final cubit = ThemeModeCubit();
      await cubit.changeThemeMode(ThemeMode.light);

      expect(cubit.state, isA<ThemeModeLight>());
      expect(SharedPreferencesSingleton.getString(AppConstants.themeModeKey), equals(ThemeMode.light.name));
      cubit.close();
    });

    test('emits ThemeModeDark when ThemeMode.dark is selected and persists value', () async {
      final cubit = ThemeModeCubit();
      await cubit.changeThemeMode(ThemeMode.dark);

      expect(cubit.state, isA<ThemeModeDark>());
      expect(SharedPreferencesSingleton.getString(AppConstants.themeModeKey), equals(ThemeMode.dark.name));
      cubit.close();
    });

    test('emits ThemeModeSystem when ThemeMode.system is selected and persists value', () async {
      await SharedPreferencesSingleton.setString(AppConstants.themeModeKey, ThemeMode.dark.name);
      final cubit = ThemeModeCubit();
      expect(cubit.state, isA<ThemeModeDark>());

      await cubit.changeThemeMode(ThemeMode.system);
      expect(cubit.state, isA<ThemeModeSystem>());
      expect(SharedPreferencesSingleton.getString(AppConstants.themeModeKey), equals(ThemeMode.system.name));
      cubit.close();
    });
  });

  group('ArticleReaderMarkdownBody typography preferences', () {
    test('resolveFontSizeFactor returns exact scale multipliers', () {
      expect(ArticleReaderMarkdownBody.resolveFontSizeFactor('Compact'), equals(0.90));
      expect(ArticleReaderMarkdownBody.resolveFontSizeFactor('Standard'), equals(1.0));
      expect(ArticleReaderMarkdownBody.resolveFontSizeFactor('Editorial'), equals(1.08));
      expect(ArticleReaderMarkdownBody.resolveFontSizeFactor('Large'), equals(1.18));
      expect(ArticleReaderMarkdownBody.resolveFontSizeFactor('Unknown'), equals(1.0));
    });

    Widget createTestArticle({
      required String fontScale,
      String? content,
      String excerpt = 'Editorial excerpt summary text',
      String title = 'Typography Testing Title',
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ArticleReaderMarkdownBody(
              content: content ?? '### Heading 3\nMarkdown paragraph text content.',
              excerpt: excerpt,
              title: title,
              fontScale: fontScale,
            ),
          ),
        ),
      );
    }

    testWidgets('renders markdown with custom fontScale Large', (tester) async {
      await tester.pumpWidget(
        createTestArticle(
          fontScale: 'Large',
          content: 'Markdown paragraph text content.',
          excerpt: 'Editorial excerpt summary text',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ArticleReaderMarkdownBody), findsOneWidget);
      expect(find.byType(MarkdownBody), findsOneWidget);
      expect(find.text('Editorial excerpt summary text'), findsOneWidget);

      final excerptText = tester.widget<Text>(find.text('Editorial excerpt summary text'));
      final expectedExcerptSize = (AppTextStyles.readerExcerpt.fontSize ?? 16.0) * 1.18;
      expect(excerptText.style?.fontSize, closeTo(expectedExcerptSize, 0.001));
      expect(excerptText.style?.fontFamily, isNull);

      final markdownWidget = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
      final expectedBodySize = (AppTextStyles.readerBodyParagraph.fontSize ?? 16.0) * 1.18;
      expect(markdownWidget.styleSheet?.p?.fontSize, closeTo(expectedBodySize, 0.001));
      expect(markdownWidget.styleSheet?.p?.fontFamily, isNull);
    });

    testWidgets('renders markdown with custom fontScale Compact', (tester) async {
      await tester.pumpWidget(
        createTestArticle(
          fontScale: 'Compact',
          content: 'Markdown paragraph text content.',
          excerpt: 'Editorial excerpt summary text',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ArticleReaderMarkdownBody), findsOneWidget);
      expect(find.byType(MarkdownBody), findsOneWidget);

      final excerptText = tester.widget<Text>(find.text('Editorial excerpt summary text'));
      final expectedExcerptSize = (AppTextStyles.readerExcerpt.fontSize ?? 16.0) * 0.90;
      expect(excerptText.style?.fontSize, closeTo(expectedExcerptSize, 0.001));
      expect(excerptText.style?.fontFamily, isNull);

      final markdownWidget = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
      final expectedBodySize = (AppTextStyles.readerBodyParagraph.fontSize ?? 16.0) * 0.90;
      expect(markdownWidget.styleSheet?.p?.fontSize, closeTo(expectedBodySize, 0.001));
      expect(markdownWidget.styleSheet?.p?.fontFamily, isNull);
    });

    testWidgets('renders markdown using Editorial font scale', (tester) async {
      await tester.pumpWidget(
        createTestArticle(
          fontScale: 'Editorial',
          content: 'Editorial mode content.',
          excerpt: 'Editorial summary',
        ),
      );
      await tester.pumpAndSettle();

      final markdownWidget = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
      final expectedBodySize = (AppTextStyles.readerBodyParagraph.fontSize ?? 16.0) * 1.08;
      expect(markdownWidget.styleSheet?.p?.fontSize, closeTo(expectedBodySize, 0.001));
      expect(markdownWidget.styleSheet?.p?.fontFamily, isNull);
    });

    testWidgets('renders markdown using Standard font scale', (tester) async {
      await tester.pumpWidget(
        createTestArticle(
          fontScale: 'Standard',
          content: 'Standard mode content.',
          excerpt: 'Standard summary',
        ),
      );
      await tester.pumpAndSettle();

      final markdownWidget = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
      final expectedBodySize = (AppTextStyles.readerBodyParagraph.fontSize ?? 16.0) * 1.0;
      expect(markdownWidget.styleSheet?.p?.fontSize, closeTo(expectedBodySize, 0.001));
      expect(markdownWidget.styleSheet?.p?.fontFamily, isNull);
    });
  });
}
