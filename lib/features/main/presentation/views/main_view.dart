import 'package:flutter/material.dart';
import 'package:mind_feed/features/aricles_by_categories/presentation/views/aricles_by_categories_view.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: MainNavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
    );
  }
}

const List<Widget> widgetOptions = <Widget>[
  HomeView(),
  SearchView(),
  AriclesByCategoriesView(),
];
