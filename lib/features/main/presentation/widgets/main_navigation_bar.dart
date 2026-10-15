import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: SizedBox(
      height: 72,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 174,
            height: 58,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: AppColors.ink,
              borderRadius: AppBorders.control,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Nav(
                  icon: AppIcons.home,
                  label: 'Home',
                  active: selectedIndex == 0,
                  onTap: () => onDestinationSelected(0),
                ),
                _Nav(
                  icon: AppIcons.search,
                  label: 'Search',
                  active: selectedIndex == 1,
                  onTap: () => onDestinationSelected(1),
                ),
                _Nav(
                  icon: AppIcons.bookmarkFilled,
                  label: 'Saved news',
                  active: selectedIndex == 2,
                  onTap: () => onDestinationSelected(2),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _Nav extends StatelessWidget {
  const _Nav({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    selected: active,
    child: Tooltip(
      message: label,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: active ? AppColors.softCream : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: active ? AppColors.ink : AppColors.softCream,
          ),
        ),
      ),
    ),
  );
}
