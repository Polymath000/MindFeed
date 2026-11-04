import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_empty_view.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_slow_scroll_bar.dart';
import 'package:mind_feed/features/collections/presentation/views/downloaded_article_reader_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesSingleton.init();
  });

  DownloadedArticleEntity createTestDownloadedArticle({
    String id = 'offline_1',
    String title = 'Offline Quantum Mechanics',
    String excerpt =
        'A beginner guide to quantum mechanics and offline reading.',
    String content =
        '# Quantum Foundations\n\nQuantum mechanics is a fundamental theory in physics.',
    String authorName = 'Dr. Jane Quantum',
    String authorRole = 'Physics Professor',
    String authorAvatar = 'https://example.com/avatar.jpg',
    String categoryId = 'science_1',
    String categorySlug = 'science',
    List<String> tags = const ['physics', 'quantum', 'science'],
    int readingTimeMinutes = 7,
  }) {
    return DownloadedArticleEntity(
      id: id,
      title: title,
      excerpt: excerpt,
      content: content,
      authorName: authorName,
      authorRole: authorRole,
      authorAvatar: authorAvatar,
      categoryId: categoryId,
      categorySlug: categorySlug,
      tags: tags,
      publishedAt: DateTime(2026, 1, 1),
      readingTimeMinutes: readingTimeMinutes,
      downloadedAt: DateTime(2026, 2, 1),
    );
  }

  testWidgets('renders ArticleReaderEmptyView when article is null', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DownloadedArticleReaderView(article: null),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ArticleReaderEmptyView), findsOneWidget);
    expect(find.text('Article Not Found'), findsOneWidget);
    expect(find.text('No article content was provided.'), findsOneWidget);
  });

  testWidgets(
    'renders title, offline edition metadata, reading time, and markdown content',
    (tester) async {
      final article = createTestDownloadedArticle();

      await tester.pumpWidget(
        MaterialApp(
          home: DownloadedArticleReaderView(article: article),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Offline Quantum Mechanics'), findsOneWidget);
      expect(find.text('Offline edition'), findsOneWidget);
      expect(find.text('7 min read'), findsOneWidget);
      expect(find.text('SCIENCE'), findsOneWidget);
      expect(find.text('Quantum Foundations'), findsOneWidget);
      expect(
        find.text(
          'A beginner guide to quantum mechanics and offline reading.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Quantum mechanics is a fundamental theory in physics.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('renders OFFLINE fallback badge when categorySlug is empty', (
    tester,
  ) async {
    final article = createTestDownloadedArticle(categorySlug: '');

    await tester.pumpWidget(
      MaterialApp(
        home: DownloadedArticleReaderView(article: article),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('OFFLINE'), findsOneWidget);
  });

  testWidgets(
    'does NOT render author section, 5-star rating bar, cover image, or online action bar',
    (tester) async {
      final article = createTestDownloadedArticle();

      await tester.pumpWidget(
        MaterialApp(
          home: DownloadedArticleReaderView(article: article),
        ),
      );
      await tester.pumpAndSettle();

      // No author name or role rendered
      expect(find.text('Dr. Jane Quantum'), findsNothing);
      expect(find.text('Physics Professor'), findsNothing);

      // No author rating 5-star buttons
      expect(find.byKey(const Key('author_star_1')), findsNothing);
      expect(find.byKey(const Key('author_star_2')), findsNothing);
      expect(find.byKey(const Key('author_star_3')), findsNothing);
      expect(find.byKey(const Key('author_star_4')), findsNothing);
      expect(find.byKey(const Key('author_star_5')), findsNothing);

      // No cover image
      expect(find.byType(Image), findsNothing);

      // No online action bar buttons
      expect(find.byKey(const Key('article_like_button')), findsNothing);
      expect(find.byKey(const Key('article_bookmark_button')), findsNothing);
      expect(find.byKey(const Key('article_download_button')), findsNothing);

      // No tags wrap
      expect(find.text('#physics'), findsNothing);
    },
  );

  testWidgets(
    'renders ArticleSlowScrollBar and supports toggling slow scroll, changing pace, and retracting/extending',
    (tester) async {
      final longContent = List.generate(
        40,
        (i) => 'Paragraph $i: Exploring principles of offline cached reading and continuous animation frames.',
      ).join('\n\n');

      final article = createTestDownloadedArticle(content: longContent);

      await tester.pumpWidget(
        MaterialApp(
          home: DownloadedArticleReaderView(article: article),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ArticleSlowScrollBar), findsOneWidget);

      final scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      expect(scrollable.position.pixels, equals(0.0));

      // Change pace to 2.0x
      await tester.tap(find.byKey(const Key('scroll_pace_2.0')));
      await tester.pump();

      // Start slow scroll
      await tester.tap(find.byKey(const Key('slow_scroll_toggle_button')));
      await tester.pump();
      expect(find.text('Scrolling'), findsOneWidget);

      // Advance clock and verify scroll position progressed
      await tester.pump(const Duration(milliseconds: 160));
      expect(scrollable.position.pixels, greaterThan(0.0));

      // Pause slow scroll
      await tester.tap(find.byKey(const Key('slow_scroll_toggle_button')));
      await tester.pump();
      expect(find.text('Slow Scroll'), findsOneWidget);

      // Retract slow scroll bar
      await tester.tap(find.byKey(const Key('slow_scroll_retract_button')));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Extend slow scroll bar'), findsOneWidget);

      // Extend slow scroll bar
      await tester.tap(find.byKey(const Key('slow_scroll_retract_button')));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Retract slow scroll bar'), findsOneWidget);
    },
  );

  testWidgets('tapping back button pops route', (tester) async {
    final article = createTestDownloadedArticle();

    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DownloadedArticleReaderView(article: article),
                      ),
                    );
                  },
                  child: const Text('Open Reader'),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Reader'));
    await tester.pumpAndSettle();

    expect(find.byType(DownloadedArticleReaderView), findsOneWidget);

    await tester.tap(find.byKey(const Key('article_reader_back_button')));
    await tester.pumpAndSettle();

    expect(find.byType(DownloadedArticleReaderView), findsNothing);
    expect(find.text('Open Reader'), findsOneWidget);
  });
}
