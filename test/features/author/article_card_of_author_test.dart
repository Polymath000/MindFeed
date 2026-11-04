import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/author/presentation/widgets/article_card_of_author.dart';

void main() {
  final sampleItem = EditorialNewsItem(
    id: 'test-article-1',
    badge: 'TECH',
    badgeColor: const Color(0xFF1E88E5),
    title: 'Quantum Computing Breakthrough',
    updated: '2h ago',
    authorName: 'Ada Lovelace',
    authorRole: 'Pioneer',
    authorAvatar: 'https://example.com/avatar.png',
    excerpt: 'A quantum jump into computing history.',
    color: const Color(0xFFF5F5F5),
    readingTimeMinutes: 4,
    tags: const ['quantum', 'hardware', 'deeptech'],
    status: 'published',
  );

  testWidgets(
      'renders badge, title, excerpt, reading time, tags, and has zero published/edit/delete widgets',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleCardOfAuthor(item: sampleItem),
        ),
      ),
    );

    expect(find.text('TECH'), findsOneWidget);
    final badgeContainer = tester.widget<Container>(
      find
          .ancestor(
            of: find.text('TECH'),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((badgeContainer.decoration as BoxDecoration).color, AppColors.black);
    expect(tester.widget<Text>(find.text('TECH')).style?.color, AppColors.white);
    expect(find.text('Quantum Computing Breakthrough'), findsOneWidget);
    expect(find.text('A quantum jump into computing history.'), findsOneWidget);
    expect(find.text('4 min read'), findsOneWidget);
    expect(find.text('2h ago'), findsOneWidget);
    expect(find.text('#quantum'), findsOneWidget);
    expect(find.text('#hardware'), findsOneWidget);
    expect(find.text('#deeptech'), findsOneWidget);
    expect(find.text('Read →'), findsOneWidget);

    expect(find.text('PUBLISHED'), findsNothing);
    expect(find.text('Archived · locked'), findsNothing);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Delete'), findsNothing);
    expect(find.byIcon(Icons.edit), findsNothing);
    expect(find.byIcon(Icons.delete), findsNothing);
  });

  testWidgets('triggers onTap callback when provided', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleCardOfAuthor(
            item: sampleItem,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ArticleCardOfAuthor));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('navigates to AppRoutes.article when tapped without custom onTap',
      (tester) async {
    dynamic pushedArguments;
    String? pushedRoute;

    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.article) {
            pushedRoute = settings.name;
            pushedArguments = settings.arguments;
            return MaterialPageRoute(
              builder: (_) =>
                  const Scaffold(body: Text('Article Reader Screen')),
            );
          }
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: ArticleCardOfAuthor(item: sampleItem),
            ),
          );
        },
      ),
    );

    await tester.tap(find.byType(ArticleCardOfAuthor));
    await tester.pumpAndSettle();

    expect(pushedRoute, equals(AppRoutes.article));
    expect(pushedArguments, equals(sampleItem));
    expect(find.text('Article Reader Screen'), findsOneWidget);
  });
}
