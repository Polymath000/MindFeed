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
  final bool bionicGuide;
  final ValueChanged<bool> onBionicGuideChanged;
  final VoidCallback onTapPreferredCategories;
  final bool morningBriefing;
  final ValueChanged<bool> onMorningBriefingChanged;
  final bool breakingAlerts;
  final ValueChanged<bool> onBreakingAlertsChanged;

  const SettingsReadingSection({
    super.key,
    required this.fontScale,
    required this.onFontScaleChanged,
    required this.serifMode,
    required this.onSerifModeChanged,
    required this.bionicGuide,
    required this.onBionicGuideChanged,
    required this.onTapPreferredCategories,
    required this.morningBriefing,
    required this.onMorningBriefingChanged,
    required this.breakingAlerts,
    required this.onBreakingAlertsChanged,
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
            SettingsToggleTile(
              icon: AppIcons.visibilityOutlined,
              stampColor: AppColors.powder,
              title: 'Bionic Reading Guide',
              subtitle: 'Subtly emphasize key word anchors for swift reading pace',
              value: bionicGuide,
              onChanged: onBionicGuideChanged,
            ),
          ],
        ),
        SettingsSectionBlock(
          title: 'Dispatches & Editorial Alerts',
          kicker: 'DISPATCHES',
          children: [
            SettingsToggleTile(
              icon: AppIcons.wbSunnyOutlined,
              stampColor: AppColors.butter,
              title: 'Morning Edition Briefing',
              subtitle: 'Curated 7:00 AM daily reading digest delivered quietly',
              value: morningBriefing,
              onChanged: onMorningBriefingChanged,
            ),
            SettingsToggleTile(
              icon: AppIcons.notificationsActiveOutlined,
              stampColor: AppColors.blush,
              title: 'Investigative Breaking Alerts',
              subtitle: 'Instant alerts for major global stories and science breakthroughs',
              value: breakingAlerts,
              onChanged: onBreakingAlertsChanged,
            ),
            SettingsActionTile(
              icon: AppIcons.volumeUpOutlined,
              stampColor: AppColors.mint,
              title: 'Audio Narration Cadence',
              subtitle: 'Speech synthesis voice for article reading',
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Warm Alto 1.0x', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  SizedBox(width: 4),
                  Icon(AppIcons.arrowForwardIosRounded, size: 12, color: AppColors.mutedInk),
                ],
              ),
              onTap: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Audio Narration set to Natural Warm Alto at 1.0x pace'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
