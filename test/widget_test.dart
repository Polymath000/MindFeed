import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/home/presentation/views/article_view.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/views/main_view.dart';
import 'package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/features/settings/presentation/views/settings_view.dart';

Widget editorialHarness(Widget child) =>
    MaterialApp(theme: ThemeData.light(), home: child);

void main() {
  testWidgets(
    'home renders the editorial masthead and lead story on a small phone',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(editorialHarness(const HomeView()));

      expect(find.text('MindFeed'), findsOneWidget);
      expect(find.textContaining('Demand for Indian'), findsOneWidget);
      expect(find.byTooltip('Open profile'), findsOneWidget);
    },
  );

  testWidgets(
    'saved and article surfaces retain editorial reading anchors at large text',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(editorialHarness(const ArticlesSaved()));
      expect(find.text('Saved News'), findsOneWidget);
      expect(find.bySemanticsLabel('Search saved news'), findsOneWidget);

      await tester.pumpWidget(editorialHarness(const ArticleView()));
      expect(find.textContaining('Demand for Indian'), findsOneWidget);
      expect(find.bySemanticsLabel('Save article'), findsOneWidget);
    },
  );

  testWidgets('floating editorial navigation exposes three destinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      editorialHarness(
        MainNavigationBar(selectedIndex: 0, onDestinationSelected: (_) {}),
      ),
    );

    expect(find.bySemanticsLabel('Home'), findsOneWidget);
    expect(find.bySemanticsLabel('Search'), findsOneWidget);
    expect(find.bySemanticsLabel('Saved news'), findsOneWidget);
  });

  testWidgets('main shell renders home at top and navigation at bottom', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(editorialHarness(const MainView()));

    final mastheadFinder = find.text('MindFeed');
    final homeNavFinder = find.bySemanticsLabel('Home');

    expect(mastheadFinder, findsOneWidget);
    expect(homeNavFinder, findsOneWidget);

    final mastheadPos = tester.getTopLeft(mastheadFinder);
    final navPos = tester.getTopLeft(homeNavFinder);

    expect(mastheadPos.dy, lessThan(200));
    expect(navPos.dy, greaterThan(700));
  });

  testWidgets('settings renders paper aesthetic sections and preferences', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<ThemeModeCubit>(
        create: (_) => ThemeModeCubit(),
        child: editorialHarness(const SettingsView()),
      ),
    );

    expect(find.text('Settings & Preferences'), findsOneWidget);
    expect(find.text('Warm Paper'), findsOneWidget);
    expect(find.text('Midnight Ink'), findsOneWidget);
    expect(find.text('Wade Warren'), findsOneWidget);
    expect(find.text('Reading Experience & Surface'), findsOneWidget);
    expect(find.text('Typeface Scale'), findsOneWidget);
    expect(find.text('Serif Literary Immersion'), findsOneWidget);
  });
}
