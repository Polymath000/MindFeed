import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';

Widget _buildStamp(IconData icon, Color color) => Container(
      width: 38, height: 38,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.creamDark)),
      child: Icon(icon, size: 19, color: AppColors.ink),
    );

Widget _buildTitleSubtitle(String title, String? subtitle) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink, letterSpacing: -0.2)),
        if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle, style: const TextStyle(fontSize: 12, height: 1.3, color: AppColors.mutedInk))],
      ],
    );

class SettingsSectionBlock extends StatelessWidget {
  final String title;
  final String? kicker;
  final List<Widget> children;
  const SettingsSectionBlock({super.key, required this.title, required this.children, this.kicker});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                if (kicker != null) ...[
                  Text(kicker!.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.mutedInk)),
                  const SizedBox(width: 8), const Text('•', style: TextStyle(color: AppColors.mutedInk, fontSize: 10)), const SizedBox(width: 8),
                ],
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: -0.2, color: AppColors.ink)),
              ]),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteLight, borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.creamBorder, width: 1.2),
                boxShadow: const [BoxShadow(color: AppColors.transparentDark, blurRadius: 10, offset: Offset(0, 3))],
              ),
              child: Column(children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    const Divider(height: 1, thickness: 1, color: AppColors.sandLighter, indent: 60, endIndent: 16),
                ],
              ]),
            ),
          ],
        ),
      );
}

class SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color stampColor;
  final VoidCallback? onTap;
  const SettingsActionTile({
    super.key, required this.icon, required this.title, this.subtitle,
    this.trailing, this.stampColor = AppColors.sand, this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(children: [
            _buildStamp(icon, stampColor), const SizedBox(width: 14),
            Expanded(child: _buildTitleSubtitle(title, subtitle)),
            if (trailing != null) trailing! else if (onTap != null)
              const Icon(AppIcons.arrowForwardIosRounded, size: 14, color: AppColors.mutedInk),
          ]),
        ),
      );
}

class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color stampColor;
  const SettingsToggleTile({
    super.key, required this.icon, required this.title, this.subtitle,
    required this.value, required this.onChanged, this.stampColor = AppColors.sand,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(children: [
          _buildStamp(icon, stampColor), const SizedBox(width: 14),
          Expanded(child: _buildTitleSubtitle(title, subtitle)),
          Switch.adaptive(
            value: value, onChanged: onChanged, activeThumbColor: AppColors.ink,
            activeTrackColor: AppColors.butter, inactiveThumbColor: AppColors.greyBrown, inactiveTrackColor: AppColors.sandDarker,
          ),
        ]),
      );
}

class SettingsValueTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String value;
  final Color stampColor;
  final VoidCallback? onTap;
  const SettingsValueTile({
    super.key, required this.icon, required this.title, this.subtitle,
    required this.value, this.stampColor = AppColors.sand, this.onTap,
  });

  @override
  Widget build(BuildContext context) => SettingsActionTile(
        icon: icon, title: title, subtitle: subtitle, stampColor: stampColor, onTap: onTap,
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(width: 4), const Icon(AppIcons.arrowForwardIosRounded, size: 12, color: AppColors.mutedInk),
        ]),
      );
}

class SettingsChoiceChip<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<T> options;
  final T selectedOption;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  const SettingsChoiceChip({
    super.key, required this.title, this.subtitle, required this.options,
    required this.selectedOption, required this.onChanged, required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink, letterSpacing: -0.2)),
          if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.mutedInk))],
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(),
            child: Row(children: [
              for (final option in options)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onChanged(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: option == selectedOption ? AppColors.ink : AppColors.creamLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: option == selectedOption ? AppColors.ink : AppColors.sandDarkest),
                      ),
                      child: Text(labelBuilder(option), style: TextStyle(color: option == selectedOption ? AppColors.cream : AppColors.ink, fontSize: 12.5, fontWeight: option == selectedOption ? FontWeight.w800 : FontWeight.w600)),
                    ),
                  ),
                ),
            ]),
          ),
        ]),
      );
}

class SettingsSliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final double value;
  final ValueChanged<double> onChanged;
  final double min, max;
  final Color stampColor;
  const SettingsSliderTile({
    super.key, required this.icon, required this.title, this.subtitle,
    required this.value, required this.onChanged, this.min = 0.0, this.max = 100.0, this.stampColor = AppColors.sand,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [_buildStamp(icon, stampColor), const SizedBox(width: 14), Expanded(child: _buildTitleSubtitle(title, subtitle))]),
          Slider(value: value, min: min, max: max, activeColor: AppColors.ink, inactiveColor: AppColors.sandDarker, onChanged: onChanged),
        ]),
      );
}

typedef PaperSettingsSection = SettingsSectionBlock;
typedef PaperSettingsTile = SettingsActionTile;
typedef PaperSettingsSwitchTile = SettingsToggleTile;
typedef PaperSegmentedOptions<T> = SettingsChoiceChip<T>;
