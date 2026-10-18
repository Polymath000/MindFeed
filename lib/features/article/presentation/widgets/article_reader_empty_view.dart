import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';

import 'package:mind_feed/core/constants/app_text_styles.dart';

class ArticleReaderEmptyView extends StatelessWidget {
  const ArticleReaderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  AppIcons.articleOutlined,
                  size: 48,
                  color: AppColors.mutedInk,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Article Not Found',
                  style: AppTextStyles.readerEmptyTitle,
                ),
                const SizedBox(height: 8),
                const Text(
                  'No article content was provided.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.readerEmptyMessage,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.ink,
                    foregroundColor: AppColors.softCream,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
