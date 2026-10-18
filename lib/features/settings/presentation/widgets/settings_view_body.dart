import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_account_card.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_archive_section.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_dialogs.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_reading_section.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    return showSignOutDialog(context, () async {
      await context.read<SettingsCubit>().signOut();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Signed out of MindFeed'),
        ),
      );
    });
  }

  Future<void> _handleClearCache(BuildContext context) async {
    await context.read<SettingsCubit>().clearCache();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Reading archive cache cleared'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppConstants.page, 12, AppConstants.page, 48),
              children: [
                const SettingsHeaderBanner(),
                const SizedBox(height: 18),
                SettingsAccountCard(
                  displayName: state.displayName,
                  userEmail: state.userEmail,
                  avatarUrl: state.avatarUrl,
                ),
                const SizedBox(height: 24),
                SettingsReadingSection(
                  fontScale: state.fontScale,
                  onFontScaleChanged: (val) {
                    cubit.setFontScale(val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text('Typography scale set to $val'),
                      ),
                    );
                  },
                  serifMode: state.serifMode,
                  onSerifModeChanged: cubit.setSerifMode,
                  bionicGuide: state.bionicGuide,
                  onBionicGuideChanged: cubit.setBionicGuide,
                  onTapPreferredCategories: () async {
                    await Navigator.pushNamed(
                      context,
                      AppRoutes.categories,
                      arguments: state.currentUserEntity,
                    );
                    if (context.mounted) {
                      cubit.loadUserData();
                    }
                  },
                  morningBriefing: state.morningBriefing,
                  onMorningBriefingChanged: cubit.setMorningBriefing,
                  breakingAlerts: state.breakingAlerts,
                  onBreakingAlertsChanged: cubit.setBreakingAlerts,
                ),
                SettingsArchiveSection(
                  cachedMegabytes: state.cachedMegabytes,
                  onClearCache: () => _handleClearCache(context),
                  dataPreservation: state.dataPreservation,
                  onDataPreservationChanged: cubit.setDataPreservation,
                  wifiOnly: state.wifiOnly,
                  onWifiOnlyChanged: cubit.setWifiOnly,
                  userEmail: state.userEmail,
                  onSignOut: () => _handleSignOut(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
