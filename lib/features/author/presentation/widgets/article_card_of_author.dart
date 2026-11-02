import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class ArticleCardOfAuthor extends StatelessWidget {
  final EditorialNewsItem item;
  final VoidCallback? onTap;

  const ArticleCardOfAuthor({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: item.title,
      child: InkWell(
        onTap: onTap ??
            () => Navigator.pushNamed(
                  context,
                  AppRoutes.article,
                  arguments: item,
                ),
        borderRadius: AppBorders.card,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: AppBorders.card,
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopMetaRow(),
              const SizedBox(height: 12),
              _buildMainBodyRow(),
              const SizedBox(height: 14),
              _buildFooterRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopMetaRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: item.badgeColor,
            borderRadius: AppBorders.tag,
          ),
          child: Text(
            item.badge,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.updated,
          style: AppTextStyles.authorCardMeta,
        ),
        const Text(
          ' • ',
          style: AppTextStyles.authorCardMeta,
        ),
        Text(
          '${item.readingTimeMinutes} min read',
          style: AppTextStyles.authorCardMeta,
        ),
      ],
    );
  }

  Widget _buildMainBodyRow() {
    final hasCoverImage =
        item.coverImageUrl != null && item.coverImageUrl!.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title.replaceAll('\n', ' '),
                style: AppTextStyles.authorCardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                item.excerpt,
                style: AppTextStyles.authorCardExcerpt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (hasCoverImage) ...[
          const SizedBox(width: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.coverImageUrl!.trim(),
              width: 76,
              height: 76,
              cacheWidth: 228,
              cacheHeight: 228,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 76,
                height: 76,
                color: AppColors.inkDark,
                child: const Icon(
                  Icons.article_outlined,
                  color: AppColors.greyText,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooterRow() {
    return Row(
      children: [
        if (item.tags.isNotEmpty)
          Expanded(
            child: Wrap(
              spacing: 8,
              children: item.tags.take(3).map((tag) {
                final formatted = tag.startsWith('#') ? tag : '#$tag';
                return Text(
                  formatted,
                  style: AppTextStyles.authorCardTag,
                );
              }).toList(),
            ),
          )
        else
          const Spacer(),
        const Text(
          'Read →',
          style: AppTextStyles.authorCardReadCue,
        ),
      ],
    );
  }
}
