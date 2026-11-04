import 'package:flutter/material.dart';

import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_dialogs.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_footer.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_tile_primitives.dart';

class SettingsArchiveSection extends StatelessWidget {
  final double cachedMegabytes;
  final VoidCallback onClearCache;
  final String userEmail;
  final VoidCallback onSignOut;

  const SettingsArchiveSection({
    super.key,
    required this.cachedMegabytes,
    required this.onClearCache,
    required this.userEmail,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SettingsSectionBlock(
          title: 'Library & Cache Storage',
          kicker: 'OFFLINE ARCHIVE',
          children: [
            SettingsActionTile(
              icon: AppIcons.inventory2Outlined,
              stampColor: AppColors.sand,
              title: 'Offline Reading Archive',
              subtitle: '${cachedMegabytes.toStringAsFixed(1)} MB cached articles',
              trailing: TextButton(
                onPressed: cachedMegabytes > 0 ? onClearCache : null,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  backgroundColor: AppColors.sandLight,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  cachedMegabytes > 0 ? 'Clear Cache' : 'Cleared',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        SettingsSectionBlock(
          title: 'Journal Account & Ethics',
          kicker: 'JOURNAL & PRIVACY',
          children: [
            SettingsActionTile(
              icon: AppIcons.lock,
              stampColor: AppColors.lilac,
              title: 'Change Password',
              subtitle: 'Update your account access passphrase',
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.changePassword,
                arguments: {
                  'email': userEmail,
                  'isFromSettings': true,
                },
              ),
            ),
            SettingsActionTile(
              icon: AppIcons.shieldOutlined,
              stampColor: AppColors.mint,
              title: 'Editorial Ethics & Privacy Charter',
              subtitle: 'MindFeed independent journalism charter and zero-tracker guarantee',
              onTap: () => showPrivacyManifestDialog(context),
            ),
            SettingsActionTile(
              icon: AppIcons.logout,
              stampColor: AppColors.blush,
              title: 'Sign Out of Edition',
              subtitle: 'End active session on this device',
              onTap: onSignOut,
            ),
          ],
        ),
        const SettingsFooter(),
      ],
    );
  }
}
