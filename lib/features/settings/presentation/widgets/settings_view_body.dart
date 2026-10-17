import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/home/data/datasources/articles_local_data_source.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_account_card.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_archive_section.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_dialogs.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_reading_section.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  String _displayName = '', _userEmail = '', _fontScale = 'Standard';
  UserEntity? _currentUserEntity;
  String? _avatarUrl;
  bool _serifMode = true, _bionicGuide = false, _morningBriefing = true;
  bool _breakingAlerts = true, _dataPreservation = false, _wifiOnly = true;
  double _cachedMegabytes = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadUserData();
    _loadCacheSize();
  }

  void _loadPreferences() {
    try {
      setState(() {
        _fontScale = SharedPreferencesSingleton.getString('pref_font_scale') ?? 'Standard';
        _serifMode = SharedPreferencesSingleton.getBool('pref_serif_mode') ?? true;
        _bionicGuide = SharedPreferencesSingleton.getBool('pref_bionic_guide') ?? false;
        _morningBriefing = SharedPreferencesSingleton.getBool('pref_morning_briefing') ?? true;
        _breakingAlerts = SharedPreferencesSingleton.getBool('pref_breaking_alerts') ?? true;
        _dataPreservation = SharedPreferencesSingleton.getBool('pref_data_preservation') ?? false;
        _wifiOnly = SharedPreferencesSingleton.getBool('pref_wifi_only') ?? true;
      });
    } catch (_) {}
  }

  void _setBool(String k, bool v, void Function(bool) fn) => setState(() { fn(v); SharedPreferencesSingleton.setBool(k, value: v); });

  Future<void> _loadCacheSize() async {
    try {
      if (getIt.isRegistered<ArticlesLocalDataSource>()) {
        final articles = await getIt<ArticlesLocalDataSource>().getDownloadedArticles();
        final bytes = articles.fold(0, (acc, item) => acc + item.title.length + item.content.length + item.excerpt.length);
        if (mounted) setState(() => _cachedMegabytes = bytes / (1024 * 1024));
      }
    } catch (_) {}
  }

  Future<void> _loadUserData() async {
    final session = CurrentUserSession.resolveCurrentUser();
    final local = CurrentUserSession.resolveCachedUserEntity();
    final email = session?.email ?? local?.email ?? '';
    if (mounted) {
      setState(() {
        _displayName = session?.displayName ?? local?.userName ?? (session?.email?.split('@').first ?? '');
        _userEmail = email;
        _avatarUrl = session?.avatarUrl;
        _currentUserEntity = local;
      });
    }
    final userId = session?.id;
    if (userId != null && getIt.isRegistered<ProfileRepository>()) {
      try {
        final profile = await getIt<ProfileRepository>().getProfile(userId);
        profile.when(success: (data) {
          final rName = data['display_name'] as String?, rAvatar = data['avatar_url'] as String?;
          if (mounted && (rName != null || rAvatar != null)) {
            setState(() {
              if (rName != null && rName.isNotEmpty) _displayName = rName;
              if (rAvatar != null) _avatarUrl = rAvatar;
            });
          }
        }, failure: (_) {});
        final favs = await getIt<ProfileRepository>().getFavoriteCategories(userId);
        favs.when(success: (list) {
          final cats = list.map((m) => (m['name'] ?? m['category_name'] ?? '').toString()).where((s) => s.isNotEmpty).toList();
          if (mounted) setState(() => _currentUserEntity = (_currentUserEntity ?? UserEntity(favoriteCategories: cats, email: email, userName: _displayName, token: null)).copyWith(categories: cats));
        }, failure: (_) {});
      } catch (_) {}
    }
  }

  Future<void> _handleSignOut() async => showSignOutDialog(context, () async {
        if (getIt.isRegistered<LogoutUseCase>()) await getIt<LogoutUseCase>().call();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(seconds: 2), content: Text('Signed out of MindFeed')));
      });

  Future<void> _handleClearCache() async {
    if (getIt.isRegistered<ArticlesRepository>()) await getIt<ArticlesRepository>().clearDownloadedArticles();
    if (!mounted) return;
    setState(() => _cachedMegabytes = 0.0);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(seconds: 2), content: Text('Reading archive cache cleared')));
  }

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppConstants.page, 12, AppConstants.page, 48),
            children: [
              const SettingsHeaderBanner(),
              const SizedBox(height: 18),
              SettingsAccountCard(displayName: _displayName, userEmail: _userEmail, avatarUrl: _avatarUrl),
              const SizedBox(height: 24),
              SettingsReadingSection(
                fontScale: _fontScale,
                onFontScaleChanged: (val) {
                  setState(() => _fontScale = val);
                  SharedPreferencesSingleton.setString('pref_font_scale', val);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: Text('Typography scale set to $val')));
                },
                serifMode: _serifMode,
                onSerifModeChanged: (v) => _setBool('pref_serif_mode', v, (val) => _serifMode = val),
                bionicGuide: _bionicGuide,
                onBionicGuideChanged: (v) => _setBool('pref_bionic_guide', v, (val) => _bionicGuide = val),
                onTapPreferredCategories: () async {
                  await Navigator.pushNamed(context, AppRoutes.categories, arguments: _currentUserEntity);
                  if (mounted) _loadUserData();
                },
                morningBriefing: _morningBriefing,
                onMorningBriefingChanged: (v) => _setBool('pref_morning_briefing', v, (val) => _morningBriefing = val),
                breakingAlerts: _breakingAlerts,
                onBreakingAlertsChanged: (v) => _setBool('pref_breaking_alerts', v, (val) => _breakingAlerts = val),
              ),
              SettingsArchiveSection(
                cachedMegabytes: _cachedMegabytes,
                onClearCache: _handleClearCache,
                dataPreservation: _dataPreservation,
                onDataPreservationChanged: (v) => _setBool('pref_data_preservation', v, (val) => _dataPreservation = val),
                wifiOnly: _wifiOnly,
                onWifiOnlyChanged: (v) => _setBool('pref_wifi_only', v, (val) => _wifiOnly = val),
                userEmail: _userEmail,
                onSignOut: _handleSignOut,
              ),
            ],
          ),
        ),
      );
}
