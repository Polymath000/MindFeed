import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/constants/borders.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key, required this.children, required this.title});
  final List<Widget> children;
  final String title;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge!.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkerGrey : AppColors.grey,
              borderRadius: AppBorders.xxxs,
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1) buildDivider(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildDivider() {
  return const Divider(height: 1, thickness: 1, color: Color(0xFF1F2937));
}

Widget buildSettingsMenuItem({
  required IconData icon,
  required String title,
  required void Function()? onTap,
  required BuildContext context,
}) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  return ListTile(
    leading: Icon(icon, color: isDark ? AppColors.white : AppColors.black),
    title: Text(
      title,
      style: TextStyle(
        color: isDark ? AppColors.white : AppColors.black,
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),
    trailing: Icon(
      Icons.chevron_right,
      color: isDark ? AppColors.white : AppColors.darkGrey,
    ),
    onTap: onTap,
  );
}

Widget buildSettingsMenuItemSwitcher({
  required IconData icon,
  required String title,
  void Function()? onTap,
  required BuildContext context,
}) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  return ListTile(
    leading: Icon(icon, color: isDark ? AppColors.white : AppColors.black),
    title: Text(
      title,
      style: TextStyle(
        color: isDark ? AppColors.white : AppColors.black,
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),
    trailing: Switch(value: true, onChanged: (value) {}),
    onTap: onTap,
  );
}

Widget buildSettingsMenuItemWithDropMenu({
  required IconData icon,
  required String title,
  void Function()? onTap,
  required String beforeTrailing,
  required BuildContext context,
}) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  return ListTile(
    leading: Icon(icon, color: isDark ? AppColors.white : AppColors.black),
    title: Text(
      title,
      style: TextStyle(
        color: isDark ? AppColors.white : AppColors.black,
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          beforeTrailing,
          style: AppTextStyles.bodyMedium!.copyWith(
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: isDark ? AppColors.white : AppColors.black,
        ),
      ],
    ),
    onTap: onTap,
  );
}

Widget buildSettingsMenuItemWithDropdown<T>({
  required IconData icon,
  required String title,
  required T value,
  required List<DropdownMenuItem<T>> items,
  required void Function(T?)? onChanged,
  required BuildContext context,
}) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  return ListTile(
    leading: Icon(icon, color: isDark ? AppColors.white : AppColors.black),
    title: Text(
      title,
      style: TextStyle(
        color: isDark ? AppColors.white : AppColors.black,
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),
    trailing: DropdownButton<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      underline: const SizedBox(),
      icon: Icon(
        Icons.expand_more,
        color: isDark ? AppColors.white : AppColors.black,
      ),
      dropdownColor: isDark ? AppColors.darkerGrey : AppColors.grey,
      style: TextStyle(color: isDark ? AppColors.white : AppColors.black),
    ),
  );
}
