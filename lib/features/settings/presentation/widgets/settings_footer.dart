import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/services/app_info_service.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final stamp =
        '${AppInfoService.appName.toUpperCase()} ${AppInfoService.formattedStamp} · VERIFIED JOURNALISM';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stamp,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.mutedInk,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Built for thoughtful and uninterrupted reading',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.mutedInk,
            ),
          ),
        ],
      ),
    );
  }
}
