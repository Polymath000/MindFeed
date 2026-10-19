import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/add_article/presentation/views/article_preview_view.dart';

void main() {
  testWidgets('renders fallback empty state when item is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ArticlePreviewView(item: null)),
    );

    expect(find.text('No article data to preview'), findsOneWidget);
  });

  testWidgets('renders article preview with markdown content', (tester) async {
    final item = EditorialNewsItem(
      id: 'preview-1',
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
    );

    await tester.pumpWidget(MaterialApp(home: ArticlePreviewView(item: item)));

    expect(find.byType(ArticlePreviewView), findsOneWidget);
    expect(find.text('Previewing Next Generation AI'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Main Header'), findsOneWidget);
  });
}
