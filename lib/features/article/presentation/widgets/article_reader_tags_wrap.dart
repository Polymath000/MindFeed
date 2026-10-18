import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';

class ArticleReaderTagsWrap extends StatelessWidget {
  const ArticleReaderTagsWrap({
    super.key,
    required this.tags,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final filteredTags = tags.where((t) => t.trim().isNotEmpty).toList();
    if (filteredTags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filteredTags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: const BoxDecoration(
                color: AppColors.blackAlpha15,
                borderRadius: AppBorders.tag,
              ),
              child: Text(
                '#$tag',
                style: AppTextStyles.readerTag,
              ),
            ),
          )
          .toList(),
    );
  }
}
