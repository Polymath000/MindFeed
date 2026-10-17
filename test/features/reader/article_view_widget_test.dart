import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/features/home/presentation/cubit/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/home/presentation/views/article_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/article_slow_scroll_bar.dart';

class _WidgetFakeEngagementRepository implements ArticleEngagementRepository {
  @override
  Future<ApiResult<void>> likeArticle(String articleId, String userId) async => const Success(null);

  @override
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId) async => const Success(null);

  @override
  Future<ApiResult<bool>> isArticleLiked(String articleId, String userId) async => const Success(false);

  @override
  Future<ApiResult<AuthorRatingSummary>> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async =>
      Success(AuthorRatingSummary(
        authorKey: authorKey,
        userStars: stars,
        ratingAvg: stars.toDouble(),
        ratingCount: 1,
      ));

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async =>
      const Success(AuthorRatingSummary(
        authorKey: 'sam rivera',
        userStars: 0,
        ratingAvg: 0.0,
        ratingCount: 0,
      ));
}

void main() {
  testWidgets(
      'ArticleView renders markdown content, 5-star author rating under author, slow scroll bar, and article like button',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final item = EditorialNewsItem(
      id: 'test_1',
      badge: 'SCIENCE',
      badgeColor: const Color(0xFF4CAF50),
      title: 'Neural Networks Mapping Cellular Behavior',
      updated: '10 minutes ago',
      authorName: 'Dr. Elena Rostova',
      authorRole: 'Chief Biologist',
      authorAvatar: '',
      excerpt: 'Short summary of the breakthrough',
      content:
          '# Revolutionary Discovery\n\nBiologists have successfully mapped cellular interaction.\n\n* Key insight one\n* Key insight two',
      color: const Color(0xFFFBF8F1),
      readingTimeMinutes: 7,
      likesCount: 42,
      isLiked: true,
      authorRatingAvg: 4.5,
      authorRatingCount: 12,
      userAuthorStars: 5,
      tags: const ['Biology', 'AI'],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ArticleView(item: item),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Neural Networks Mapping Cellular Behavior'), findsOneWidget);
    expect(find.text('SCIENCE'), findsOneWidget);
    expect(find.text('7 min read'), findsOneWidget);
    expect(find.text('Dr. Elena Rostova'), findsOneWidget);
    expect(find.text('Chief Biologist'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.byKey(const Key('article_like_button')), findsOneWidget);
    expect(find.byIcon(AppIcons.thumbUp), findsOneWidget);
    expect(find.byKey(const Key('author_star_1')), findsOneWidget);
    expect(find.byKey(const Key('author_star_5')), findsOneWidget);
    expect(find.textContaining('4.5 (12 ratings)'), findsOneWidget);
    expect(find.byKey(const Key('slow_scroll_toggle_button')), findsOneWidget);
    expect(find.byKey(const Key('scroll_pace_0.5')), findsOneWidget);
    expect(find.byKey(const Key('scroll_pace_1.0')), findsOneWidget);
    expect(find.byKey(const Key('scroll_pace_1.5')), findsOneWidget);
    expect(find.byKey(const Key('scroll_pace_2.0')), findsOneWidget);
    expect(find.text('#Biology'), findsOneWidget);
    expect(find.text('#AI'), findsOneWidget);
    expect(find.textContaining('Revolutionary Discovery'), findsOneWidget);
    expect(find.textContaining('Biologists have successfully mapped cellular'), findsOneWidget);
    expect(find.bySemanticsLabel('Like article'), findsOneWidget);
    expect(find.bySemanticsLabel('Save article'), findsOneWidget);
    expect(find.bySemanticsLabel('Download article'), findsOneWidget);
    expect(find.bySemanticsLabel('Share article'), findsOneWidget);
  });

  testWidgets('ArticleView tapping author star triggers rateAuthor optimistic update', (tester) async {
    final item = EditorialNewsItem(
      id: 'test_rate',
      badge: 'TECH',
      badgeColor: const Color(0xFF2196F3),
      title: 'Quantum Computing Foundations',
      updated: 'Just now',
      authorName: 'Sam Rivera',
      authorRole: 'Software Architect',
      authorAvatar: '',
      excerpt: 'Foundations excerpt',
      content: 'Short content body',
      color: const Color(0xFFFBF8F1),
    );

    final repo = _WidgetFakeEngagementRepository();
    final cubit = ArticleReaderCubit(
      currentUserId: 'user_widget_test',
      rateAuthorUseCase: RateAuthorUseCase(repo),
    );
    await cubit.initArticle(item);
    await tester.pumpWidget(MaterialApp(home: ArticleView(item: item, cubit: cubit)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('author_star_5')), findsOneWidget);
    await tester.tap(find.byKey(const Key('author_star_5')));
    await tester.pump();

    expect(cubit.state.userAuthorStars, equals(5));
    expect(cubit.state.authorRatingCount, equals(1));
    await cubit.close();
  });

  testWidgets('ArticleView slow scroll button scrolls article at selectable pace and stops on pause', (tester) async {
    final longParagraphs = List.generate(
      40,
      (i) => 'Paragraph $i with detailed scientific analysis of neural circuits and synaptic plasticity.',
    ).join('\n\n');

    final item = EditorialNewsItem(
      id: 'scroll_test_1',
      badge: 'TECH',
      badgeColor: const Color(0xFF2196F3),
      title: 'Deep Learning in Neuroscience',
      updated: 'Just now',
      authorName: 'Dr. Alan Grant',
      authorRole: 'Research Lead',
      authorAvatar: '',
      excerpt: 'Long form article for slow scroll testing',
      content: longParagraphs,
      color: const Color(0xFFFBF8F1),
      readingTimeMinutes: 8,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ArticleView(item: item),
      ),
    );
    await tester.pumpAndSettle();

    final ScrollableState scrollable = tester.state(find.byType(Scrollable).first);
    expect(scrollable.position.pixels, equals(0.0));

    await tester.tap(find.byKey(const Key('scroll_pace_2.0')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('slow_scroll_toggle_button')));
    await tester.pump();
    expect(find.text('Scrolling'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 160));
    expect(scrollable.position.pixels, greaterThan(0.0));

    await tester.tap(find.byKey(const Key('slow_scroll_toggle_button')));
    await tester.pump();
    expect(find.text('Slow Scroll'), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('ArticleSlowScrollBar stays floating at bottom-right when scrolled down, retracts and extends on demand', (tester) async {
    final longParagraphs = List.generate(
      50,
      (i) => 'Section $i: Detailed exploration of artificial intelligence, neuroscience, and systems architecture.',
    ).join('\n\n');

    final item = EditorialNewsItem(
      id: 'scroll_float_test',
      badge: 'TECH',
      badgeColor: const Color(0xFF2196F3),
      title: 'Retractable Slow Scroll Floating Bar',
      updated: 'Just now',
      authorName: 'Dr. Alan Grant',
      authorRole: 'Research Lead',
      authorAvatar: '',
      excerpt: 'Retractable slow scroll bar test item',
      content: longParagraphs,
      color: const Color(0xFFFBF8F1),
      readingTimeMinutes: 10,
    );

    await tester.pumpWidget(MaterialApp(home: ArticleView(item: item)));
    await tester.pumpAndSettle();

    final barBottomBefore = tester.getBottomRight(find.byType(ArticleSlowScrollBar)).dy;
    final ScrollableState scrollable = tester.state(find.byType(Scrollable).first);
    scrollable.position.jumpTo(600.0);
    await tester.pump();

    expect(scrollable.position.pixels, greaterThan(500.0));
    expect(find.byType(ArticleSlowScrollBar), findsOneWidget);
    expect(find.byKey(const Key('slow_scroll_toggle_button')), findsOneWidget);
    expect(find.byKey(const Key('scroll_pace_1.0')), findsOneWidget);

    final barBottomAfter = tester.getBottomRight(find.byType(ArticleSlowScrollBar)).dy;
    expect(barBottomAfter, equals(barBottomBefore));

    await tester.tap(find.byKey(const Key('slow_scroll_retract_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('slow_scroll_toggle_button')), findsNothing);
    expect(find.byKey(const Key('scroll_pace_1.0')), findsNothing);
    expect(find.byKey(const Key('slow_scroll_retract_button')), findsOneWidget);
    expect(find.bySemanticsLabel('Extend slow scroll bar'), findsOneWidget);

    await tester.tap(find.byKey(const Key('slow_scroll_retract_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('slow_scroll_toggle_button')), findsOneWidget);
    expect(find.byKey(const Key('scroll_pace_1.0')), findsOneWidget);
    expect(find.bySemanticsLabel('Retract slow scroll bar'), findsOneWidget);

    await tester.tap(find.byKey(const Key('slow_scroll_toggle_button')));
    await tester.pump();
    expect(find.text('Scrolling'), findsOneWidget);

    await tester.tap(find.byKey(const Key('slow_scroll_toggle_button')));
    await tester.pump();
    expect(find.text('Slow Scroll'), findsOneWidget);
  });

  testWidgets('ArticleView renders empty view when item is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ArticleView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Article Not Found'), findsOneWidget);
    expect(find.text('No article content was provided.'), findsOneWidget);
    expect(find.text('Go Back'), findsOneWidget);
  });

  testWidgets('ArticleView renders unobtrusive placeholder when cover image is null', (tester) async {
    final item = EditorialNewsItem(
      id: 'test_2',
      badge: 'TECH',
      badgeColor: const Color(0xFF2196F3),
      title: 'Clean Minimalist Architecture',
      updated: 'Yesterday',
      authorName: 'Sam Rivera',
      authorRole: 'Software Architect',
      authorAvatar: '',
      excerpt: 'Clean architecture guide without cover image',
      color: const Color(0xFFFBF8F1),
      coverImageUrl: null,
      readingTimeMinutes: 3,
      starCount: 8,
      likesCount: 8,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ArticleView(item: item),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clean Minimalist Architecture'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.text('8'), findsOneWidget);
    expect(find.byIcon(AppIcons.thumbUpOutlined), findsOneWidget);
    expect(find.text('Rate this author (1–5★)'), findsOneWidget);
  });

  testWidgets('ArticleView falls back to excerpt when content is null or empty', (tester) async {
    final item = EditorialNewsItem(
      id: 'test_3',
      badge: 'CULTURE',
      badgeColor: const Color(0xFFFF9800),
      title: 'Preserving Ancient Oral Traditions',
      updated: '2 hours ago',
      authorName: 'Maya Lin',
      authorRole: 'Anthropologist',
      authorAvatar: '',
      excerpt: 'This excerpt will be rendered as the main body content.',
      content: null,
      color: const Color(0xFFFBF8F1),
      readingTimeMinutes: 4,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ArticleView(item: item),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('This excerpt will be rendered as the main body'), findsOneWidget);
  });
}
