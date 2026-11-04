import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/design/editorial_shimmer.dart';
import 'package:mind_feed/features/author/presentation/widgets/article_card_of_author.dart';

class AuthorLoadingView extends StatelessWidget {
  const AuthorLoadingView({super.key});

  static final List<EditorialNewsItem> _placeholderArticles = [
    EditorialNewsItem(
      id: 'author_skeleton_1',
      badge: 'PERSPECTIVE',
      badgeColor: AppColors.black,
      title:
          'Architectures of tomorrow: Designing robust foundations for modern thought',
      updated: 'Just now',
      authorName: 'Columnist',
      authorRole: 'Editorial Fellow',
      authorAvatar: '',
      excerpt:
          'Deep explorations into foundational principles, examining the forces shaping contemporary culture and intellect.',
      color: AppColors.charcoal,
      coverImageUrl: null,
      readingTimeMinutes: 5,
      tags: const ['Architecture', 'Design'],
    ),
    EditorialNewsItem(
      id: 'author_skeleton_2',
      badge: 'ANALYSIS',
      badgeColor: AppColors.black,
      title:
          'The mechanics of inquiry: How focused research accelerates comprehension',
      updated: 'Moments ago',
      authorName: 'Columnist',
      authorRole: 'Editorial Fellow',
      authorAvatar: '',
      excerpt:
          'A reflective synthesis on emerging methodologies, investigative rigor, and the synthesis of complex ideas.',
      color: AppColors.charcoal,
      coverImageUrl: null,
      readingTimeMinutes: 4,
      tags: const ['Research', 'Methodology'],
    ),
    EditorialNewsItem(
      id: 'author_skeleton_3',
      badge: 'DISPATCH',
      badgeColor: AppColors.black,
      title: 'Critical perspectives on digital systems and human agency',
      updated: 'Recent dispatch',
      authorName: 'Columnist',
      authorRole: 'Editorial Fellow',
      authorAvatar: '',
      excerpt:
          'Analyzing how technological paradigms and human-centered design converge in modern publishing.',
      color: AppColors.charcoal,
      coverImageUrl: null,
      readingTimeMinutes: 6,
      tags: const ['Technology', 'Ethics'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: EditorialShimmer.darkEffect,
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Published Stories',
                    style: TextStyle(
                      color: AppColors.softCream,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  Text(
                    '3 stories',
                    style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._placeholderArticles.map(
                (item) => ArticleCardOfAuthor(item: item),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthorEmptyView extends StatelessWidget {
  final String message;

  const AuthorEmptyView({
    super.key,
    this.message = 'No published stories found',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              AppIcons.articleOutlined,
              size: 48,
              color: AppColors.greyText,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.softCream,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'This author has not published any stories yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.greyText,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthorErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AuthorErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.redHighlight,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.softCream,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.cream,
                  foregroundColor: AppColors.ink,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppBorders.control,
                  ),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
