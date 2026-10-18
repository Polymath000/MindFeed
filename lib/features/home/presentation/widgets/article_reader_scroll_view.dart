import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/home/presentation/views/article_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_action_bar_section.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_author_section.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_reader_header.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_reader_markdown_body.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_reader_top_bar.dart';

class ArticleReaderScrollView extends StatelessWidget {
  const ArticleReaderScrollView({
    super.key,
    required this.controller,
    required this.article,
  });

  final ScrollController controller;
  final EditorialNewsItem article;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
      children: [
        ArticleReaderTopBar(
          badge: article.badge,
          badgeColor: article.badgeColor,
        ),
        const SizedBox(height: 16),
        ArticleReaderMetadataHeader(
          title: article.title,
          updated: article.updated,
          readingTimeMinutes: article.readingTimeMinutes,
        ),
        const SizedBox(height: 16),
        ArticleAuthorSection(article: article),
        if (article.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          ArticleReaderTagsWrap(tags: article.tags),
        ],
        const SizedBox(height: 20),
        ArticleReaderCoverImage(
          coverImageUrl: article.coverImageUrl,
          overlay: ArticleActionBarSection(title: article.title),
        ),
        const SizedBox(height: 24),
        ArticleReaderMarkdownBody(
          content: article.content,
          excerpt: article.excerpt,
          title: article.title,
        ),
      ],
    );
  }
}
