import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/design/editorial_saved_stack.dart';
import 'package:mind_feed/core/design/editorial_shimmer.dart';

class SavedArticlesLoadingView extends StatelessWidget {
  const SavedArticlesLoadingView({super.key});

  static final List<EditorialNewsItem> _placeholderSavedStories = [
    EditorialNewsItem(
      id: 'saved_skeleton_1',
      badge: 'ARCHIVE',
      badgeColor: AppColors.black,
      title: 'Curating thoughtful longform essays and perspectives for focused reading',
      updated: 'Saved recently',
      authorName: 'Editorial Staff',
      authorRole: 'Senior Contributor',
      authorAvatar: '',
      excerpt:
          'Deep insights, archival reports, and thought-provoking analysis saved across your personal collection.',
      color: AppColors.cream,
    ),
    EditorialNewsItem(
      id: 'saved_skeleton_2',
      badge: 'ESSAY',
      badgeColor: AppColors.black,
      title: 'Exploring timeless cultural critiques and contemporary philosophy',
      updated: 'Saved recently',
      authorName: 'Editorial Staff',
      authorRole: 'Contributing Essayist',
      authorAvatar: '',
      excerpt:
          'Essential perspectives exploring the intersections of craft, culture, modern literature, and ideas.',
      color: AppColors.sand,
    ),
    EditorialNewsItem(
      id: 'saved_skeleton_3',
      badge: 'ANALYSIS',
      badgeColor: AppColors.black,
      title: 'Investigative investigations into modern technology and human society',
      updated: 'Saved recently',
      authorName: 'Editorial Staff',
      authorRole: 'Special Correspondent',
      authorAvatar: '',
      excerpt:
          'Reflections on how emergent systems, architecture, and design shape our daily reading practices.',
      color: AppColors.creamLight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: EditorialShimmer.paperEffect,
      child: IgnorePointer(
        child: EditorialSavedStack(
          items: _placeholderSavedStories,
          onOpenArticle: (_) {},
        ),
      ),
    );
  }
}
