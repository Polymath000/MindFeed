import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/widgets/article_card_layout.dart';

typedef ProfileArticleCard = EditableProfileArticleCard;
typedef CustomArticleCardOfProfile = EditableProfileArticleCard;

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.item});

  final EditorialNewsItem item;

  @override
  Widget build(BuildContext context) {
    return ArticleCardLayout(
      item: item,
      actions: [
        IconButton(
          icon: const Icon(
            AppIcons.iosShareRounded,
            size: 18,
            color: AppColors.ink,
          ),
          tooltip: 'Share article',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share link copied to clipboard')),
            );
          },
        ),
      ],
    );
  }
}

class EditableProfileArticleCard extends StatelessWidget {
  const EditableProfileArticleCard({
    super.key,
    required this.item,
    this.onDelete,
    this.onEdit,
  });

  final EditorialNewsItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (!item.isEditableWithinWindow) {
      actions.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.lock, size: 14, color: AppColors.greyText),
              SizedBox(width: 4),
              Text(
                'Archived · locked',
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (item.isEditableWithinWindow) {
      actions.add(
        IconButton(
          icon: const Icon(AppIcons.edit, size: 18, color: AppColors.ink),
          tooltip: 'Edit article',
          onPressed:
              onEdit ??
              () => Navigator.pushNamed(
                context,
                AppRoutes.addArticle,
                arguments: item,
              ),
        ),
      );
      actions.add(
        IconButton(
          icon: const Icon(AppIcons.delete, size: 18, color: AppColors.ink),
          tooltip: 'Delete article',
          onPressed: onDelete,
        ),
      );
    }
    actions.add(
      IconButton(
        icon: const Icon(
          AppIcons.iosShareRounded,
          size: 18,
          color: AppColors.ink,
        ),
        tooltip: 'Share article',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Share link copied to clipboard')),
          );
        },
      ),
    );
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return ArticleCardLayout(item: item, actions: _buildActions(context));
  }
}
