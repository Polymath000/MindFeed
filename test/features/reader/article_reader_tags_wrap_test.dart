import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_tags_wrap.dart';

void main() {
  testWidgets('renders tags formatted with hash prefix', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArticleReaderTagsWrap(
            tags: ['design', 'tech'],
          ),
        ),
      ),
    );

    expect(find.text('#design'), findsOneWidget);
    expect(find.text('#tech'), findsOneWidget);
  });

  testWidgets('tapping tag invokes onTagTap with correct tag name', (tester) async {
    String? tappedTag;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleReaderTagsWrap(
            tags: ['architecture', 'mobile'],
            onTagTap: (tag) => tappedTag = tag,
          ),
        ),
      ),
    );

    await tester.tap(find.text('#architecture'));
    await tester.pumpAndSettle();

    expect(tappedTag, equals('architecture'));

    await tester.tap(find.text('#mobile'));
    await tester.pumpAndSettle();

    expect(tappedTag, equals('mobile'));
  });

  testWidgets('renders empty shrink widget when tags list is empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArticleReaderTagsWrap(tags: []),
        ),
      ),
    );

    expect(find.byType(Wrap), findsNothing);
  });
}
