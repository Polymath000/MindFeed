import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              await SharedPreferencesSingleton.setBool(
                isOnboardingSeenKey,
                value: true,
              );
              if (context.mounted) AppRoutes.login(context);
            },
            child: Text(
              'Skip',
              style: AppTextStyles.bodyLarge!.copyWith(
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
