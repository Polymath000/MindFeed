import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/add_article/domain/usecases/publish_article_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/save_draft_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/update_article_use_case.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_tag_selector.dart';
import '../controllers/add_article_cubit_test.dart';

void main() {
  late FakeArticlesRepository repo;
  late AddArticleCubit cubit;

  const testUser = CurrentUserSnapshot(
    id: 'user-tag-test',
    displayName: 'Tag Author',
    email: 'tag@example.com',
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
    );
  });

  tearDown(() {
    cubit.close();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AddArticleCubit>.value(
          value: cubit,
          child: const SingleChildScrollView(child: ArticleTagSelector()),
        ),
      ),
    );
  }

  testWidgets('renders add_tag_button and available tags', (tester) async {
    await cubit.initialize();
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('add_tag_button')), findsOneWidget);
    expect(find.text('Add Tag'), findsOneWidget);
    expect(find.byKey(const Key('tag_chip_flutter')), findsOneWidget);
    expect(find.byKey(const Key('tag_chip_dart')), findsOneWidget);
    expect(find.byKey(const Key('tag_chip_ai')), findsOneWidget);
  });

  testWidgets('tapping add_tag_button opens AddTagDialog and creates new tag', (
    tester,
  ) async {
    await cubit.initialize();
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add_tag_button')));
    await tester.pumpAndSettle();

    expect(find.text('Add New Tag'), findsOneWidget);
    expect(find.byKey(const Key('add_tag_text_field')), findsOneWidget);
    expect(find.byKey(const Key('add_tag_confirm_button')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('add_tag_text_field')),
      'cybersecurity',
    );
    await tester.tap(find.byKey(const Key('add_tag_confirm_button')));
    await tester.pumpAndSettle();

    expect(find.text('Add New Tag'), findsNothing);
    expect(find.byKey(const Key('tag_chip_cybersecurity')), findsOneWidget);
    expect(cubit.state.selectedTags, contains('cybersecurity'));
  });

  testWidgets('cancelling AddTagDialog does not add a tag', (tester) async {
    await cubit.initialize();
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add_tag_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('add_tag_text_field')),
      'discarded-tag',
    );
    await tester.tap(find.byKey(const Key('add_tag_cancel_button')));
    await tester.pumpAndSettle();

    expect(find.text('Add New Tag'), findsNothing);
    expect(find.byKey(const Key('tag_chip_discarded-tag')), findsNothing);
    expect(cubit.state.selectedTags.contains('discarded-tag'), isFalse);
  });

  testWidgets(
    'shows snackbar when attempting to add tag with 5 tags selected',
    (tester) async {
      await cubit.initialize();
      cubit.onTagToggled('flutter');
      cubit.onTagToggled('dart');
      cubit.onTagToggled('ai');
      cubit.addCustomTag('tag4');
      cubit.addCustomTag('tag5');

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(cubit.state.selectedTags.length, 5);
      await tester.tap(find.byKey(const Key('add_tag_button')));
      await tester.pump();

      expect(find.text('Maximum of 5 tags allowed'), findsOneWidget);
      expect(find.text('Add New Tag'), findsNothing);
    },
  );
}
