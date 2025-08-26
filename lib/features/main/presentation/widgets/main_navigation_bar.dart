import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
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
          color: AppColors.black,
          haptic: true,
          tabs: [
            GButton(icon: LineIcons.home, text: 'Home'),
            GButton(icon: LineIcons.search, text: 'Search'),
            GButton(icon: Icons.save_alt_outlined, text: 'Save'),
            GButton(icon: Icons.category_outlined, text: 'Category'),
          ],
          selectedIndex: widget.selectedIndex,
          onTabChange: widget.onDestinationSelected,
        ),
      ),
    );
  }
}
