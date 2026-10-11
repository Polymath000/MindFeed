import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class PaperSettingsSection extends StatelessWidget {
  const PaperSettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.kicker,
  });

  final String title;
  final String? kicker;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (kicker != null) ...[
                  Text(
                    kicker!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.mutedInk,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: AppColors.mutedInk, fontSize: 10)),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteLight,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.creamBorder,
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.transparentDark,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.sandLighter,
                      indent: 60,
                      endIndent: 16,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaperSettingsTile extends StatelessWidget {
  const PaperSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.stampColor = AppColors.sand,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color stampColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: stampColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.creamDark,
                  width: 1,
                ),
              ),
              child: Icon(icon, size: 19, color: AppColors.ink),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: AppColors.mutedInk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(
                AppIcons.arrowForwardIosRounded,
                size: 14,
                color: AppColors.mutedInk,
              ),
          ],
        ),
      ),
    );
  }
}

class PaperSettingsSwitchTile extends StatelessWidget {
  const PaperSettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.stampColor = AppColors.sand,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color stampColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: stampColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.creamDark,
                width: 1,
              ),
            ),
            child: Icon(icon, size: 19, color: AppColors.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: AppColors.mutedInk,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.ink,
            activeTrackColor: AppColors.butter,
            inactiveThumbColor: AppColors.greyBrown,
            inactiveTrackColor: AppColors.sandDarker,
          ),
        ],
      ),
    );
  }
}

class PaperSegmentedOptions<T> extends StatelessWidget {
  const PaperSegmentedOptions({
    super.key,
    required this.title,
    this.subtitle,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    required this.labelBuilder,
  });

  final String title;
  final String? subtitle;
  final List<T> options;
  final T selectedOption;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: -0.2,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mutedInk,
              ),
            ),
          ],
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: options.map((option) {
                final isSelected = option == selectedOption;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onChanged(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.ink
                            : AppColors.creamLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.ink
                              : AppColors.sandDarkest,
                        ),
                      ),
                      child: Text(
                        labelBuilder(option),
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.cream
                              : AppColors.ink,
                          fontSize: 12.5,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({
    super.key,
    required this.children,
    required this.title,
  });

  final List<Widget> children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return PaperSettingsSection(
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
  return PaperSettingsTile(
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
  return PaperSettingsSwitchTile(
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
  return PaperSettingsTile(
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
  return PaperSettingsTile(
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
