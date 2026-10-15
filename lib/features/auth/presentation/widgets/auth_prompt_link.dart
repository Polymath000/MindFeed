import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class AuthPromptLink extends StatelessWidget {
  const AuthPromptLink({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onTap,
  });

  final String promptText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            promptText,
            style: const TextStyle(
              color: AppColors.greyText,
              fontSize: 14,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              foregroundColor: AppColors.cream,
            ),
            onPressed: onTap,
            child: Text(
              actionText,
              style: const TextStyle(
                color: AppColors.cream,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
