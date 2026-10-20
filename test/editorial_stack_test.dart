import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/design/editorial_card_stack.dart';
import 'package:mind_feed/core/design/editorial_deck_synchronizer.dart';
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

  testWidgets('EditorialCardStack swipe right marks item saved and fires onSwipeRight', (tester) async {
    EditorialNewsItem? swipedRightItem;
    final items = [
      EditorialNewsItem(
        id: 'right_1',
        badge: 'LIVE',
        badgeColor: Colors.red,
        title: 'Swipe Right Story',
        updated: 'Just now',
        authorName: 'Author',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt',
        color: Colors.amber,
        isSaved: false,
      ),
      EditorialNewsItem(
        id: 'right_2',
        badge: 'TECH',
        badgeColor: Colors.blue,
        title: 'Behind Story',
        updated: '1 hour ago',
        authorName: 'Author 2',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt 2',
        color: Colors.cyan,
      ),
    ];

    await tester.pumpWidget(
      harness(
        EditorialCardStack(
          items: items,
          onOpenArticle: (_) {},
          onSwipeRight: (item) => swipedRightItem = item,
        ),
      ),
    );

    expect(find.text('Swipe Right Story'), findsOneWidget);

    await tester.drag(find.text('Swipe Right Story'), const Offset(200, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(swipedRightItem?.id, equals('right_1'));
    expect(swipedRightItem?.isSaved, isTrue);
    expect(find.text('Behind Story'), findsOneWidget);
  });

  testWidgets('EditorialCardStack tapping save button dismisses top card and reveals behind card', (tester) async {
    EditorialNewsItem? savedItem;
    final items = [
      EditorialNewsItem(
        id: 'save_1',
        badge: 'LIVE',
        badgeColor: Colors.red,
        title: 'Story To Save',
        updated: 'Just now',
        authorName: 'Author 1',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt 1',
        color: Colors.amber,
      ),
      EditorialNewsItem(
        id: 'save_2',
        badge: 'TECH',
        badgeColor: Colors.blue,
        title: 'Next Story Behind',
        updated: '1 hour ago',
        authorName: 'Author 2',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt 2',
        color: Colors.cyan,
      ),
    ];

    await tester.pumpWidget(
      harness(
        EditorialCardStack(
          items: items,
          onOpenArticle: (_) {},
          onSwipeRight: (item) => savedItem = item,
        ),
      ),
    );

    expect(find.text('Story To Save'), findsOneWidget);

    await tester.tap(find.byTooltip('Save article'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(savedItem?.id, equals('save_1'));
    expect(savedItem?.isSaved, isTrue);
    expect(find.text('Next Story Behind'), findsOneWidget);
  });

  testWidgets('EditorialCardStack preserves active top card when widget items re-emit from cubit', (tester) async {
    EditorialNewsItem? swipedItem;
    final initialItems = [
      EditorialNewsItem(
        id: 'item_a',
        badge: 'LIVE',
        badgeColor: Colors.red,
        title: 'Article A',
        updated: 'Just now',
        authorName: 'Author A',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt A',
        color: Colors.amber,
        isSaved: false,
      ),
      EditorialNewsItem(
        id: 'item_b',
        badge: 'TECH',
        badgeColor: Colors.blue,
        title: 'Article B',
        updated: '1 hour ago',
        authorName: 'Author B',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt B',
        color: Colors.cyan,
      ),
      EditorialNewsItem(
        id: 'item_c',
        badge: 'DESIGN',
        badgeColor: Colors.green,
        title: 'Article C',
        updated: '2 hours ago',
        authorName: 'Author C',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt C',
        color: Colors.purple,
      ),
    ];

    await tester.pumpWidget(
      harness(
        EditorialCardStack(
          items: initialItems,
          onOpenArticle: (_) {},
          onSwipeRight: (item) => swipedItem = item,
        ),
      ),
    );

    expect(find.text('Article A'), findsOneWidget);

    await tester.drag(find.text('Article A'), const Offset(200, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(swipedItem?.id, equals('item_a'));
    expect(find.text('Article B'), findsOneWidget);

    final updatedItemsFromCubit = [
      initialItems[0].copyWith(isSaved: true),
      initialItems[1],
      initialItems[2],
    ];

    await tester.pumpWidget(
      harness(
        EditorialCardStack(
          items: updatedItemsFromCubit,
          onOpenArticle: (_) {},
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Article B'), findsOneWidget);
  });

  testWidgets('EditorialCardStack swipe left moves to card behind without saving and fires onSwipeLeft', (tester) async {
    EditorialNewsItem? swipedLeftItem;
    final items = [
      EditorialNewsItem(
        id: 'left_1',
        badge: 'LIVE',
        badgeColor: Colors.red,
        title: 'Swipe Left Story',
        updated: 'Just now',
        authorName: 'Author',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt',
        color: Colors.amber,
        isSaved: false,
      ),
      EditorialNewsItem(
        id: 'left_2',
        badge: 'TECH',
        badgeColor: Colors.blue,
        title: 'Behind Left Story',
        updated: '1 hour ago',
        authorName: 'Author 2',
        authorRole: 'Writer',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt 2',
        color: Colors.cyan,
      ),
    ];

    await tester.pumpWidget(
      harness(
        EditorialCardStack(
          items: items,
          onOpenArticle: (_) {},
          onSwipeLeft: (item) => swipedLeftItem = item,
        ),
      ),
    );

    expect(find.text('Swipe Left Story'), findsOneWidget);

    await tester.drag(find.text('Swipe Left Story'), const Offset(-200, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(swipedLeftItem?.id, equals('left_1'));
    expect(swipedLeftItem?.isSaved, isFalse);
    expect(find.text('Behind Left Story'), findsOneWidget);
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

  group('EditorialDeckSynchronizer', () {
    test('preserves carousel order while updating article state attributes', () {
      final itemA = testItems[0];
      final itemB = testItems[1];
      final currentDeck = [itemB, itemA];
      final incoming = [
        itemA.copyWith(isSaved: true, likesCount: 42),
        itemB.copyWith(isLiked: true),
      ];

      final synced = EditorialDeckSynchronizer.sync(
        currentDeck: currentDeck,
        incomingItems: incoming,
      );

      expect(synced.length, equals(2));
      expect(synced[0].id, equals('test_2'));
      expect(synced[0].isLiked, isTrue);
      expect(synced[1].id, equals('test_1'));
      expect(synced[1].isSaved, isTrue);
      expect(synced[1].likesCount, equals(42));
    });

    test('appends new incoming items and prunes removed items', () {
      final itemA = testItems[0];
      final itemB = testItems[1];
      final itemC = EditorialNewsItem(
        id: 'test_3',
        badge: 'NEW',
        badgeColor: Colors.orange,
        title: 'Third Story',
        updated: 'now',
        authorName: 'Author 3',
        authorRole: 'Role',
        authorAvatar: 'assets/images/wade_avatar.png',
        excerpt: 'Excerpt 3',
        color: Colors.teal,
      );

      final currentDeck = [itemB, itemA];
      final incoming = [itemB, itemC];

      final synced = EditorialDeckSynchronizer.sync(
        currentDeck: currentDeck,
        incomingItems: incoming,
      );

      expect(synced.map((i) => i.id).toList(), equals(['test_2', 'test_3']));
    });

    test('falls back cleanly to incoming items when current deck is empty or non-overlapping', () {
      final incoming = [testItems[0]];
      final synced = EditorialDeckSynchronizer.sync(
        currentDeck: const [],
        incomingItems: incoming,
      );

      expect(synced.map((i) => i.id).toList(), equals(['test_1']));
    });
  });
}
