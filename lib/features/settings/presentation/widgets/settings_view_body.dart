import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_menu.dart';
import 'package:mind_feed/features/settings/presentation/widgets/theme_widget.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  String _displayName = 'Wade Warren';
  String _userEmail = 'reader@mindfeed.app';
  String? _avatarUrl;
  String _fontScale = 'Standard';
  bool _serifMode = true;
  bool _bionicGuide = false;
  bool _morningBriefing = true;
  bool _breakingAlerts = true;
  bool _dataPreservation = false;
  bool _wifiOnly = true;
  double _cachedMegabytes = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStoredPreferences();
    _loadUserData();
  }

  void _safeSetBool(String key, bool value) {
    try {
      SharedPreferencesSingleton.setBool(key, value: value);
    } catch (_) {}
  }

  void _safeSetString(String key, String value) {
    try {
      SharedPreferencesSingleton.setString(key, value);
    } catch (_) {}
  }

  void _loadStoredPreferences() {
    try {
      setState(() {
        _fontScale = SharedPreferencesSingleton.getString('pref_font_scale') ?? 'Standard';
        _serifMode = SharedPreferencesSingleton.getBool('pref_serif_mode') ?? true;
        _bionicGuide = SharedPreferencesSingleton.getBool('pref_bionic_guide') ?? false;
        _morningBriefing = SharedPreferencesSingleton.getBool('pref_morning_briefing') ?? true;
        _breakingAlerts = SharedPreferencesSingleton.getBool('pref_breaking_alerts') ?? true;
        _dataPreservation = SharedPreferencesSingleton.getBool('pref_data_preservation') ?? false;
        _wifiOnly = SharedPreferencesSingleton.getBool('pref_wifi_only') ?? true;
        _cachedMegabytes = 12.6;
      });
    } catch (_) {}
  }

  Future<void> _loadUserData() async {
    User? user;
    try {
      user = Supabase.instance.client.auth.currentUser;
    } catch (_) {}

    UserEntity? localUser;
    try {
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        localUser = Hive.box<UserEntity>(AppConstants.userKey).get(AppConstants.userKey);
      }
    } catch (_) {}

    final initialName = user?.userMetadata?['display_name'] as String? ??
        localUser?.userName ??
        (user?.email != null ? user!.email!.split('@').first : 'Wade Warren');
    final initialEmail = user?.email ?? localUser?.email ?? 'reader@mindfeed.app';

    if (mounted) {
      setState(() {
        _displayName = initialName;
        _userEmail = initialEmail;
      });
    }

    if (user != null && getIt.isRegistered<ProfileRepository>()) {
      try {
        final profileResult = await getIt<ProfileRepository>().getProfile(user.id);
        profileResult.when(
          success: (profile) {
            final remoteName = profile['display_name'] as String?;
            final remoteAvatar = profile['avatar_url'] as String?;
            if (mounted) {
              setState(() {
                if (remoteName != null && remoteName.isNotEmpty) {
                  _displayName = remoteName;
                }
                _avatarUrl = remoteAvatar;
              });
            }
          },
          failure: (_) {},
        );
      } catch (_) {}
    }
  }

  Future<void> _handleSignOut() async {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.whiteLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'Are you sure you want to sign out of MindFeed on this device?',
          style: TextStyle(
            color: AppColors.mutedInk,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.greyText),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.ink,
              foregroundColor: AppColors.cream,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              if (getIt.isRegistered<LogoutUseCase>()) {
                await getIt<LogoutUseCase>().call();
              }
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Signed out of MindFeed'),
                ),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleClearCache() async {
    if (getIt.isRegistered<ArticlesRepository>()) {
      await getIt<ArticlesRepository>().clearDownloadedArticles();
    }
    setState(() {
      _cachedMegabytes = 0.0;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Reading archive cache cleared'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.page,
            12,
            AppConstants.page,
            48,
          ),
          children: [
            Row(
              children: [
                EditorialIconButton(
                  icon: AppIcons.arrowBackRounded,
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
                          color: AppColors.mutedInk,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Settings & Preferences',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: AppColors.ink,
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
                      color: AppColors.cream,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _avatarUrl != null && _avatarUrl!.isNotEmpty
                          ? Image.network(
                              _avatarUrl!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.blush,
                                child: Icon(AppIcons.personAlt, color: AppColors.ink),
                              ),
                            )
                          : Image.asset(
                              Assets.assetsImagesWadeAvatar,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.blush,
                                child: Icon(AppIcons.personAlt, color: AppColors.ink),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _userEmail,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedInk,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
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
                    _safeSetString('pref_font_scale', val);
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
                  icon: AppIcons.menuBookOutlined,
                  stampColor: AppColors.lilac,
                  title: 'Serif Literary Immersion',
                  subtitle: 'Render longform stories in classic editorial serif typography',
                  value: _serifMode,
                  onChanged: (val) {
                    setState(() {
                      _serifMode = val;
                    });
                    _safeSetBool('pref_serif_mode', val);
                  },
                ),
                PaperSettingsSwitchTile(
                  icon: AppIcons.visibilityOutlined,
                  stampColor: AppColors.powder,
                  title: 'Bionic Reading Guide',
                  subtitle: 'Subtly emphasize key word anchors for swift reading pace',
                  value: _bionicGuide,
                  onChanged: (val) {
                    setState(() {
                      _bionicGuide = val;
                    });
                    _safeSetBool('pref_bionic_guide', val);
                  },
                ),
              ],
            ),
            PaperSettingsSection(
              title: 'Dispatches & Editorial Alerts',
              kicker: 'DISPATCHES',
              children: [
                PaperSettingsSwitchTile(
                  icon: AppIcons.wbSunnyOutlined,
                  stampColor: AppColors.butter,
                  title: 'Morning Edition Briefing',
                  subtitle: 'Curated 7:00 AM daily reading digest delivered quietly',
                  value: _morningBriefing,
                  onChanged: (val) {
                    setState(() {
                      _morningBriefing = val;
                    });
                    _safeSetBool('pref_morning_briefing', val);
                  },
                ),
                PaperSettingsSwitchTile(
                  icon: AppIcons.notificationsActiveOutlined,
                  stampColor: AppColors.blush,
                  title: 'Investigative Breaking Alerts',
                  subtitle: 'Instant alerts for major global stories and science breakthroughs',
                  value: _breakingAlerts,
                  onChanged: (val) {
                    setState(() {
                      _breakingAlerts = val;
                    });
                    _safeSetBool('pref_breaking_alerts', val);
                  },
                ),
                PaperSettingsTile(
                  icon: AppIcons.volumeUpOutlined,
                  stampColor: AppColors.mint,
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
                          color: AppColors.ink,
                        ),
                      ),
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
            PaperSettingsSection(
              title: 'Library & Cache Storage',
              kicker: 'OFFLINE ARCHIVE',
              children: [
                PaperSettingsTile(
                  icon: AppIcons.inventory2Outlined,
                  stampColor: AppColors.sand,
                  title: 'Offline Reading Archive',
                  subtitle: '${_cachedMegabytes.toStringAsFixed(1)} MB cached articles',
                  trailing: TextButton(
                    onPressed: _cachedMegabytes > 0 ? _handleClearCache : null,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.ink,
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
                  icon: AppIcons.networkCheckRounded,
                  stampColor: AppColors.powder,
                  title: 'Data Preservation Mode',
                  subtitle: 'Load compressed imagery when connected to cellular data',
                  value: _dataPreservation,
                  onChanged: (val) {
                    setState(() {
                      _dataPreservation = val;
                    });
                    _safeSetBool('pref_data_preservation', val);
                  },
                ),
                PaperSettingsSwitchTile(
                  icon: AppIcons.wifiRounded,
                  stampColor: AppColors.cream,
                  title: 'Download on Wi-Fi Only',
                  subtitle: 'Save high-fidelity offline articles only on Wi-Fi',
                  value: _wifiOnly,
                  onChanged: (val) {
                    setState(() {
                      _wifiOnly = val;
                    });
                    _safeSetBool('pref_wifi_only', val);
                  },
                ),
              ],
            ),
            PaperSettingsSection(
              title: 'Journal Account & Ethics',
              kicker: 'JOURNAL & PRIVACY',
              children: [
                PaperSettingsTile(
                  icon: AppIcons.lock,
                  stampColor: AppColors.lilac,
                  title: 'Change Password',
                  subtitle: 'Update your account access passphrase',
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.changePassword,
                    arguments: _userEmail,
                  ),
                ),
                PaperSettingsTile(
                  icon: AppIcons.shieldOutlined,
                  stampColor: AppColors.mint,
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
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '1. Zero Ad-Trackers: Your reading habits are never logged or auctioned to advertising exchanges.\n2. Verified Byline Integrity: Every piece is verified by human editors before syndication.\n3. Reader Sovereignty: Offline archives and cached journals remain entirely on your personal device.',
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.5,
                                color: AppColors.mutedInk,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.ink,
                                  foregroundColor: AppColors.cream,
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
                  icon: AppIcons.logout,
                  stampColor: AppColors.blush,
                  title: 'Sign Out of Edition',
                  subtitle: 'End active session on this device',
                  onTap: _handleSignOut,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
