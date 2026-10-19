import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_author_section.dart';
import 'package:mind_feed/features/author/domain/entities/author_profile_args.dart';

class _TestNavigatorObserver extends NavigatorObserver {
  Route<dynamic>? pushedRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoute = route;
    super.didPush(route, previousRoute);
  }
}

class _FakeArticleReaderCubit extends Cubit<ArticleReaderState>
    implements ArticleReaderCubit {
  _FakeArticleReaderCubit() : super(const ArticleReaderInitial());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('tapping author identity pushes author route with AuthorProfileArgs', (tester) async {
    final navObserver = _TestNavigatorObserver();
    final cubit = _FakeArticleReaderCubit();

    final testItem = EditorialNewsItem(
      id: 'art-42',
      badge: 'TECH',
      badgeColor: Colors.blue,
      title: 'Quantum Leap',
      updated: '2h ago',
      authorName: 'Grace Hopper',
      authorRole: 'Compiler Architect',
      authorAvatar: 'https://example.com/avatar.png',
      authorId: 'author-gh',
      excerpt: 'Intro to compilers',
      color: Colors.white,
    );

    await tester.pumpWidget(
      BlocProvider<ArticleReaderCubit>.value(
        value: cubit,
        child: MaterialApp(
          navigatorObservers: [navObserver],
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.author) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => const Scaffold(body: Text('Author Screen')),
              );
            }
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => Scaffold(
                body: ArticleAuthorSection(article: testItem),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Grace Hopper'));
    await tester.pumpAndSettle();

    expect(find.text('Author Screen'), findsOneWidget);
    expect(navObserver.pushedRoute?.settings.name, equals(AppRoutes.author));

    final passedArgs = navObserver.pushedRoute?.settings.arguments;
    expect(passedArgs, isA<AuthorProfileArgs>());
    final authorArgs = passedArgs as AuthorProfileArgs;
    expect(authorArgs.authorName, equals('Grace Hopper'));
    expect(authorArgs.authorRole, equals('Compiler Architect'));
    expect(authorArgs.authorAvatar, equals('https://example.com/avatar.png'));
    expect(authorArgs.authorId, equals('author-gh'));

    await cubit.close();
  });
}
