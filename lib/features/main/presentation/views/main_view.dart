import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart';
import 'package:mind_feed/features/profile/presentation/views/profile_view.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const String routeName = 'main';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  final Set<int> _visitedTabs = {0};
  final Map<int, Widget> _cachedTabs = {};

  int _savedRefreshSeed = 0;

  @override
  void initState() {
    super.initState();
    _cachedTabs[0] = const HomeView();
  }

  void _onTabSelected(int index) {
    FocusScope.of(context).unfocus();

    if (_selectedIndex == index) {
      _handleSameTabTapped(index);
      return;
    }

    setState(() {
      _visitedTabs.add(index);
      _cachedTabs.putIfAbsent(index, () => _buildChildWidget(index));
      _selectedIndex = index;
    });
  }

  void _handleSameTabTapped(int index) {
    if (index == 2) {
      setState(() {
        _savedRefreshSeed++;
        _cachedTabs[2] = ArticlesSaved(refreshSeed: _savedRefreshSeed);
      });
    }
  }

  Widget _buildChildWidget(int index) {
    return switch (index) {
      0 => const HomeView(),
      1 => const SearchView(),
      2 => ArticlesSaved(refreshSeed: _savedRefreshSeed),
      3 => const ProfileView(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildTab(int index) {
    if (!_visitedTabs.contains(index)) {
      return const SizedBox.shrink();
    }
    return TickerMode(
      enabled: _selectedIndex == index,
      child: RepaintBoundary(
        child: _cachedTabs[index] ?? const SizedBox.shrink(),
      ),
    );
  }

  void _handlePop() {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handlePop();
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.ink,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildTab(0),
            _buildTab(1),
            _buildTab(2),
            _buildTab(3),
          ],
        ),
        bottomNavigationBar: MainNavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onTabSelected,
        ),
      ),
    );
  }
}
