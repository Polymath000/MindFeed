import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';

class SubtitleListtileOfArticleCard extends StatelessWidget {
  const SubtitleListtileOfArticleCard({
    super.key,
    required this.author,
    required this.date,
  });

  final String author;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          author,
          style: AppTextStyles.bodyLarge?.copyWith(
            color: AppColors.darkGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: AppTextStyles.bodyMedium?.copyWith(
            color: AppColors.darkGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
