import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/editorial_avatar.dart';

class SettingsHeaderBanner extends StatelessWidget {
  const SettingsHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class SettingsAccountCard extends StatelessWidget {
  final String displayName;
  final String userEmail;
  final String? avatarUrl;

  const SettingsAccountCard({
    super.key,
    required this.displayName,
    required this.userEmail,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: EditorialAvatar(
              avatarUrl: avatarUrl,
              size: 44,
              fallbackName: displayName,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName.isNotEmpty
                      ? displayName
                      : (userEmail.isNotEmpty ? userEmail : 'Reader'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: -0.3,
                  ),
                ),
                if (userEmail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedInk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
    );
  }
}
