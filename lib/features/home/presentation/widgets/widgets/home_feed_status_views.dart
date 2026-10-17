import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/design/editorial_card_stack.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/home_lead_story_section.dart';

class HomeFeedLoadingView extends StatelessWidget {
  const HomeFeedLoadingView({super.key});

  static const ShimmerEffect editorialShimmerEffect = ShimmerEffect(
    baseColor: AppColors.greyBrown,
    highlightColor: AppColors.creamDark,
  );

  static final List<EditorialNewsItem> _placeholderStories = [
    EditorialNewsItem(
      id: 'skeleton_1',
      badge: 'FEATURED',
      badgeColor: AppColors.creamDark,
      title: 'Curating thoughtful stories and deep editorial insights for you',
      updated: 'Updated moments ago',
      authorName: 'Editorial Staff',
      authorRole: 'Senior Columnist',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Loading the latest perspectives, investigative reports, and curated essays tailored to your reading preferences.',
      color: AppColors.cream,
      readingTimeMinutes: 5,
    ),
    EditorialNewsItem(
      id: 'skeleton_2',
      badge: 'INSIGHT',
      badgeColor: AppColors.creamDark,
      title: 'Exploring emerging paradigms in modern science and technology',
      updated: 'Updated recently',
      authorName: 'Editorial Staff',
      authorRole: 'Contributing Writer',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Discovering how new breakthroughs continue to reshape our understanding of the world around us.',
      color: AppColors.sand,
      readingTimeMinutes: 4,
    ),
    EditorialNewsItem(
      id: 'skeleton_3',
      badge: 'CULTURE',
      badgeColor: AppColors.creamDark,
      title: 'Reflections on design, literature, and mindful daily reading',
      updated: 'Updated today',
      authorName: 'Editorial Staff',
      authorRole: 'Culture Editor',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'A closer look at the ideas and creative movements defining contemporary thought and digital publishing.',
      color: AppColors.creamLight,
      readingTimeMinutes: 6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: editorialShimmerEffect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditorialCardStack(
            items: _placeholderStories,
            height: 570,
            onOpenArticle: (_) {},
          ),
          const SizedBox(height: 24),
          const Text(
            'More Stories',
            style: TextStyle(
              color: AppColors.softCream,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          ..._placeholderStories.map(
            (item) => HomeSecondaryStoryTile(
              item: item,
              onTap: () {},
              onToggleSave: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class HomeFeedErrorView extends StatelessWidget {
  const HomeFeedErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.softCream,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.softCream,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cream,
                  foregroundColor: AppColors.ink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: onRetry,
                child: const Text(
                  'Retry',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeFeedEmptyView extends StatelessWidget {
  const HomeFeedEmptyView({
    super.key,
    required this.onRefresh,
  });

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'No stories available for this topic.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cream,
                  foregroundColor: AppColors.ink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: onRefresh,
                child: const Text(
                  'Refresh',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
