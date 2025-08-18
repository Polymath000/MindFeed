import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'home',
          selectedIcon: Icon(Icons.home_rounded),
        ),
        NavigationDestination(
          icon: Icon(Icons.search),
          label: 'search',
          selectedIcon: Icon(Icons.search_rounded),
        ),
        NavigationDestination(
          icon: Icon(Icons.category_outlined),
          label: 'categories',
          selectedIcon: Icon(Icons.category_rounded),
        ),
      ],
    );
  }
}
