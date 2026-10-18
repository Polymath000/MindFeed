import 'package:flutter/material.dart';

import 'package:markdown_widget/markdown_widget.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';

export 'article_reader_tags_wrap.dart';

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

  static final MarkdownConfig _cachedMarkdownConfig = MarkdownConfig(
    configs: [
      PConfig(textStyle: AppTextStyles.readerBodyParagraph),
      H1Config(style: AppTextStyles.readerHeading1),
      H2Config(style: AppTextStyles.readerHeading2),
      H3Config(style: AppTextStyles.readerHeading3),
      LinkConfig(style: AppTextStyles.readerLink),
      BlockquoteConfig(
        sideColor: AppColors.mutedInk,
        textColor: AppColors.mutedInk,
      ),
      CodeConfig(style: AppTextStyles.readerCode),
    ],
  );

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
            style: AppTextStyles.readerExcerpt,
          ),
          const SizedBox(height: 20),
        ],
        MarkdownBlock(
          data: markdownData.isNotEmpty ? markdownData : title,
          config: _cachedMarkdownConfig,
        ),
      ],
    );
  }
}
