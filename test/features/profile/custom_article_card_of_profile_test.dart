import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/widgets/article_card.dart';

void main() {
  EditorialNewsItem buildItem({
    required String id,
    required String status,
    DateTime? publishedAt,
  }) {
    return EditorialNewsItem(
      id: id,
      badge: 'TECH',
      badgeColor: const Color(0xFF1E88E5),
      title: 'Quantum Computing Frontiers\nPart 1',
      updated: 'Recently',
      authorName: 'Ada Lovelace',
      authorRole: 'Author',
      authorAvatar: '',
      excerpt: 'Exploring qubits and entanglement in modern systems.',
      color: const Color(0xFFFBF8F2),
      status: status,
      publishedAt: publishedAt,
    );
  }

  Widget createWidgetUnderTest(EditorialNewsItem item, {VoidCallback? onDelete, VoidCallback? onEdit}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: CustomArticleCardOfProfile(
            item: item,
            onDelete: onDelete,
            onEdit: onEdit,
          ),
        ),
      ),
    );
  }

  testWidgets('article published 45 days ago shows locked indicator and no Edit/Delete', (tester) async {
    final archivedItem = buildItem(
      id: 'archived-1',
      status: 'published',
      publishedAt: DateTime.now().subtract(const Duration(days: 45)),
    );

    await tester.pumpWidget(createWidgetUnderTest(archivedItem));
    await tester.pumpAndSettle();

    expect(find.text('Archived · locked'), findsOneWidget);
    expect(find.byIcon(AppIcons.lock), findsOneWidget);

    expect(find.byIcon(AppIcons.edit), findsNothing);
    expect(find.byTooltip('Edit article'), findsNothing);
    expect(find.byIcon(AppIcons.delete), findsNothing);
    expect(find.byTooltip('Delete article'), findsNothing);

    expect(find.text('PUBLISHED'), findsOneWidget);
    expect(find.text('TECH'), findsOneWidget);
  });

  testWidgets('article published 5 days ago shows Edit/Delete and no locked indicator', (tester) async {
    bool deleteCalled = false;
    bool editCalled = false;

    final recentItem = buildItem(
      id: 'recent-1',
      status: 'published',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
    );

    await tester.pumpWidget(
      createWidgetUnderTest(
        recentItem,
        onDelete: () => deleteCalled = true,
        onEdit: () => editCalled = true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Archived · locked'), findsNothing);
    expect(find.byIcon(AppIcons.lock), findsNothing);

    expect(find.byIcon(AppIcons.edit), findsOneWidget);
    expect(find.byTooltip('Edit article'), findsOneWidget);
    expect(find.byIcon(AppIcons.delete), findsOneWidget);
    expect(find.byTooltip('Delete article'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit article'));
    expect(editCalled, isTrue);

    await tester.tap(find.byTooltip('Delete article'));
    expect(deleteCalled, isTrue);

    expect(find.text('PUBLISHED'), findsOneWidget);
  });

  testWidgets('draft article shows Edit/Delete and DRAFT status badge', (tester) async {
    final draftItem = buildItem(
      id: 'draft-1',
      status: 'draft',
      publishedAt: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(draftItem));
    await tester.pumpAndSettle();

    expect(find.text('Archived · locked'), findsNothing);
    expect(find.byIcon(AppIcons.edit), findsOneWidget);
    expect(find.byIcon(AppIcons.delete), findsOneWidget);
    expect(find.text('DRAFT'), findsOneWidget);
  });
}
