import 'package:flutter/material.dart';

import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';

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

  static final MarkdownStyleSheet _cachedStyleSheet = MarkdownStyleSheet(
    p: AppTextStyles.readerBodyParagraph,
    h1: AppTextStyles.readerHeading1,
    h2: AppTextStyles.readerHeading2,
    h3: AppTextStyles.readerHeading3,
    a: AppTextStyles.readerLink,
    blockquote: AppTextStyles.readerBodyParagraph.copyWith(
      color: AppColors.mutedInk,
    ),
    blockquoteDecoration: const BoxDecoration(
      border: Border(left: BorderSide(color: AppColors.mutedInk, width: 3)),
    ),
    code: AppTextStyles.readerCode,
    codeblockDecoration: const BoxDecoration(
      color: AppColors.blackAlpha12,
      borderRadius: AppBorders.control,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final hasContent = content != null && content!.trim().isNotEmpty;
    final markdownData = hasContent ? content! : excerpt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasContent && excerpt.isNotEmpty) ...[
          Text(excerpt, style: AppTextStyles.readerExcerpt),
          const SizedBox(height: 20),
        ],
        MarkdownBody(
          data: markdownData.isNotEmpty ? markdownData : title,
          selectable: false,
          styleSheet: _cachedStyleSheet,
        ),
      ],
    );
  }
}
