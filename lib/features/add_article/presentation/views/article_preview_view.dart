import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/add_article/presentation/routes/add_article_routes.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_preview_bottom_bar.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_preview_header.dart';

class ArticlePreviewView extends StatelessWidget {
  final EditorialNewsItem? item;

  const ArticlePreviewView({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final preview = item;
    if (preview == null) {
      return Scaffold(
        backgroundColor: AppColors.sandLight,
        appBar: AppBar(
          backgroundColor: AppColors.sandLight,
          elevation: 0,
          leading: IconButton(
            key: const Key('preview_empty_back_button'),
            icon: const Icon(AppIcons.arrowBackRounded, color: AppColors.ink),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        body: const Center(
          child: Text(
            'No article data to preview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
      );
    }

    final isDraft = preview.status == 'draft';

    return Scaffold(
      backgroundColor: AppColors.sandLight,
      appBar: AppBar(
        backgroundColor: AppColors.sandLight,
        elevation: 0,
        leading: IconButton(
          key: const Key('preview_back_button'),
          icon: const Icon(AppIcons.arrowBackRounded, color: AppColors.ink),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          isDraft ? 'Draft Preview' : 'Story Preview',
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          if (isDraft)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton.icon(
                key: const Key('preview_app_bar_publish_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  foregroundColor: AppColors.softCream,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _openEditor(context, preview),
                icon: const Icon(AppIcons.checkRounded, size: 16),
                label: const Text(
                  'Publish',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isDraft
          ? ArticlePreviewBottomBar(
              onEdit: () => _openEditor(context, preview),
              onPublish: () => _openEditor(context, preview),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
              children: [
                ArticlePreviewHeader(item: preview),
                MarkdownBody(data: preview.content ?? '', selectable: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, EditorialNewsItem preview) {
    Navigator.pushReplacementNamed(
      context,
      AddArticleRoutes.addArticle,
      arguments: preview,
    );
  }
}
