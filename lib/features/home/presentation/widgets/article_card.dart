import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/constants/borders.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.title,
    required this.author,
    required this.date,
    required this.imagePath,
  });
  final String title;
  final String author;
  final String date;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.lightGray,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.grey),
          borderRadius: AppBorders.xxxs,
        ),
      ),
      child: Column(
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: AppBorders.xxxs,
                side: BorderSide(width: 1, color: AppColors.grey),
              ),
            ),
            child: Image(image: AssetImage(imagePath)),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(12),
            tileColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              title,
              style: AppTextStyles.titleLarge?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  author,
                  style: AppTextStyles.bodyLarge?.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: AppTextStyles.bodyMedium?.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            trailing: Column(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                Spacer(),
                Icon(Icons.more_vert, color: AppColors.gunmetal),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
