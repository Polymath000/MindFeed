import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_markdown_body.dart';

void main() {
  Widget buildTestWidget({
    String? content,
    required String excerpt,
    required String title,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MaterialApp(
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: ArticleReaderMarkdownBody(
            content: content,
            excerpt: excerpt,
            title: title,
          ),
        ),
      ),
    );
  }

  testWidgets('renders content and excerpt header when both are present', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        content: 'This is the body content of the article.',
        excerpt: 'Summary excerpt of the article.',
        title: 'Article Title',
      ),
    );

    expect(find.text('Summary excerpt of the article.'), findsOneWidget);
    expect(
      find.text('This is the body content of the article.'),
      findsOneWidget,
    );
  });

  testWidgets('falls back to excerpt when content is null', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        content: null,
        excerpt: 'Fallback excerpt text',
        title: 'Article Title',
      ),
    );

    expect(find.text('Fallback excerpt text'), findsOneWidget);
  });

  testWidgets('falls back to excerpt when content is whitespace only', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        content: '   \n  ',
        excerpt: 'Fallback excerpt for empty content',
        title: 'Article Title',
      ),
    );

    expect(find.text('Fallback excerpt for empty content'), findsOneWidget);
  });

  testWidgets('falls back to title when content and excerpt are empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        content: '',
        excerpt: '',
        title: 'Fallback Article Title',
      ),
    );

    expect(find.text('Fallback Article Title'), findsOneWidget);
  });

  testWidgets('renders markdown headings H1, H2, and H3', (tester) async {
    const markdown = '''
# Heading Level 1
## Heading Level 2
### Heading Level 3
''';

    await tester.pumpWidget(
      buildTestWidget(content: markdown, excerpt: '', title: 'Headings Test'),
    );

    expect(find.text('Heading Level 1'), findsOneWidget);
    expect(find.text('Heading Level 2'), findsOneWidget);
    expect(find.text('Heading Level 3'), findsOneWidget);
  });

  testWidgets('renders lists, bold, and italic formatted markdown', (
    tester,
  ) async {
    const markdown = '''
- **Bold Item 1**
- *Italic Item 2*
- Standard Item 3
''';

    await tester.pumpWidget(
      buildTestWidget(
        content: markdown,
        excerpt: '',
        title: 'List Formatting Test',
      ),
    );

    expect(find.byType(ArticleReaderMarkdownBody), findsOneWidget);
  });

  testWidgets('renders blockquotes and inline code', (tester) async {
    const markdown = '''
> This is a notable quote from the author.

Here is some `inline code` for developers.
''';

    await tester.pumpWidget(
      buildTestWidget(
        content: markdown,
        excerpt: '',
        title: 'Quote and Code Test',
      ),
    );

    expect(find.byType(ArticleReaderMarkdownBody), findsOneWidget);
    expect(find.textContaining('This is a notable quote'), findsOneWidget);
  });

  testWidgets('renders fenced code blocks and markdown tables', (tester) async {
    const markdown = '''
```dart
final int number = 42;
```

| Header A | Header B |
| --- | --- |
| Cell 1 | Cell 2 |
''';

    await tester.pumpWidget(
      buildTestWidget(
        content: markdown,
        excerpt: '',
        title: 'Table and Codeblock Test',
      ),
    );

    expect(find.byType(ArticleReaderMarkdownBody), findsOneWidget);
    expect(find.byType(Table), findsOneWidget);
    expect(find.text('Header A'), findsOneWidget);
    expect(find.text('Cell 1'), findsOneWidget);
    expect(find.textContaining('final int number = 42;'), findsOneWidget);
  });

  testWidgets('renders links with link text in widget tree', (tester) async {
    const markdown =
        'Visit [MindFeed Official](https://example.com) for updates.';

    await tester.pumpWidget(
      buildTestWidget(content: markdown, excerpt: '', title: 'Link Test'),
    );

    expect(find.byType(ArticleReaderMarkdownBody), findsOneWidget);
    expect(find.textContaining('MindFeed Official'), findsOneWidget);
  });

  testWidgets('renders markdown images to expected Image widget', (
    tester,
  ) async {
    const markdown =
        '![Alt Description](resource:assets/images/MindFeedLogo.png)';

    await tester.pumpWidget(
      buildTestWidget(content: markdown, excerpt: '', title: 'Image Test'),
    );

    expect(find.byType(ArticleReaderMarkdownBody), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('renders correctly under dark theme mode', (tester) async {
    const markdown = '# Dark Theme Heading\n\nContent rendered in dark mode.';

    await tester.pumpWidget(
      buildTestWidget(
        content: markdown,
        excerpt: 'Dark mode excerpt',
        title: 'Dark Theme Test',
        themeMode: ThemeMode.dark,
      ),
    );

    expect(find.text('Dark mode excerpt'), findsOneWidget);
    expect(find.text('Dark Theme Heading'), findsOneWidget);
  });
}
