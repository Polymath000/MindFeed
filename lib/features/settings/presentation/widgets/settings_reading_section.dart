import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_tile_primitives.dart';
import 'package:mind_feed/features/settings/presentation/widgets/theme_widget.dart';

class SettingsReadingSection extends StatelessWidget {
  final String fontScale;
  final ValueChanged<String> onFontScaleChanged;
  final bool serifMode;
  final ValueChanged<bool> onSerifModeChanged;
  final VoidCallback onTapPreferredCategories;

  const SettingsReadingSection({
    super.key,
    required this.fontScale,
    required this.onFontScaleChanged,
    required this.serifMode,
    required this.onSerifModeChanged,
    required this.onTapPreferredCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SettingsSectionBlock(
          title: 'Reading Experience & Surface',
          kicker: 'CANVAS & TYPE',
          children: [
            const ThemeWidget(),
            SettingsActionTile(
              icon: AppIcons.gridViewRounded,
              stampColor: AppColors.butter,
              title: 'Preferred Categories',
              subtitle: 'Customize topic feeds and editorial recommendations',
              trailing: const Icon(AppIcons.arrowForwardIosRounded, size: 12, color: AppColors.mutedInk),
              onTap: onTapPreferredCategories,
            ),
            SettingsChoiceChip<String>(
              title: 'Typeface Scale',
              subtitle: 'Adjust comfortable body sizing for reading long articles',
              options: const ['Compact', 'Standard', 'Editorial', 'Large'],
              selectedOption: fontScale,
              onChanged: onFontScaleChanged,
              labelBuilder: (s) => s,
            ),
            SettingsToggleTile(
              icon: AppIcons.menuBookOutlined,
              stampColor: AppColors.lilac,
              title: 'Serif Literary Immersion',
              subtitle: 'Render longform stories in classic editorial serif typography',
              value: serifMode,
              onChanged: onSerifModeChanged,
            ),
          ],
        ),
      ],
    );
  }
}
