import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';

class ArticleCardInformation extends StatelessWidget {
  const ArticleCardInformation({
    super.key,
    required this.title,
    required this.author,
    required this.date,
  });

  final String title;
  final String author;
  final String date;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).height * 0.3,
          child: Text(
            title,
            style: AppTextStyles.titleLarge?.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          author,
          style: AppTextStyles.bodyLarge?.copyWith(
            color: isDark ? AppColors.grey : AppColors.darkGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          date,
          style: AppTextStyles.bodyMedium?.copyWith(
            color: isDark ? AppColors.grey : AppColors.darkGrey,
          ),
        ),
      ],
    );
  }
}
