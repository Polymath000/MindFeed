import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_field_helpers.dart';

const _presetCovers = [
  (
    label: 'Tech Cover',
    url:
        'https://images.unsplash.com/photo-1518770660439-4636190af475?w=1200&h=800&fit=crop',
  ),
  (
    label: 'Science Cover',
    url:
        'https://images.unsplash.com/photo-1507413245164-6160d8298b31?w=1200&h=800&fit=crop',
  ),
  (
    label: 'Editorial Cover',
    url:
        'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=1200&h=800&fit=crop',
  ),
];

class ArticleCoverImageField extends StatelessWidget {
  final TextEditingController controller;

  const ArticleCoverImageField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddArticleCubit, AddArticleState>(
      buildWhen: (previous, current) =>
          previous.coverImageUrl != current.coverImageUrl ||
          previous.isUploadingCoverImage != current.isUploadingCoverImage ||
          previous.formErrors.coverImageUrlError !=
              current.formErrors.coverImageUrlError,
      builder: (context, state) {
        final hasImage = state.coverImageUrl.trim().isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ArticleSectionHeader(
              title: 'Cover Image URL',
              counter: 'Landscape required',
              isCounterError: false,
            ),
            const SizedBox(height: 6),
            TextField(
              key: const Key('article_cover_field'),
              controller: controller,
              onChanged: (val) =>
                  context.read<AddArticleCubit>().onCoverImageUrlChanged(val),
              keyboardType: TextInputType.url,
              style: const TextStyle(fontSize: 14, color: AppColors.ink),
              decoration: articleInputDecoration(
                hintText: 'https://example.com/cover-image.jpg',
                errorText: state.formErrors.coverImageUrlError,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  key: const Key('upload_cover_image_button'),
                  onPressed: state.isUploadingCoverImage
                      ? null
                      : () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            withData: true,
                          );
                          if (result == null || result.files.isEmpty) return;
                          final file = result.files.first;
                          if (file.bytes == null) return;
                          if (!context.mounted) return;
                          final uploadedUrl = await context
                              .read<AddArticleCubit>()
                              .uploadCoverImage(
                                bytes: file.bytes!,
                                fileName: file.name,
                              );
                          if (uploadedUrl != null) {
                            controller.text = uploadedUrl;
                          }
                        },
                  icon: state.isUploadingCoverImage
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.ink,
                          ),
                        )
                      : const Icon(Icons.cloud_upload_outlined, size: 18),
                  label: Text(
                    state.isUploadingCoverImage
                        ? 'Uploading...'
                        : 'Upload Cover Image',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: const BorderSide(color: AppColors.creamBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _presetCovers.map((preset) {
                final isSelected = state.coverImageUrl.trim() == preset.url;
                return ActionChip(
                  key: Key('preset_cover_${preset.label}'),
                  label: Text(
                    preset.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected ? AppColors.cream : AppColors.ink,
                    ),
                  ),
                  backgroundColor: isSelected ? AppColors.ink : AppColors.cream,
                  side: BorderSide(
                    color: isSelected ? AppColors.ink : AppColors.creamBorder,
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    controller.text = preset.url;
                    context.read<AddArticleCubit>().onCoverImageUrlChanged(
                      preset.url,
                    );
                  },
                );
              }).toList(),
            ),
            if (hasImage) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  state.coverImageUrl.trim(),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.creamBorder),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.mutedInk,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Unable to load preview',
                            style: TextStyle(
                              color: AppColors.mutedInk,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
