import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_author_bar.dart';

void main() {
  testWidgets('renders author name and role properly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArticleReaderAuthorBar(
            authorName: 'Ada Lovelace',
            authorRole: 'Chief Pioneer',
            authorAvatar: '',
          ),
        ),
      ),
    );

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Chief Pioneer'), findsOneWidget);
  });

  testWidgets('tapping author identity triggers onAuthorTap callback', (tester) async {
    bool authorTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleReaderAuthorBar(
            authorName: 'Alan Turing',
            authorRole: 'Lead Cryptanalyst',
            authorAvatar: '',
            onAuthorTap: () => authorTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Alan Turing'));
    await tester.pumpAndSettle();

    expect(authorTapped, isTrue);
  });
}
