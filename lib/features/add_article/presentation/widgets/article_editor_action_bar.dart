import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_validator.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/routes/add_article_routes.dart';

class ArticleEditorActionBar extends StatelessWidget {
  const ArticleEditorActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddArticleCubit, AddArticleState>(
      buildWhen: (previous, current) =>
          previous.isSavingDraft != current.isSavingDraft ||
          previous.isPublishing != current.isPublishing ||
          previous.isEditingPublished != current.isEditingPublished ||
          previous.title != current.title ||
          previous.content != current.content ||
          previous.coverImageUrl != current.coverImageUrl ||
          previous.selectedTags != current.selectedTags ||
          previous.editingItemId != current.editingItemId,
      builder: (context, state) {
        final isBusy = state.isSavingDraft || state.isPublishing;

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(
                key: const Key('save_draft_button'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  side: const BorderSide(
                    color: AppColors.ink,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isBusy
                    ? null
                    : () => context.read<AddArticleCubit>().saveDraft(),
                child: state.isSavingDraft
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.ink,
                        ),
                      )
                    : const Text(
                        'Save Draft',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: OutlinedButton(
                key: const Key('preview_button'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  side: const BorderSide(
                    color: AppColors.creamBorder,
                    width: 1.5,
                  ),
                  backgroundColor: AppColors.cream,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _openPreview(context, state),
                child: const Text(
                  'Preview',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                key: const Key('publish_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  foregroundColor: AppColors.softCream,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isBusy
                    ? null
                    : () => context.read<AddArticleCubit>().publish(),
                child: state.isPublishing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.softCream,
                        ),
                      )
                    : Text(
                        state.isEditingPublished ? 'Update' : 'Publish',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openPreview(BuildContext context, AddArticleState state) {
    final previewItem = EditorialNewsItem(
      id: state.editingItemId ?? 'preview',
      badge: 'PREVIEW',
      badgeColor: AppColors.butter,
      title: state.title.trim().isNotEmpty
          ? state.title.trim()
          : 'Untitled Story',
      updated: 'Draft',
      authorName: 'You',
      authorRole: 'Writer',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt: ArticleValidator.generateExcerpt(state.content),
      color: AppColors.cream,
      tags: state.selectedTags,
      content: state.content,
      coverImageUrl: state.coverImageUrl.trim().isNotEmpty
          ? state.coverImageUrl.trim()
          : null,
      readingTimeMinutes: ArticleValidator.computeReadingTime(state.content),
      status: 'draft',
    );
    Navigator.pushNamed(
      context,
      AddArticleRoutes.articlePreview,
      arguments: previewItem,
    );
  }
}
