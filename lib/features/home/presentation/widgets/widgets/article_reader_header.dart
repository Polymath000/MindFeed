import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class ArticleReaderCoverImage extends StatelessWidget {
  const ArticleReaderCoverImage({
    super.key,
    this.coverImageUrl,
    this.overlay,
  });

  final String? coverImageUrl;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final hasImage =
        coverImageUrl != null && coverImageUrl!.trim().isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: hasImage
              ? Image.network(
                  coverImageUrl!,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildPlaceholderCover(),
                )
              : _buildPlaceholderCover(),
        ),
        if (overlay != null)
          Positioned(
            right: 14,
            bottom: 14,
            child: overlay!,
          ),
      ],
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Icon(
          AppIcons.articleOutlined,
          size: 40,
          color: AppColors.mutedInk,
        ),
      ),
    );
  }
}

class ArticleReaderMetadataHeader extends StatelessWidget {
  const ArticleReaderMetadataHeader({
    super.key,
    required this.title,
    required this.updated,
    required this.readingTimeMinutes,
  });

  final String title;
  final String updated;
  final int readingTimeMinutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.replaceAll('\n', ' '),
          style: const TextStyle(
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              updated,
              style: const TextStyle(
                color: AppColors.mutedInk,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '•',
                style: TextStyle(color: AppColors.mutedInk),
              ),
            ),
            Text(
              '$readingTimeMinutes min read',
              style: const TextStyle(
                color: AppColors.mutedInk,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ArticleReaderAuthorBar extends StatelessWidget {
  const ArticleReaderAuthorBar({
    super.key,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
  });

  final String authorName;
  final String authorRole;
  final String authorAvatar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: authorAvatar.isNotEmpty
              ? (authorAvatar.startsWith('http')
                  ? Image.network(
                      authorAvatar,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildAvatarFallback(),
                    )
                  : Image.asset(
                      authorAvatar,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildAvatarFallback(),
                    ))
              : _buildAvatarFallback(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorRole,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.mutedInk,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                authorName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
        EditorialFollowButton(authorName: authorName),
      ],
    );
  }

  Widget _buildAvatarFallback() {
    return const CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.blush,
      child: Icon(AppIcons.personAlt, color: AppColors.ink),
    );
  }
}
