import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class ArticleEditWarningBanner extends StatelessWidget {
  final String message;

  const ArticleEditWarningBanner({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.redHighlight.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.redHighlight.withAlpha(80),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.redHighlight,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.redHighlight,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
