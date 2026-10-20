import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/widgets/article_card.dart';

void main() {
  EditorialNewsItem buildItem({
    required String id,
    required String status,
    DateTime? publishedAt,
    String? authorId,
    bool isLocalDraft = false,
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
      authorId: authorId,
      isLocalDraft: isLocalDraft,
    );
  }

  Widget createArticleCardHarness(EditorialNewsItem item) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: ArticleCard(item: item)),
      ),
    );
  }

  Widget createEditableCardHarness(
    EditorialNewsItem item, {
    VoidCallback? onDelete,
    VoidCallback? onEdit,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: EditableProfileArticleCard(
            item: item,
            onDelete: onDelete,
            onEdit: onEdit,
          ),
        ),
      ),
    );
  }

  group('ArticleCard (strictly read-only)', () {
    testWidgets('ArticleCard exposes no edit or delete controls', (
      tester,
    ) async {
      final item = buildItem(
        id: 'article-1',
        status: 'published',
        authorId: 'author-alice',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      );

      await tester.pumpWidget(createArticleCardHarness(item));
      await tester.pumpAndSettle();

      expect(find.byIcon(AppIcons.edit), findsNothing);
      expect(find.byTooltip('Edit article'), findsNothing);
      expect(find.byIcon(AppIcons.delete), findsNothing);
      expect(find.byTooltip('Delete article'), findsNothing);
      expect(find.byIcon(AppIcons.iosShareRounded), findsOneWidget);
    });

    testWidgets(
      'ArticleCard remains read-only even for drafts and missing authors',
      (tester) async {
        final item = buildItem(
          id: 'article-draft-unowned',
          status: 'draft',
          authorId: null,
        );

        await tester.pumpWidget(createArticleCardHarness(item));
        await tester.pumpAndSettle();

        expect(find.text('DRAFT'), findsOneWidget);
        expect(find.byIcon(AppIcons.edit), findsNothing);
        expect(find.byTooltip('Edit article'), findsNothing);
        expect(find.byIcon(AppIcons.delete), findsNothing);
        expect(find.byTooltip('Delete article'), findsNothing);
        expect(find.byIcon(AppIcons.iosShareRounded), findsOneWidget);
      },
    );

    testWidgets('ArticleCard share button triggers snackbar on tap', (
      tester,
    ) async {
      final item = buildItem(
        id: 'article-share',
        status: 'published',
        authorId: 'author-alice',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      await tester.pumpWidget(createArticleCardHarness(item));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Share article'));
      await tester.pump();

      expect(find.text('Share link copied to clipboard'), findsOneWidget);
    });
  });

  group('EditableProfileArticleCard (owner management)', () {
    testWidgets(
      'within 30-day editing window exposes functional edit and delete buttons',
      (tester) async {
        bool editTapped = false;
        bool deleteTapped = false;

        final recentItem = buildItem(
          id: 'editable-recent-1',
          status: 'published',
          authorId: 'author-alice',
          publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        );

        await tester.pumpWidget(
          createEditableCardHarness(
            recentItem,
            onEdit: () => editTapped = true,
            onDelete: () => deleteTapped = true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Archived · locked'), findsNothing);
        expect(find.byIcon(AppIcons.edit), findsOneWidget);
        expect(find.byIcon(AppIcons.delete), findsOneWidget);
        expect(find.byIcon(AppIcons.iosShareRounded), findsOneWidget);

        await tester.tap(find.byTooltip('Edit article'));
        expect(editTapped, isTrue);

        await tester.tap(find.byTooltip('Delete article'));
        expect(deleteTapped, isTrue);
      },
    );

    testWidgets(
      'outside 30-day editing window shows locked indicator and no edit/delete',
      (tester) async {
        final expiredItem = buildItem(
          id: 'editable-expired-1',
          status: 'published',
          authorId: 'author-alice',
          publishedAt: DateTime.now().subtract(const Duration(days: 45)),
        );

        await tester.pumpWidget(createEditableCardHarness(expiredItem));
        await tester.pumpAndSettle();

        expect(find.text('Archived · locked'), findsOneWidget);
        expect(find.byIcon(AppIcons.lock), findsOneWidget);
        expect(find.byIcon(AppIcons.edit), findsNothing);
        expect(find.byIcon(AppIcons.delete), findsNothing);
        expect(find.byIcon(AppIcons.iosShareRounded), findsOneWidget);
      },
    );

    testWidgets(
      'backward-compatible typedefs ProfileArticleCard and CustomArticleCardOfProfile alias EditableProfileArticleCard',
      (tester) async {
        bool editTapped = false;
        final item = buildItem(
          id: 'alias-test-1',
          status: 'published',
          authorId: 'author-alice',
          publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ProfileArticleCard(
                  item: item,
                  onEdit: () => editTapped = true,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(EditableProfileArticleCard), findsOneWidget);
        expect(find.byIcon(AppIcons.edit), findsOneWidget);

        await tester.tap(find.byTooltip('Edit article'));
        expect(editTapped, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: CustomArticleCardOfProfile(item: item),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(EditableProfileArticleCard), findsOneWidget);
      },
    );
  });

  group('Draft Provenance & Model Hardening', () {
    test('ArticleEntityEditorialMapper sets isLocalDraft to false', () {
      final entity = ArticleEntity(
        id: 'remote-entity-1',
        title: 'Remote Article',
        excerpt: 'Remote excerpt',
        content: 'Remote content body',
        slug: 'remote-article',
        status: 'draft',
      );

      final newsItem = entity.toEditorialNewsItem();
      expect(newsItem.isLocalDraft, isFalse);
    });

    test(
      'DownloadedArticleEntityEditorialMapper sets isLocalDraft to false',
      () {
        final downloaded = DownloadedArticleEntity(
          id: 'downloaded-1',
          title: 'Downloaded Article',
          excerpt: 'Downloaded excerpt',
          content: 'Downloaded content body',
          authorName: 'Author',
          authorRole: 'Role',
          authorAvatar: '',
          categoryId: 'cat-1',
          categorySlug: 'tech',
          tags: const ['tech'],
          publishedAt: DateTime.now(),
          readingTimeMinutes: 3,
          downloadedAt: DateTime.now(),
        );

        final newsItem = downloaded.toEditorialNewsItem();
        expect(newsItem.isLocalDraft, isFalse);
      },
    );

    test(
      'EditorialNewsItem copyWith preserves or updates isLocalDraft accurately',
      () {
        final initial = buildItem(
          id: 'copy-1',
          status: 'draft',
          isLocalDraft: true,
        );
        expect(initial.isLocalDraft, isTrue);

        final copiedFalse = initial.copyWith(isLocalDraft: false);
        expect(copiedFalse.isLocalDraft, isFalse);

        final copiedPreserved = copiedFalse.copyWith(content: 'New Content');
        expect(copiedPreserved.isLocalDraft, isFalse);
      },
    );
  });
}
