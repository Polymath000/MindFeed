import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class ArticleReaderCoverImage extends StatelessWidget {
  const ArticleReaderCoverImage({super.key, this.coverImageUrl, this.overlay});

  final String? coverImageUrl;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final hasImage = coverImageUrl != null && coverImageUrl!.trim().isNotEmpty;
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
                  cacheWidth: 1080,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _placeholder(),
                )
              : _placeholder(),
        ),
        if (overlay != null) Positioned(right: 14, bottom: 14, child: overlay!),
      ],
    );
  }

  Widget _placeholder() => Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(12),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Icon(AppIcons.articleOutlined, size: 40, color: AppColors.mutedInk),
        ),
      );
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
            Text(updated, style: const TextStyle(color: AppColors.mutedInk, fontSize: 12.5, fontWeight: FontWeight.w500)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('•', style: TextStyle(color: AppColors.mutedInk))),
            Text('$readingTimeMinutes min read', style: const TextStyle(color: AppColors.mutedInk, fontSize: 12.5, fontWeight: FontWeight.w600)),
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
    this.authorRatingAvg = 0.0,
    this.authorRatingCount = 0,
    this.userAuthorStars = 0,
    this.onRateAuthor,
  });

  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final double authorRatingAvg;
  final int authorRatingCount;
  final int userAuthorStars;
  final ValueChanged<int>? onRateAuthor;

  @override
  Widget build(BuildContext context) {
    final activeThreshold = userAuthorStars > 0 ? userAuthorStars : authorRatingAvg.round();
    final summaryText = authorRatingCount > 0
        ? '${authorRatingAvg.toStringAsFixed(1)} ($authorRatingCount ${authorRatingCount == 1 ? 'rating' : 'ratings'})${userAuthorStars > 0 ? ' • You: $userAuthorStars★' : ''}'
        : 'Rate this author (1–5★)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(child: _buildAvatar()),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(authorRole, style: const TextStyle(fontSize: 11, color: AppColors.mutedInk, fontWeight: FontWeight.w500)),
                  Text(authorName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink)),
                ],
              ),
            ),
            EditorialFollowButton(authorName: authorName),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 1; i <= 5; i++)
                  Semantics(
                    button: true,
                    label: 'Rate author $i stars',
                    child: InkResponse(
                      key: Key('author_star_$i'),
                      onTap: () => onRateAuthor?.call(i),
                      radius: 16,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),
                        child: Icon(
                          i <= activeThreshold ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: i <= activeThreshold ? Colors.amber[700] : AppColors.mutedInk,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                summaryText,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.mutedInk),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (authorAvatar.isEmpty) return _avatarFallback();
    if (authorAvatar.startsWith('http')) {
      return Image.network(
        authorAvatar,
        width: 40,
        height: 40,
        cacheWidth: 120,
        cacheHeight: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _avatarFallback(),
      );
    }
    return Image.asset(
      authorAvatar,
      width: 40,
      height: 40,
      cacheWidth: 120,
      cacheHeight: 120,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _avatarFallback(),
    );
  }

  Widget _avatarFallback() => const CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.blush,
        child: Icon(AppIcons.personAlt, color: AppColors.ink),
      );
}
