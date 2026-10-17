import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/home/presentation/views/article_view.dart';

void main() {
  testWidgets(
      'ArticleView renders provided content markdown and star count without Supabase',
      (tester) async {
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
      starCount: 42,
      isStarred: true,
      tags: const ['Biology', 'AI'],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ArticleView(item: item),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Neural Networks Mapping Cellular Behavior'),
        findsOneWidget);
    expect(find.text('SCIENCE'), findsOneWidget);
    expect(find.text('7 min read'), findsOneWidget);
    expect(find.text('Dr. Elena Rostova'), findsOneWidget);
    expect(find.text('Chief Biologist'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.text('#Biology'), findsOneWidget);
    expect(find.text('#AI'), findsOneWidget);
    expect(find.textContaining('Revolutionary Discovery'), findsOneWidget);
    expect(
        find.textContaining('Biologists have successfully mapped cellular'),
        findsOneWidget);
    expect(find.bySemanticsLabel('Star article'), findsOneWidget);
    expect(find.bySemanticsLabel('Save article'), findsOneWidget);
    expect(find.bySemanticsLabel('Download article'), findsOneWidget);
    expect(find.bySemanticsLabel('Share article'), findsOneWidget);
  });

  testWidgets('ArticleView renders empty view when item is null',
      (tester) async {
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

  testWidgets(
      'ArticleView renders unobtrusive placeholder when cover image is null',
      (tester) async {
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
    expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);
  });

  testWidgets(
      'ArticleView falls back to excerpt when content is null or empty',
      (tester) async {
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

    expect(find.textContaining('This excerpt will be rendered as the main body'),
        findsOneWidget);
  });
}
