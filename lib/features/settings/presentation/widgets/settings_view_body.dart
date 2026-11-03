import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
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
            const SettingsHeaderBanner(),
            const SizedBox(height: 18),
            _buildAccountCard(),
            const SizedBox(height: 24),
            _buildReadingSection(context),
            _buildArchiveSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return BlocSelector<SettingsCubit, SettingsState, (String, String, String?)>(
      selector: (state) => (state.displayName, state.userEmail, state.avatarUrl),
      builder: (context, data) {
        final (displayName, userEmail, avatarUrl) = data;
        return SettingsAccountCard(
          displayName: displayName,
          userEmail: userEmail,
          avatarUrl: avatarUrl,
        );
      },
    );
  }

  Widget _buildReadingSection(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, (String, bool, UserEntity?)>(
      selector: (state) => (state.fontScale, state.serifMode, state.currentUserEntity),
      builder: (context, data) {
        final (fontScale, serifMode, userEntity) = data;
        final cubit = context.read<SettingsCubit>();
        return SettingsReadingSection(
          fontScale: fontScale,
          onFontScaleChanged: (val) => _onFontScaleChanged(context, cubit, val),
          serifMode: serifMode,
          onSerifModeChanged: cubit.setSerifMode,
          onTapPreferredCategories: () => _openPreferredCategories(
            context,
            cubit,
            userEntity,
          ),
        );
      },
    );
  }

  void _onFontScaleChanged(
    BuildContext context,
    SettingsCubit cubit,
    String val,
  ) {
    cubit.setFontScale(val);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text('Typography scale set to $val'),
      ),
    );
  }

  Future<void> _openPreferredCategories(
    BuildContext context,
    SettingsCubit cubit,
    UserEntity? userEntity,
  ) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.categories,
      arguments: {'user': userEntity, 'isFromSettings': true},
    );
    if (context.mounted) {
      cubit.loadUserData();
    }
  }

  Widget _buildArchiveSection(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, (double, String)>(
      selector: (state) => (state.cachedMegabytes, state.userEmail),
      builder: (context, data) {
        final (cachedMegabytes, userEmail) = data;
        return SettingsArchiveSection(
          cachedMegabytes: cachedMegabytes,
          onClearCache: () => _handleClearCache(context),
          userEmail: userEmail,
          onSignOut: () => _handleSignOut(context),
        );
      },
    );
  }
}
