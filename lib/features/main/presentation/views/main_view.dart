import 'package:flutter/material.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart';
import 'package:mind_feed/features/profile/presentation/views/profile_view.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/profile/data/services/category_sync_reconciler.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const String routeName = 'main';
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var selectedIndex = 0;
  var savedRefreshSeed = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getIt.isRegistered<CategorySyncReconciler>()) {
        getIt<CategorySyncReconciler>().reconcilePendingSync();
      } else {
        CategorySyncReconciler().reconcilePendingSync();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    backgroundColor: AppColors.ink,
    body: IndexedStack(
      index: selectedIndex,
      children: [
        const HomeView(),
        const SearchView(),
        ArticlesSaved(refreshSeed: savedRefreshSeed),
        const ProfileView(),
      ],
    ),
    bottomNavigationBar: MainNavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          if (index == 2) {
            savedRefreshSeed++;
          }
          selectedIndex = index;
        });
      },
    ),
  );
}
