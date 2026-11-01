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

  testWidgets('renders tag_search_field and add_tag_button', (tester) async {
    await cubit.initialize();
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tag_search_field')), findsOneWidget);
    expect(find.byKey(const Key('add_tag_button')), findsOneWidget);
    expect(find.text('Add Tag'), findsOneWidget);
    expect(
      find.text('No tags selected yet (select between 1 and 5 tags).'),
      findsOneWidget,
    );
  });

  testWidgets('typing in tag_search_field displays filtered suggestions and selects tag', (
    tester,
  ) async {
    await cubit.initialize();
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('tag_search_field')),
      'flut',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('suggested_tag_flutter')), findsOneWidget);

    await tester.tap(find.byKey(const Key('suggested_tag_flutter')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tag_chip_flutter')), findsOneWidget);
    expect(cubit.state.selectedTags, contains('flutter'));
  });

  testWidgets('typing a new tag in search field allows adding via new tag chip', (
    tester,
  ) async {
    await cubit.initialize();
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('tag_search_field')),
      'cybersecurity',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('add_new_tag_chip')), findsOneWidget);
    expect(find.text('Add "#cybersecurity"'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add_new_tag_chip')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tag_chip_cybersecurity')), findsOneWidget);
    expect(cubit.state.selectedTags, contains('cybersecurity'));
  });

  testWidgets('submitting search field directly adds tag', (tester) async {
    await cubit.initialize();
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('tag_search_field')),
      'neuroscience',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('submit_tag_search_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tag_chip_neuroscience')), findsOneWidget);
    expect(cubit.state.selectedTags, contains('neuroscience'));
  });

  testWidgets('can remove a selected tag by tapping its delete icon', (
    tester,
  ) async {
    await cubit.initialize();
    cubit.onTagToggled('flutter');
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tag_chip_flutter')), findsOneWidget);
    expect(cubit.state.selectedTags, contains('flutter'));

    // Find the close delete icon within the tag chip
    final deleteIcon = find.descendant(
      of: find.byKey(const Key('tag_chip_flutter')),
      matching: find.byType(Icon),
    );
    await tester.tap(deleteIcon);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tag_chip_flutter')), findsNothing);
    expect(cubit.state.selectedTags.contains('flutter'), isFalse);
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
      'robotics',
    );
    await tester.tap(find.byKey(const Key('add_tag_confirm_button')));
    await tester.pumpAndSettle();

    expect(find.text('Add New Tag'), findsNothing);
    expect(find.byKey(const Key('tag_chip_robotics')), findsOneWidget);
    expect(cubit.state.selectedTags, contains('robotics'));
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
