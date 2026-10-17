import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/widget/article_field_helpers.dart';

class ArticleCoverImageField extends StatelessWidget {
  final TextEditingController controller;

  const ArticleCoverImageField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddArticleCubit, AddArticleState>(
      buildWhen: (previous, current) =>
          previous.coverImageUrl != current.coverImageUrl ||
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
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.ink,
              ),
              decoration: articleInputDecoration(
                hintText: 'https://example.com/cover-image.jpg',
                errorText: state.formErrors.coverImageUrlError,
              ),
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
                      border: Border.all(
                        color: AppColors.creamBorder,
                      ),
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
