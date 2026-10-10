import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class ArticleCardOfAuthor extends StatelessWidget {
  const ArticleCardOfAuthor({
    super.key,
    required this.title,
    required this.imagePath,
    this.isDwonload = false,
    this.isFav = false,
  });

  final String title;
  final String imagePath;
  final bool isDwonload;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppRoutes.article,
      borderRadius: AppBorders.card,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: AppBorders.card,
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 90,
                  height: 90,
                  color: AppColors.cream,
                  child: const Icon(
                    AppIcons.articleOutlined,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.softCream,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFav
                              ? AppIcons.bookmark
                              : AppIcons.bookmarkBorderRounded,
                          size: 18,
                          color: AppColors.softCream,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          AppIcons.iosShareRounded,
                          size: 18,
                          color: AppColors.softCream,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
