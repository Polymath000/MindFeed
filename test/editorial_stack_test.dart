import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/design/editorial_card_stack.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/design/editorial_saved_stack.dart';

Widget harness(Widget child) =>
    MaterialApp(theme: ThemeData.dark(), home: Scaffold(body: child));

void main() {
  final testItems = [
    EditorialNewsItem(
      id: 'test_1',
      badge: 'LIVE',
      badgeColor: Colors.red,
      title: 'First Test Story',
      updated: 'Just now',
      authorName: 'Author 1',
      authorRole: 'Published by',
      authorAvatar: 'assets/images/wade_avatar.png',
      excerpt: 'First story excerpt content',
      color: Colors.amber,
    ),
    EditorialNewsItem(
      id: 'test_2',
      badge: 'TECH',
      badgeColor: Colors.blue,
      title: 'Second Test Story',
      updated: '1 hour ago',
      authorName: 'Author 2',
      authorRole: 'Published by',
      authorAvatar: 'assets/images/wade_avatar.png',
      excerpt: 'Second story excerpt content',
      color: Colors.cyan,
    ),
  ];

  testWidgets('EditorialCardStack opens top article on swipe up', (tester) async {
    EditorialNewsItem? openedItem;

    await tester.pumpWidget(
      harness(
        EditorialCardStack(
          items: testItems,
          onOpenArticle: (item) => openedItem = item,
        ),
      ),
    );

    expect(find.text('First Test Story'), findsOneWidget);

    await tester.drag(find.text('First Test Story'), const Offset(0, -120));
    await tester.pump(const Duration(milliseconds: 300));

    expect(openedItem?.id, equals('test_1'));
  });

  testWidgets('EditorialCardStack dismisses and cycles to next card on swipe right', (tester) async {
    EditorialNewsItem? dismissedItem;

    await tester.pumpWidget(
      harness(
        EditorialCardStack(
          items: testItems,
          onOpenArticle: (_) {},
          onDismiss: (item) => dismissedItem = item,
        ),
      ),
    );

    expect(find.text('First Test Story'), findsOneWidget);

    await tester.drag(find.text('First Test Story'), const Offset(200, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(dismissedItem?.id, equals('test_1'));
  });

  testWidgets('EditorialSavedStack dismisses an item on swipe', (tester) async {
    EditorialNewsItem? deletedItem;
    final items = List<EditorialNewsItem>.from(testItems);

    await tester.pumpWidget(
      harness(
        EditorialSavedStack(
          items: items,
          onOpenArticle: (_) {},
          onDeleteArticle: (item) => deletedItem = item,
        ),
      ),
    );

    expect(find.text('First Test Story'), findsOneWidget);
    expect(find.text('Second Test Story'), findsOneWidget);

    await tester.drag(find.text('First Test Story'), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(deletedItem?.id, equals('test_1'));
  });
}
