import 'package:flutter/material.dart';
import 'package:mind_feed/features/aricles_by_categories/presentation/views/aricles_by_categories_view.dart';
import 'package:mind_feed/features/articles_save/presentation/views/articles_saved.dart';
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
  int selectedIndex = 0;
  bool isDrawerVisible = false;

  @override
  void initState() {
    super.initState();
    advancedDrawerController.addListener(_onDrawerChanged);
  }

  @override
  void dispose() {
    advancedDrawerController.removeListener(_onDrawerChanged);
    super.dispose();
  }

  void _onDrawerChanged() {
    final visible = advancedDrawerController.value.visible;
    if (visible != isDrawerVisible) {
      setState(() => isDrawerVisible = visible);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: Container(
        decoration: !isDrawerVisible
            ? BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  ),
                ],
              )
            : null,
        child: !isDrawerVisible
            ? MainNavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8,
                ),
              ),
      ),
    );
  }
}

final List<Widget> widgetOptions = <Widget>[
  HomeView(),
  const SearchView(),
  ArticlesSaved(),
  const AriclesByCategoriesView(),
];
