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
              color: isDark ? AppColors.darkGrey : AppColors.black,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkerGrey : AppColors.darkGrey,
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
}) {
  return ListTile(
    leading: Icon(icon, color: AppColors.white),
    title: Text(
      title,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),
    trailing: const Icon(Icons.chevron_right, color: AppColors.white),
    onTap: onTap,
  );
}

Widget buildSettingsMenuItemSwitcher({
  required IconData icon,
  required String title,
  void Function()? onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: AppColors.white),
    title: Text(
      title,
      style: const TextStyle(
        color: AppColors.white,
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
}) {
  return ListTile(
    leading: Icon(icon, color: AppColors.white),
    title: Text(
      title,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '123',
          style: AppTextStyles.bodyMedium!.copyWith(color: AppColors.white),
        ),
        Icon(Icons.chevron_right, color: AppColors.white),
      ],
    ),
    onTap: onTap,
  );
}
