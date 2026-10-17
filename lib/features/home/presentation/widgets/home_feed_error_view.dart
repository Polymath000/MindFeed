import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';

class HomeFeedErrorView extends StatelessWidget {
  const HomeFeedErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                AppIcons.wifiOffRounded,
                color: AppColors.softCream,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.homeErrorMessage,
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonText: 'Retry',
                onTap: onRetry,
                width: 140,
                height: 44,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
