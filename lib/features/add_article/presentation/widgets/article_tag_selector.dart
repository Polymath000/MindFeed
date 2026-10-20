import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/add_tag_dialog.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_field_helpers.dart';

class ArticleTagSelector extends StatelessWidget {
  const ArticleTagSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddArticleCubit, AddArticleState>(
      buildWhen: (previous, current) =>
          previous.selectedTags != current.selectedTags ||
          previous.availableTags != current.availableTags ||
          previous.formErrors.tagsError != current.formErrors.tagsError,
      builder: (context, state) {
        final tagsCount = state.selectedTags.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArticleSectionHeader(
              title: 'Tags',
              counter: '$tagsCount / 5 selected',
              isCounterError: tagsCount > 5,
            ),
            const SizedBox(height: 6),
            if (state.formErrors.tagsError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  state.formErrors.tagsError!,
                  style: const TextStyle(
                    color: AppColors.redHighlight,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  key: const Key('add_tag_button'),
                  avatar: const Icon(
                    AppIcons.add,
                    size: 16,
                    color: AppColors.ink,
                  ),
                  label: const Text('Add Tag'),
                  onPressed: () {
                    if (state.selectedTags.length >= 5) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Maximum of 5 tags allowed'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (_) => AddTagDialog(
                        onTagAdded: (tag) =>
                            context.read<AddArticleCubit>().addCustomTag(tag),
                      ),
                    );
                  },
                  backgroundColor: AppColors.sandLight,
                  labelStyle: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.creamBorder),
                  ),
                ),
                ...state.availableTags.map((tag) {
                  final isSelected = state.selectedTags.contains(tag.name);
                  return FilterChip(
                    key: Key('tag_chip_${tag.name}'),
                    label: Text('#${tag.name}'),
                    selected: isSelected,
                    onSelected: (_) =>
                        context.read<AddArticleCubit>().onTagToggled(tag.name),
                    backgroundColor: AppColors.whiteLight,
                    selectedColor: AppColors.ink,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.softCream : AppColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.ink
                            : AppColors.creamBorder,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        );
      },
    );
  }
}
