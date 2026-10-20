import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/add_article/presentation/routes/add_article_routes.dart';
import 'package:mind_feed/features/add_article/presentation/views/article_preview_view.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_preview_bottom_bar.dart';

void main() {
  final draftItem = EditorialNewsItem(
    id: 'draft-prev-1',
    badge: 'TECH',
    badgeColor: AppColors.ink,
    title: 'Previewing Next Generation AI',
    updated: 'Just now',
    authorName: 'Ada Lovelace',
    authorRole: 'Chief Pioneer',
    authorAvatar: '',
    excerpt: 'Brief teaser excerpt.',
    color: AppColors.cream,
    content: '''
# Main Header

This is a **preview** paragraph describing the article.

- Feature Alpha
- Feature Beta

```dart
void main() => runApp(const MyApp());
```
''',
    status: 'draft',
  );

  final publishedItem = EditorialNewsItem(
    id: 'published-prev-2',
    badge: 'DESIGN',
    badgeColor: AppColors.ink,
    title: 'Published Story Title',
    updated: 'Yesterday',
    authorName: 'Charles Babbage',
    authorRole: 'Editor',
    authorAvatar: '',
    excerpt: 'Published article excerpt.',
    color: AppColors.cream,
    content: 'Full published text here.',
    status: 'published',
  );

  Widget buildPreviewHarness({
    required EditorialNewsItem? item,
    void Function(Object? arg)? onEditorNavigated,
  }) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ArticlePreviewView(item: item),
        AddArticleRoutes.addArticle: (context) {
          final arg = ModalRoute.of(context)?.settings.arguments;
          onEditorNavigated?.call(arg);
          return const Scaffold(body: Text('Add Article Target'));
        },
      },
    );
  }

  testWidgets('renders fallback empty state when item is null', (tester) async {
    await tester.pumpWidget(buildPreviewHarness(item: null));

    expect(find.text('No article data to preview'), findsOneWidget);
    expect(find.byKey(const Key('preview_empty_back_button')), findsOneWidget);
  });

  testWidgets('renders article preview with markdown content', (tester) async {
    await tester.pumpWidget(buildPreviewHarness(item: draftItem));

    expect(find.byType(ArticlePreviewView), findsOneWidget);
    expect(find.text('Previewing Next Generation AI'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Main Header'), findsOneWidget);
  });

  testWidgets('draft item displays draft preview bar and actions', (
    tester,
  ) async {
    await tester.pumpWidget(buildPreviewHarness(item: draftItem));

    expect(find.text('Draft Preview'), findsOneWidget);
    expect(
      find.byKey(const Key('preview_app_bar_publish_button')),
      findsOneWidget,
    );
    expect(find.byType(ArticlePreviewBottomBar), findsOneWidget);
    expect(find.byKey(const Key('preview_bottom_edit_button')), findsOneWidget);
    expect(
      find.byKey(const Key('preview_bottom_publish_button')),
      findsOneWidget,
    );
  });

  testWidgets('tapping app bar publish button routes to editor with draft', (
    tester,
  ) async {
    Object? capturedArg;
    await tester.pumpWidget(
      buildPreviewHarness(
        item: draftItem,
        onEditorNavigated: (arg) => capturedArg = arg,
      ),
    );

    await tester.tap(find.byKey(const Key('preview_app_bar_publish_button')));
    await tester.pumpAndSettle();

    expect(find.text('Add Article Target'), findsOneWidget);
    expect(capturedArg, draftItem);
  });

  testWidgets('tapping bottom bar publish button routes to editor with draft', (
    tester,
  ) async {
    Object? capturedArg;
    await tester.pumpWidget(
      buildPreviewHarness(
        item: draftItem,
        onEditorNavigated: (arg) => capturedArg = arg,
      ),
    );

    await tester.tap(find.byKey(const Key('preview_bottom_publish_button')));
    await tester.pumpAndSettle();

    expect(find.text('Add Article Target'), findsOneWidget);
    expect(capturedArg, draftItem);
  });

  testWidgets('tapping bottom bar edit button routes to editor with draft', (
    tester,
  ) async {
    Object? capturedArg;
    await tester.pumpWidget(
      buildPreviewHarness(
        item: draftItem,
        onEditorNavigated: (arg) => capturedArg = arg,
      ),
    );

    await tester.tap(find.byKey(const Key('preview_bottom_edit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Add Article Target'), findsOneWidget);
    expect(capturedArg, draftItem);
  });

  testWidgets(
    'published item displays Story Preview without draft publish controls',
    (tester) async {
      await tester.pumpWidget(buildPreviewHarness(item: publishedItem));

      expect(find.text('Story Preview'), findsOneWidget);
      expect(
        find.byKey(const Key('preview_app_bar_publish_button')),
        findsNothing,
      );
      expect(find.byType(ArticlePreviewBottomBar), findsNothing);
    },
  );
}
