import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/views/add_article.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/publish_article_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/save_draft_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/update_article_use_case.dart';
import '../controllers/add_article_cubit_test.dart';

void main() {
  late FakeArticlesRepository repo;
  late AddArticleCubit cubit;

  const testUser = CurrentUserSnapshot(
    id: 'user-widget-test',
    displayName: 'Widget Test Author',
    email: 'widget@example.com',
  );

  setUp(() {
    repo = FakeArticlesRepository();

    cubit = AddArticleCubit(
      getCategoriesUseCase: GetCategoriesUseCase(repo),
      getFixedTagsUseCase: GetFixedTagsUseCase(repo),
      saveDraftUseCase: SaveDraftUseCase(repo),
      publishArticleUseCase: PublishArticleUseCase(repo),
      updateArticleUseCase: UpdateArticleUseCase(repo),
      userResolver: () => testUser,
      dimensionResolver: (url, {timeout = const Duration(seconds: 5)}) async =>
          const Size(1200, 630),
    );
  });

  tearDown(() {
    cubit.close();
  });

  testWidgets('editor shows field error messages when publishing empty form', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await cubit.initialize();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AddArticleCubit>.value(
          value: cubit,
          child: const AddArticleView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('article_title_field')), findsOneWidget);
    expect(find.byKey(const Key('article_content_field')), findsOneWidget);
    expect(find.byKey(const Key('article_cover_field')), findsOneWidget);
    expect(find.byKey(const Key('publish_button')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('publish_button')));
    await tester.tap(find.byKey(const Key('publish_button')));
    await tester.pumpAndSettle();

    expect(find.text('Article title cannot be empty'), findsOneWidget);
    expect(find.text('Article body cannot be empty'), findsOneWidget);
    expect(find.text('Cover image URL is required'), findsOneWidget);
    expect(find.text('Please select a category'), findsOneWidget);
    expect(find.text('Please select between 1 and 5 tags'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('article_title_field')),
      'Editorial Headline',
    );
    await tester.pumpAndSettle();

    expect(find.text('Article title cannot be empty'), findsNothing);
  });

  testWidgets('editor shows draft error when saving draft with empty title', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await cubit.initialize();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AddArticleCubit>.value(
          value: cubit,
          child: const AddArticleView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('save_draft_button')));
    await tester.tap(find.byKey(const Key('save_draft_button')));
    await tester.pumpAndSettle();

    expect(find.text('Title cannot be empty to save a draft'), findsWidgets);
  });

  testWidgets(
    'editing article populates cover URL from heroImageUrl and typing updates state',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const heroUrl =
          'https://tsqruoqiajkbrdhprfxa.supabase.co/storage/v1/object/public/article-media/u1/hero_cover.jpg';
      final editingItem = EditorialNewsItem(
        id: 'article-edit-1',
        badge: 'TECH',
        badgeColor: AppColors.creamDark,
        title: 'Editing Story',
        updated: 'Just now',
        authorName: 'Widget Test Author',
        authorRole: 'Editor',
        authorAvatar: '',
        excerpt: 'Excerpt',
        color: AppColors.cream,
        coverImageUrl: heroUrl,
      );

      await cubit.initialize(editingItem: editingItem);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AddArticleCubit>.value(
            value: cubit,
            child: AddArticleView(initialItem: editingItem),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(cubit.state.coverImageUrl, heroUrl);

      final textField = tester.widget<TextField>(
        find.byKey(const Key('article_cover_field')),
      );
      expect(textField.controller?.text, heroUrl);

      const updatedUrl =
          'https://tsqruoqiajkbrdhprfxa.supabase.co/storage/v1/object/public/article-media/u1/new_cover.jpg';
      await tester.enterText(
        find.byKey(const Key('article_cover_field')),
        updatedUrl,
      );
      await tester.pumpAndSettle();

      expect(cubit.state.coverImageUrl, updatedUrl);
    },
  );
}
