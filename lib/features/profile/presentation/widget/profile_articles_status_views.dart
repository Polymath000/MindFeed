import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class ProfileArticlesLoadingView extends StatelessWidget {
  const ProfileArticlesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.cream),
      ),
    );
  }
}

class ProfileArticlesEmptyView extends StatelessWidget {
  final VoidCallback? onCreateArticle;

  const ProfileArticlesEmptyView({super.key, this.onCreateArticle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No published articles yet',
              style: TextStyle(color: AppColors.greyText, fontSize: 14),
            ),
            if (onCreateArticle != null) ...[
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onCreateArticle,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text(
                  'Write Your First Article',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.cream,
                  foregroundColor: AppColors.ink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProfileArticlesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProfileArticlesErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isNotEmpty ? message : 'Failed to load articles',
              style: const TextStyle(
                color: AppColors.greyText,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.cream,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showDeleteArticleDialog(
  BuildContext context,
  EditorialNewsItem item,
) {
  return showDialog<bool>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      backgroundColor: AppColors.whiteLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Delete Article',
        style: TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'Are you sure you want to delete "${item.title.split('\n').first}"?',
        style: const TextStyle(
          color: AppColors.mutedInk,
          fontSize: 14,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogCtx, false),
          child: const Text('Cancel', style: TextStyle(color: AppColors.greyText)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.redHighlight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.pop(dialogCtx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
