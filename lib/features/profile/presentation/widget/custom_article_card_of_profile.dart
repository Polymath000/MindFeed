import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class CustomArticleCardOfProfile extends StatelessWidget {
  const CustomArticleCardOfProfile({
    super.key,
    required this.item,
    this.onDelete,
  });

  final EditorialNewsItem item;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: AppBorders.card,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.article, arguments: item),
        borderRadius: AppBorders.card,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    item.updated,
                    style: const TextStyle(
                      color: AppColors.mutedInk,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.title.replaceAll('\n', ' '),
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  color: AppColors.ink,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                item.excerpt,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.ink,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(AppIcons.edit, size: 18, color: AppColors.ink),
                    tooltip: 'Edit article',
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(AppIcons.delete, size: 18, color: AppColors.ink),
                    tooltip: 'Delete article',
                    onPressed: onDelete,
                  ),
                  IconButton(
                    icon: const Icon(AppIcons.iosShareRounded, size: 18, color: AppColors.ink),
                    tooltip: 'Share article',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share link copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
