import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_tile_primitives.dart';

export 'settings_tile_primitives.dart';

class SettingsMenu extends StatelessWidget {
  final List<Widget> children;
  final String title;

  const SettingsMenu({
    super.key,
    required this.children,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSectionBlock(
      title: title,
      children: children,
    );
  }
}

Widget buildSettingsMenuItem({
  required IconData icon,
  required String title,
  required void Function()? onTap,
  required BuildContext context,
}) {
  return SettingsActionTile(
    icon: icon,
    title: title,
    onTap: onTap,
  );
}

Widget buildSettingsMenuItemSwitcher({
  required IconData icon,
  required String title,
  void Function()? onTap,
  required BuildContext context,
}) {
  return SettingsToggleTile(
    icon: icon,
    title: title,
    value: true,
    onChanged: (_) => onTap?.call(),
  );
}

Widget buildSettingsMenuItemWithDropMenu({
  required IconData icon,
  required String title,
  void Function()? onTap,
  required String beforeTrailing,
  required BuildContext context,
}) {
  return SettingsActionTile(
    icon: icon,
    title: title,
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (beforeTrailing.isNotEmpty)
          Text(
            beforeTrailing,
            style: const TextStyle(
              color: AppColors.mutedInk,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        const SizedBox(width: 4),
        const Icon(
          AppIcons.arrowForwardIosRounded,
          size: 13,
          color: AppColors.mutedInk,
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
  return SettingsActionTile(
    icon: icon,
    title: title,
    trailing: DropdownButton<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      underline: const SizedBox(),
      icon: const Icon(
        AppIcons.expandMoreRounded,
        color: AppColors.ink,
      ),
      dropdownColor: AppColors.whiteLight,
      style: const TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
