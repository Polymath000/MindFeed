import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/utls/app_icons.dart';

class MainNavigationBar extends StatefulWidget {
  MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: AppColors.lightGray,
          gap: 8,
          activeColor: AppColors.black,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.lightGray,
          color: isDark ? AppColors.lightGray : AppColors.black,
          haptic: true,

          tabs: [
            GButton(
              icon: widget.selectedIndex == 0
                  ? AppIcons.home
                  : AppIcons.homeOutline,
              text: 'Home',
              // iconActiveColor: AppColors.black,
              backgroundColor: isDark ? AppColors.grey : AppColors.lightGray,
            ),
            GButton(
              icon: widget.selectedIndex == 1
                  ? AppIcons.search
                  : Icons.search,
              text: 'Search',
              backgroundColor: isDark ? AppColors.grey : AppColors.lightGray,
            ),
            GButton(
              icon: widget.selectedIndex == 2
                  ? AppIcons.bookmarkFilled
                  : AppIcons.bookmarkOutline,
              text: 'Save',
              backgroundColor: isDark ? AppColors.grey : AppColors.lightGray,
            ),
            GButton(
              icon: widget.selectedIndex == 3
                  ? AppIcons.person
                  : AppIcons.personOutline,
              text: 'Profile',
              backgroundColor: isDark ? AppColors.grey : AppColors.lightGray,
            ),
          ],
          selectedIndex: widget.selectedIndex,
          onTabChange: widget.onDestinationSelected,
        ),
      ),
    );
  }
}
