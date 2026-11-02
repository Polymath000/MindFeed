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
      authorAvatar: '',
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
      authorAvatar: '',
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
        authorAvatar: '',
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
        authorAvatar: '',
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
        authorAvatar: '',
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
        authorAvatar: '',
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

  testWidgets(
    'EditorialCardStack preserves rotated deck position when parent rebuilds on swipe-right save',
    (tester) async {
      var parentItems = [
        EditorialNewsItem(
          id: 'deck_1',
          badge: 'LIVE',
          badgeColor: Colors.red,
          title: 'Deck Card One',
          updated: 'Just now',
          authorName: 'Author 1',
          authorRole: 'Writer',
          authorAvatar: '',
          excerpt: 'Excerpt 1',
          color: Colors.amber,
        ),
        EditorialNewsItem(
          id: 'deck_2',
          badge: 'TECH',
          badgeColor: Colors.blue,
          title: 'Deck Card Two',
          updated: '10m ago',
          authorName: 'Author 2',
          authorRole: 'Writer',
          authorAvatar: '',
          excerpt: 'Excerpt 2',
          color: Colors.cyan,
        ),
        EditorialNewsItem(
          id: 'deck_3',
          badge: 'SCIENCE',
          badgeColor: Colors.green,
          title: 'Deck Card Three',
          updated: '20m ago',
          authorName: 'Author 3',
          authorRole: 'Writer',
          authorAvatar: '',
          excerpt: 'Excerpt 3',
          color: Colors.orange,
        ),
      ];
      EditorialNewsItem? openedTopCard;

      await tester.pumpWidget(
        harness(
          StatefulBuilder(
            builder: (context, setParentState) {
              return EditorialCardStack(
                items: List<EditorialNewsItem>.of(parentItems),
                onOpenArticle: (item) => openedTopCard = item,
                onSwipeRight: (savedItem) {
                  setParentState(() {
                    parentItems = parentItems
                        .map(
                          (item) => item.id == savedItem.id
                              ? item.copyWith(isSaved: true)
                              : item,
                        )
                        .toList();
                  });
                },
              );
            },
          ),
        ),
      );

      // 1. Swipe left past Card One -> Card Two becomes top card
      await tester.drag(find.text('Deck Card One'), const Offset(-200, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // 2. Swipe right on Card Two to save it (triggers parent rebuild with new list)
      await tester.drag(find.text('Deck Card Two'), const Offset(200, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // 3. Top card must now be Card Three (NOT reset back to Card One!)
      await tester.drag(find.text('Deck Card Three'), const Offset(0, -120));
      await tester.pump(const Duration(milliseconds: 300));

      expect(openedTopCard?.id, equals('deck_3'));
    },
  );

  testWidgets(
    'EditorialCardStack preserves rotated deck position and passes unmutated item on Save button tap',
    (tester) async {
      var parentItems = [
        EditorialNewsItem(
          id: 'btn_1',
          badge: 'LIVE',
          badgeColor: Colors.red,
          title: 'Button Card One',
          updated: 'Just now',
          authorName: 'Author 1',
          authorRole: 'Writer',
          authorAvatar: '',
          excerpt: 'Excerpt 1',
          color: Colors.amber,
        ),
        EditorialNewsItem(
          id: 'btn_2',
          badge: 'TECH',
          badgeColor: Colors.blue,
          title: 'Button Card Two',
          updated: '10m ago',
          authorName: 'Author 2',
          authorRole: 'Writer',
          authorAvatar: '',
          excerpt: 'Excerpt 2',
          color: Colors.cyan,
        ),
        EditorialNewsItem(
          id: 'btn_3',
          badge: 'SCIENCE',
          badgeColor: Colors.green,
          title: 'Button Card Three',
          updated: '20m ago',
          authorName: 'Author 3',
          authorRole: 'Writer',
          authorAvatar: '',
          excerpt: 'Excerpt 3',
          color: Colors.orange,
        ),
      ];
      bool? wasSavedBeforeCallback;
      EditorialNewsItem? openedTopCard;

      await tester.pumpWidget(
        harness(
          StatefulBuilder(
            builder: (context, setParentState) {
              return EditorialCardStack(
                items: List<EditorialNewsItem>.of(parentItems),
                onOpenArticle: (item) => openedTopCard = item,
                onToggleSave: (item) {
                  wasSavedBeforeCallback = item.isSaved;
                  final nextSaved = !item.isSaved;
                  item.isSaved = nextSaved;
                  setParentState(() {
                    parentItems = parentItems
                        .map(
                          (a) => a.id == item.id
                              ? a.copyWith(isSaved: nextSaved)
                              : a,
                        )
                        .toList();
                  });
                },
              );
            },
          ),
        ),
      );

      // 1. Swipe left past Card One -> Card Two becomes top card
      await tester.drag(find.text('Button Card One'), const Offset(-200, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // 2. Tap Bookmark button on Card Two
      await tester.tap(find.bySemanticsLabel('Save article'));
      await tester.pump();

      expect(wasSavedBeforeCallback, isFalse);

      // 3. Swipe up to open current top card -> must still be Card Two (now saved), NOT Card One!
      await tester.drag(find.text('Button Card Two'), const Offset(0, -120));
      await tester.pump(const Duration(milliseconds: 300));

      expect(openedTopCard?.id, equals('btn_2'));
      expect(openedTopCard?.isSaved, isTrue);
    },
  );

  testWidgets(
    'EditorialSavedStack allows vertical scrolling directly over cards without accidentally opening an article',
    (tester) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      EditorialNewsItem? openedItem;

      final savedItems = List.generate(
        10,
        (index) => EditorialNewsItem(
          id: 'saved_$index',
          badge: 'SAVED',
          badgeColor: Colors.red,
          title: 'Saved Story $index',
          updated: 'Today',
          authorName: 'Author $index',
          authorRole: 'Writer',
          authorAvatar: '',
          excerpt: 'Saved article excerpt line for item $index to ensure scrollable height.',
          color: Colors.amber,
        ),
      );

      await tester.pumpWidget(
        harness(
          ListView(
            controller: scrollController,
            children: [
              EditorialSavedStack(
                items: savedItems,
                onOpenArticle: (item) => openedItem = item,
              ),
            ],
          ),
        ),
      );

      expect(scrollController.offset, equals(0));

      // Fast upward fling directly in the middle of a saved article card
      await tester.fling(
        find.text('Saved Story 1'),
        const Offset(0, -280),
        1200,
      );
      await tester.pumpAndSettle();

      expect(scrollController.offset, greaterThan(0));
      expect(openedItem, isNull);

      // Explicit tap on a visible card still opens that article
      await tester.tap(find.text('Saved Story 5'));
      await tester.pump();

      expect(openedItem?.id, equals('saved_5'));
    },
  );
}
