import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_dialogs.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_tile_primitives.dart';

class SettingsArchiveSection extends StatelessWidget {
  final double cachedMegabytes;
  final VoidCallback onClearCache;
  final bool dataPreservation;
  final ValueChanged<bool> onDataPreservationChanged;
  final bool wifiOnly;
  final ValueChanged<bool> onWifiOnlyChanged;
  final String userEmail;
  final VoidCallback onSignOut;

  const SettingsArchiveSection({
    super.key,
    required this.cachedMegabytes,
    required this.onClearCache,
    required this.dataPreservation,
    required this.onDataPreservationChanged,
    required this.wifiOnly,
    required this.onWifiOnlyChanged,
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
            SettingsToggleTile(
              icon: AppIcons.networkCheckRounded,
              stampColor: AppColors.powder,
              title: 'Data Preservation Mode',
              subtitle: 'Load compressed imagery when connected to cellular data',
              value: dataPreservation,
              onChanged: onDataPreservationChanged,
            ),
            SettingsToggleTile(
              icon: AppIcons.wifiRounded,
              stampColor: AppColors.cream,
              title: 'Download on Wi-Fi Only',
              subtitle: 'Save high-fidelity offline articles only on Wi-Fi',
              value: wifiOnly,
              onChanged: onWifiOnlyChanged,
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
                arguments: userEmail,
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MINDFEED v2.4 · VERIFIED JOURNALISM',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.mutedInk,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Built for thoughtful and uninterrupted reading',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.mutedInk,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
