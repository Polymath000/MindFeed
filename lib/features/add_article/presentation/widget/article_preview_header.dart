import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class ArticlePreviewHeader extends StatelessWidget {
  final EditorialNewsItem item;

  const ArticlePreviewHeader({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final hasCover =
        item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(context),
        const SizedBox(height: 20),
        if (hasCover) ...[
          _buildCoverImage(item.coverImageUrl!),
          const SizedBox(height: 20),
        ],
        Text(
          item.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            height: 1.25,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 16),
        _buildAuthorRow(),
        if (item.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildTagsWrap(),
        ],
        if (item.excerpt.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            item.excerpt,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedInk,
            ),
          ),
          const Divider(height: 36, thickness: 1, color: AppColors.creamBorder),
        ] else ...[
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          button: true,
          label: 'Back',
          child: InkResponse(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(AppIcons.arrowBackRounded, color: AppColors.ink, size: 22),
            ),
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.butter,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: const Text(
                'PREVIEW MODE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${item.readingTimeMinutes} min read',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.mutedInk),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoverImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        url,
        height: 240,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(20)),
          child: const Center(
            child: Icon(AppIcons.imageOutlined, size: 48, color: AppColors.ink),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorRow() {
    final hasRemoteAvatar = item.authorAvatar.startsWith('http') || item.authorAvatar.startsWith('https');

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.cream,
          backgroundImage: hasRemoteAvatar
              ? NetworkImage(item.authorAvatar)
              : const AssetImage(Assets.assetsImagesWadeAvatar) as ImageProvider,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.authorName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink),
            ),
            Text(
              item.updated.isNotEmpty ? item.updated : 'Draft',
              style: const TextStyle(fontSize: 12, color: AppColors.mutedInk),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: item.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.ink.withAlpha(40)),
          ),
          child: Text(
            '#$tag',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
          ),
        );
      }).toList(),
    );
  }
}
