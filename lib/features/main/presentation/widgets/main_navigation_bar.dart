import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mind_feed/config/themes/app_colors.dart';

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
                  ? FontAwesomeIcons.solidHouse
                  : FontAwesomeIcons.house,
              text: 'Home',
              // iconActiveColor: AppColors.black,
              backgroundColor: isDark ? AppColors.grey : AppColors.lightGray,
            ),
            GButton(
              icon: widget.selectedIndex == 1
                  ? FontAwesomeIcons.magnifyingGlass
                  : Icons.search,
              text: 'Search',
              backgroundColor: isDark ? AppColors.grey : AppColors.lightGray,
            ),
            GButton(
              icon: widget.selectedIndex == 2
                  ? FontAwesomeIcons.solidFloppyDisk
                  : FontAwesomeIcons.floppyDisk,
              text: 'Save',
              backgroundColor: isDark ? AppColors.grey : AppColors.lightGray,
            ),
            GButton(
              icon: widget.selectedIndex == 3
                  ? Icons.category
                  : Icons.category_outlined,
              text: 'Category',
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
