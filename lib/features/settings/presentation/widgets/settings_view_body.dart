import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_menu.dart';
import 'package:mind_feed/features/settings/presentation/widgets/theme_widget.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  String _fontScale = 'Standard';
  bool _serifMode = true;
  bool _bionicGuide = false;
  bool _morningBriefing = true;
  bool _breakingAlerts = true;
  bool _dataPreservation = false;
  bool _wifiOnly = true;
  double _cachedMegabytes = 18.4;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            EditorialSpace.page,
            12,
            EditorialSpace.page,
            48,
          ),
          children: [
            Row(
              children: [
                EditorialIconButton(
                  icon: Icons.arrow_back_rounded,
                  label: 'Back',
                  onPressed: () => Navigator.maybePop(context),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'MIND FEED JOURNAL // EDITION 2026',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: EditorialPalette.mutedInk,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Settings & Preferences',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: EditorialPalette.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteLight,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.creamBorder, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.transparentDark,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: EditorialPalette.cream,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        Assets.assetsImagesWadeAvatar,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const CircleAvatar(
                          radius: 22,
                          backgroundColor: EditorialPalette.blush,
                          child: Icon(Icons.person, color: EditorialPalette.ink),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Wade Warren',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: EditorialPalette.ink,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Editorial Reader • MindFeed Edition',
                          style: TextStyle(
                            fontSize: 12,
                            color: EditorialPalette.mutedInk,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: EditorialPalette.mint,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.mintDark),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.greenDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PaperSettingsSection(
              title: 'Reading Experience & Surface',
              kicker: 'CANVAS & TYPE',
              children: [
                const ThemeWidget(),
                PaperSegmentedOptions<String>(
                  title: 'Typeface Scale',
                  subtitle: 'Adjust comfortable body sizing for reading long articles',
                  options: const ['Compact', 'Standard', 'Editorial', 'Large'],
                  selectedOption: _fontScale,
                  onChanged: (val) {
                    setState(() {
                      _fontScale = val;
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text('Typography scale set to $val'),
                      ),
                    );
                  },
                  labelBuilder: (s) => s,
                ),
                PaperSettingsSwitchTile(
                  icon: Icons.menu_book_outlined,
                  stampColor: EditorialPalette.lilac,
                  title: 'Serif Literary Immersion',
                  subtitle: 'Render longform stories in classic editorial serif typography',
                  value: _serifMode,
                  onChanged: (val) {
                    setState(() {
                      _serifMode = val;
                    });
                  },
                ),
                PaperSettingsSwitchTile(
                  icon: Icons.visibility_outlined,
                  stampColor: EditorialPalette.powder,
                  title: 'Bionic Reading Guide',
                  subtitle: 'Subtly emphasize key word anchors for swift reading pace',
                  value: _bionicGuide,
                  onChanged: (val) {
                    setState(() {
                      _bionicGuide = val;
                    });
                  },
                ),
              ],
            ),
            PaperSettingsSection(
              title: 'Dispatches & Editorial Alerts',
              kicker: 'DISPATCHES',
              children: [
                PaperSettingsSwitchTile(
                  icon: Icons.wb_sunny_outlined,
                  stampColor: EditorialPalette.butter,
                  title: 'Morning Edition Briefing',
                  subtitle: 'Curated 7:00 AM daily reading digest delivered quietly',
                  value: _morningBriefing,
                  onChanged: (val) {
                    setState(() {
                      _morningBriefing = val;
                    });
                  },
                ),
                PaperSettingsSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  stampColor: EditorialPalette.blush,
                  title: 'Investigative Breaking Alerts',
                  subtitle: 'Instant alerts for major global stories and science breakthroughs',
                  value: _breakingAlerts,
                  onChanged: (val) {
                    setState(() {
                      _breakingAlerts = val;
                    });
                  },
                ),
                PaperSettingsTile(
                  icon: Icons.volume_up_outlined,
                  stampColor: EditorialPalette.mint,
                  title: 'Audio Narration Cadence',
                  subtitle: 'Speech synthesis voice for article reading',
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Warm Alto 1.0x',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: EditorialPalette.ink,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded, size: 12, color: EditorialPalette.mutedInk),
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
            PaperSettingsSection(
              title: 'Library & Cache Storage',
              kicker: 'OFFLINE ARCHIVE',
              children: [
                PaperSettingsTile(
                  icon: Icons.inventory_2_outlined,
                  stampColor: EditorialPalette.sand,
                  title: 'Offline Reading Archive',
                  subtitle: '${_cachedMegabytes.toStringAsFixed(1)} MB cached across 14 articles',
                  trailing: TextButton(
                    onPressed: _cachedMegabytes > 0
                        ? () {
                            setState(() {
                              _cachedMegabytes = 0.0;
                            });
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('Reading cache cleared (18.4 MB freed)'),
                              ),
                            );
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: EditorialPalette.ink,
                      backgroundColor: AppColors.sandLight,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _cachedMegabytes > 0 ? 'Clear Cache' : 'Cleared',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                PaperSettingsSwitchTile(
                  icon: Icons.network_check_rounded,
                  stampColor: EditorialPalette.powder,
                  title: 'Data Preservation Mode',
                  subtitle: 'Load compressed imagery when connected to cellular data',
                  value: _dataPreservation,
                  onChanged: (val) {
                    setState(() {
                      _dataPreservation = val;
                    });
                  },
                ),
                PaperSettingsSwitchTile(
                  icon: Icons.wifi_rounded,
                  stampColor: EditorialPalette.cream,
                  title: 'Download on Wi-Fi Only',
                  subtitle: 'Save high-fidelity offline articles only on Wi-Fi',
                  value: _wifiOnly,
                  onChanged: (val) {
                    setState(() {
                      _wifiOnly = val;
                    });
                  },
                ),
              ],
            ),
            PaperSettingsSection(
              title: 'Journal Account & Ethics',
              kicker: 'JOURNAL & PRIVACY',
              children: [
                PaperSettingsTile(
                  icon: Icons.lock_outline_rounded,
                  stampColor: EditorialPalette.lilac,
                  title: 'Change Password',
                  subtitle: 'Update your account access passphrase',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword, arguments: 'wade@mindfeed.app'),
                ),
                PaperSettingsTile(
                  icon: Icons.shield_outlined,
                  stampColor: EditorialPalette.mint,
                  title: 'Editorial Ethics & Privacy Charter',
                  subtitle: 'MindFeed independent journalism charter and zero-tracker guarantee',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: AppColors.whiteLight,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MindFeed Editorial Charter',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: EditorialPalette.ink,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '1. Zero Ad-Trackers: Your reading habits are never logged or auctioned to advertising exchanges.\n2. Verified Byline Integrity: Every piece is verified by human editors before syndication.\n3. Reader Sovereignty: Offline archives and cached journals remain entirely on your personal device.',
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.5,
                                color: EditorialPalette.mutedInk,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: EditorialPalette.ink,
                                  foregroundColor: EditorialPalette.cream,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Understood'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                PaperSettingsTile(
                  icon: Icons.logout_rounded,
                  stampColor: EditorialPalette.blush,
                  title: 'Sign Out of Edition',
                  subtitle: 'End active session on this device',
                  onTap: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Signed out of MindFeed Edition'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
