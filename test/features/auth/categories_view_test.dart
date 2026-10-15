import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/presentation/views/categories_view.dart';
import 'package:mind_feed/features/auth/presentation/widgets/category_card.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';

class FakeProfileRemoteDataSource extends Fake implements ProfileRemoteDataSource {
  final Map<String, List<String>> userFavorites = {};
  bool shouldThrow = false;

  final List<Map<String, dynamic>> allCategories = [
    {'id': 'cat-tech-uuid', 'name': 'Technology', 'slug': 'technology'},
    {'id': 'cat-biz-uuid', 'name': 'Business', 'slug': 'business'},
    {'id': 'cat-edu-uuid', 'name': 'Education', 'slug': 'education'},
    {'id': 'cat-sci-uuid', 'name': 'Science', 'slug': 'science'},
  ];

  @override
  Future<List<Map<String, dynamic>>> getCategories() async => allCategories;

  @override
  Future<List<Map<String, dynamic>>> getFavoriteCategories(String userId) async {
    final ids = userFavorites[userId] ?? [];
    return ids.map((id) => {'category_id': id}).toList();
  }

  @override
  Future<void> setFavoriteCategories({
    required String userId,
    required List<String> categoryIds,
  }) async {
    if (shouldThrow) {
      throw Exception('Network offline');
    }
    final existingIds = (userFavorites[userId] ?? []).toSet();
    final desiredIds = categoryIds.toSet();
    final staleIds = existingIds.difference(desiredIds);
    final missingIds = desiredIds.difference(existingIds);

    final current = (userFavorites[userId] ?? []).toList();
    current.removeWhere((id) => staleIds.contains(id));
    current.addAll(missingIds);
    userFavorites[userId] = current;
  }
}

Widget testHarness(Widget child) {
  return MaterialApp(
    home: Builder(
      builder: (context) {
        AppTextStyles.init(context);
        return child;
      },
    ),
  );
}

void main() {
  testWidgets('CategoriesView displays all categories and Continue button', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(testHarness(const CategoriesView()));

    expect(find.text('Choose Your Favorite Categories'), findsOneWidget);
    expect(find.text("Select topics you're interested in"), findsOneWidget);
    expect(find.text('Technology'), findsOneWidget);
    expect(find.text('Business'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
    expect(find.text('Science'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('CategoryCard toggles selection on tap', (tester) async {
    bool isSelected = false;
    await tester.pumpWidget(
      testHarness(
        Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return CategoryCard(
                category: const ['Technology', 'assets/images/technology_icon.svg'],
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Technology'), findsOneWidget);
    await tester.tap(find.text('Technology'));
    await tester.pump();
    expect(isSelected, isTrue);
  });

  testWidgets('CategoriesView navigates to main when Continue is pressed', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    bool navigatedToMain = false;

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/categories',
        routes: {
          '/categories': (context) => Builder(
            builder: (ctx) {
              AppTextStyles.init(ctx);
              return const CategoriesView();
            },
          ),
          AppRoutes.main: (context) {
            navigatedToMain = true;
            return const Scaffold(body: Text('Main Screen'));
          },
        },
      ),
    );

    expect(find.text('Technology'), findsOneWidget);
    await tester.tap(find.text('Technology'));
    await tester.pump();

    await tester.ensureVisible(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(navigatedToMain, isTrue);
    expect(find.text('Main Screen'), findsOneWidget);
  });

  testWidgets('Regression: pre-populates two favorites, deselects one, and remote retains only remaining selection', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final fakeRemote = FakeProfileRemoteDataSource();
    fakeRemote.userFavorites['user@test.com'] = ['cat-tech-uuid', 'cat-sci-uuid'];

    const user = UserEntity(
      email: 'user@test.com',
      userName: 'User',
      token: 'tok-123',
      favoriteCategories: ['Technology', 'Science'],
    );

    bool navigatedToMain = false;

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/categories',
        routes: {
          '/categories': (context) => Builder(
            builder: (ctx) {
              AppTextStyles.init(ctx);
              return CategoriesView(
                userEntity: user,
                profileRemoteDataSource: fakeRemote,
              );
            },
          ),
          AppRoutes.main: (context) {
            navigatedToMain = true;
            return const Scaffold(body: Text('Main Screen'));
          },
        },
      ),
    );

    await tester.tap(find.text('Science'));
    await tester.pump();

    await tester.ensureVisible(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(navigatedToMain, isTrue);
    expect(fakeRemote.userFavorites['user@test.com'], equals(['cat-tech-uuid']));
  });

  testWidgets('Regression: deselecting all categories removes all remote favorites', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final fakeRemote = FakeProfileRemoteDataSource();
    fakeRemote.userFavorites['user@test.com'] = ['cat-tech-uuid'];

    const user = UserEntity(
      email: 'user@test.com',
      userName: 'User',
      token: 'tok-123',
      favoriteCategories: ['Technology'],
    );

    bool navigatedToMain = false;

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/categories',
        routes: {
          '/categories': (context) => Builder(
            builder: (ctx) {
              AppTextStyles.init(ctx);
              return CategoriesView(
                userEntity: user,
                profileRemoteDataSource: fakeRemote,
              );
            },
          ),
          AppRoutes.main: (context) {
            navigatedToMain = true;
            return const Scaffold(body: Text('Main Screen'));
          },
        },
      ),
    );

    await tester.tap(find.text('Technology'));
    await tester.pump();

    await tester.ensureVisible(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(navigatedToMain, isTrue);
    expect(fakeRemote.userFavorites['user@test.com'], isEmpty);
  });

  testWidgets('Offline resilience: remote sync failure does not trap user or crash navigation', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final fakeRemote = FakeProfileRemoteDataSource()..shouldThrow = true;

    const user = UserEntity(
      email: 'user@test.com',
      userName: 'User',
      token: 'tok-123',
      favoriteCategories: ['Technology'],
    );

    bool navigatedToMain = false;

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/categories',
        routes: {
          '/categories': (context) => Builder(
            builder: (ctx) {
              AppTextStyles.init(ctx);
              return CategoriesView(
                userEntity: user,
                profileRemoteDataSource: fakeRemote,
              );
            },
          ),
          AppRoutes.main: (context) {
            navigatedToMain = true;
            return const Scaffold(body: Text('Main Screen'));
          },
        },
      ),
    );

    await tester.ensureVisible(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(navigatedToMain, isTrue);
    expect(find.text('Main Screen'), findsOneWidget);
  });
}
