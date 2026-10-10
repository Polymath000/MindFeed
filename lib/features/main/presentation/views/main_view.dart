import 'package:flutter/material.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const String routeName = 'main';
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF171614),
    body: IndexedStack(
      index: selectedIndex,
      children: const [HomeView(), SearchView(), ArticlesSaved()],
    ),
    bottomNavigationBar: MainNavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => setState(() => selectedIndex = index),
    ),
  );
}
