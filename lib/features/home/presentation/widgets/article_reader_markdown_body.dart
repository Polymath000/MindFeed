import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class ArticleReaderMarkdownBody extends StatelessWidget {
  const ArticleReaderMarkdownBody({
    super.key,
    this.content,
    required this.excerpt,
    required this.title,
  });

  final String? content;
  final String excerpt;
  final String title;

  @override
  Widget build(BuildContext context) {
    final hasContent =
        content != null && content!.trim().isNotEmpty;
    final markdownData = hasContent ? content! : excerpt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasContent && excerpt.isNotEmpty) ...[
          Text(
            excerpt,
            style: const TextStyle(
              fontSize: 16,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 20),
        ],
        MarkdownBlock(
          data: markdownData.isNotEmpty ? markdownData : title,
          config: MarkdownConfig(
            configs: [
              PConfig(
                textStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.65,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w400,
                ),
              ),
              H1Config(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                  height: 1.3,
                ),
              ),
              H2Config(
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  height: 1.3,
                ),
              ),
              H3Config(
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  height: 1.3,
                ),
              ),
              LinkConfig(
                style: const TextStyle(
                  color: AppColors.redHighlight,
                  decoration: TextDecoration.underline,
                ),
              ),
              BlockquoteConfig(
                sideColor: AppColors.mutedInk,
                textColor: AppColors.mutedInk,
              ),
              CodeConfig(
                style: const TextStyle(
                  backgroundColor: Colors.black12,
                  color: AppColors.ink,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '#$tag',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
