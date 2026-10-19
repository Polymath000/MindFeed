import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
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

    return Scaffold(
      backgroundColor: AppColors.sandLight,
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
}
