import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/routes/add_article_routes.dart';

class DraftItemCard extends StatelessWidget {
  final EditorialNewsItem draft;

  const DraftItemCard({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('draft_card_${draft.id}'),
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openDraft(context),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.whiteLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.creamBorder),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(),
              const SizedBox(height: 8),
              _buildMetaRow(),
              const SizedBox(height: 14),
              _buildActionsRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            draft.title.isNotEmpty ? draft.title : 'Untitled Draft',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              height: 1.3,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.butter,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'DRAFT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow() {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 14,
          color: AppColors.mutedInk,
        ),
        const SizedBox(width: 4),
        Text(
          draft.updated,
          style: const TextStyle(fontSize: 12, color: AppColors.mutedInk),
        ),
        const SizedBox(width: 12),
        Text(
          '${draft.readingTimeMinutes} min read',
          style: const TextStyle(fontSize: 12, color: AppColors.mutedInk),
        ),
      ],
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          key: Key('delete_draft_button_${draft.id}'),
          tooltip: 'Delete Draft',
          icon: const Icon(
            AppIcons.delete,
            size: 20,
            color: AppColors.redHighlight,
          ),
          onPressed: () => _showDeleteConfirmation(context),
        ),
        const Spacer(),
        TextButton(
          key: Key('preview_draft_button_${draft.id}'),
          onPressed: () => Navigator.pushNamed(
            context,
            AddArticleRoutes.articlePreview,
            arguments: draft,
          ),
          child: const Text(
            'Preview',
            style: TextStyle(
              color: AppColors.mutedInk,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          key: Key('edit_draft_button_${draft.id}'),
          onPressed: () => _openDraft(context),
          child: const Text(
            'Edit',
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 4),
        ElevatedButton(
          key: Key('publish_draft_button_${draft.id}'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ink,
            foregroundColor: AppColors.softCream,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _openDraft(context),
          child: const Text(
            'Publish',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void _openDraft(BuildContext context) {
    Navigator.pushNamed(
      context,
      AddArticleRoutes.addArticle,
      arguments: draft,
    ).then((_) {
      if (context.mounted) {
        context.read<DraftsCubit>().loadDrafts();
      }
    });
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.sandLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Draft?',
          style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this draft? This action cannot be undone.',
          style: TextStyle(color: AppColors.mutedInk),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mutedInk),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<DraftsCubit>().deleteDraft(draft.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: AppColors.redHighlight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
