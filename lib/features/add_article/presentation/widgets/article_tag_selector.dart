import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/add_tag_dialog.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_field_helpers.dart';

class ArticleTagSelector extends StatefulWidget {
  const ArticleTagSelector({super.key});

  @override
  State<ArticleTagSelector> createState() => _ArticleTagSelectorState();
}

class _ArticleTagSelectorState extends State<ArticleTagSelector> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  void _handleTagAdd(
    BuildContext context,
    AddArticleState state,
    String rawTag,
  ) {
    final trimmed = rawTag.trim();
    if (trimmed.isEmpty) return;

    if (state.selectedTags.length >= 5) {
      customShowSnackBar(
        context: context,
        message: 'Maximum of 5 tags allowed',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    context.read<AddArticleCubit>().addCustomTag(trimmed);
    _searchController.clear();
    _searchQuery.value = '';
  }

  void _handleSelectExisting(
    BuildContext context,
    AddArticleState state,
    String tagName,
  ) {
    if (state.selectedTags.length >= 5 &&
        !state.selectedTags.contains(tagName)) {
      customShowSnackBar(
        context: context,
        message: 'Maximum of 5 tags allowed',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    context.read<AddArticleCubit>().onTagToggled(tagName);
    _searchController.clear();
    _searchQuery.value = '';
  }

  void _openAddTagDialog(BuildContext context, AddArticleState state) {
    if (state.selectedTags.length >= 5) {
      customShowSnackBar(
        context: context,
        message: 'Maximum of 5 tags allowed',
        duration: const Duration(seconds: 2),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AddTagDialog(
        onTagAdded: (tag) => context.read<AddArticleCubit>().addCustomTag(tag),
      ),
    );
  }

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

            // Tag Search & Input Bar
            TextField(
              key: const Key('tag_search_field'),
              controller: _searchController,
              focusNode: _focusNode,
              cursorColor: AppColors.ink,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration: articleInputDecoration(
                hintText: 'Search or add tags (e.g. tech, flutter)...',
              ).copyWith(
                prefixIcon: const Icon(
                  AppIcons.search,
                  size: 20,
                  color: AppColors.mutedInk,
                ),
                suffixIcon: ValueListenableBuilder<String>(
                  valueListenable: _searchQuery,
                  builder: (context, query, _) {
                    final trimmed = query.trim();
                    if (trimmed.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ActionChip(
                          key: const Key('add_tag_button'),
                          avatar: const Icon(
                            AppIcons.add,
                            size: 14,
                            color: AppColors.ink,
                          ),
                          label: const Text('Add Tag'),
                          onPressed: () => _openAddTagDialog(context, state),
                          backgroundColor: AppColors.sandLight,
                          labelStyle: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: AppColors.creamBorder,
                            ),
                          ),
                        ),
                      );
                    }
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: const Key('clear_tag_search_button'),
                          icon: const Icon(
                            AppIcons.close,
                            size: 18,
                            color: AppColors.mutedInk,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _searchQuery.value = '';
                          },
                        ),
                        IconButton(
                          key: const Key('submit_tag_search_button'),
                          icon: const Icon(
                            AppIcons.add,
                            size: 20,
                            color: AppColors.ink,
                          ),
                          tooltip: 'Add tag',
                          onPressed: () =>
                              _handleTagAdd(context, state, trimmed),
                        ),
                      ],
                    );
                  },
                ),
              ),
              onChanged: (val) => _searchQuery.value = val,
              onSubmitted: (val) => _handleTagAdd(context, state, val),
            ),

            // Dynamic Autocomplete & Create Tag Suggestions
            ValueListenableBuilder<String>(
              valueListenable: _searchQuery,
              builder: (context, query, _) {
                final trimmed = query.trim();
                if (trimmed.isEmpty) return const SizedBox.shrink();

                final normalizedInput = trimmed
                    .toLowerCase()
                    .replaceAll(RegExp(r'^#+'), '')
                    .replaceAll(RegExp(r'\s+'), '-');

                final matches = state.availableTags.where((t) {
                  final matchesQuery =
                      t.name.toLowerCase().contains(trimmed.toLowerCase()) ||
                      t.slug.toLowerCase().contains(trimmed.toLowerCase());
                  final notSelected = !state.selectedTags.any(
                    (s) => s.toLowerCase() == t.name.toLowerCase(),
                  );
                  return matchesQuery && notSelected;
                }).take(6).toList();

                final hasExactMatch = state.availableTags.any(
                  (t) =>
                      t.name.toLowerCase() == trimmed.toLowerCase() ||
                      t.slug.toLowerCase() == normalizedInput,
                );

                final isAlreadySelected = state.selectedTags.any(
                  (s) =>
                      s.toLowerCase() == trimmed.toLowerCase() ||
                      s.toLowerCase() == normalizedInput,
                );

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (!hasExactMatch &&
                          !isAlreadySelected &&
                          trimmed.isNotEmpty)
                        ActionChip(
                          key: const Key('add_new_tag_chip'),
                          avatar: const Icon(
                            AppIcons.add,
                            size: 14,
                            color: AppColors.softCream,
                          ),
                          label: Text('Add "#$trimmed"'),
                          backgroundColor: AppColors.ink,
                          labelStyle: const TextStyle(
                            color: AppColors.softCream,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onPressed: () =>
                              _handleTagAdd(context, state, trimmed),
                        ),
                      ...matches.map((tag) {
                        return ActionChip(
                          key: Key('suggested_tag_${tag.name}'),
                          avatar: const Icon(
                            AppIcons.add,
                            size: 14,
                            color: AppColors.ink,
                          ),
                          label: Text('#${tag.name}'),
                          backgroundColor: AppColors.whiteLight,
                          labelStyle: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: AppColors.creamBorder,
                            ),
                          ),
                          onPressed: () =>
                              _handleSelectExisting(context, state, tag.name),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Selected Tags List
            if (state.selectedTags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.selectedTags.map((tagName) {
                  return InputChip(
                    key: Key('tag_chip_$tagName'),
                    label: Text('#$tagName'),
                    selected: true,
                    showCheckmark: false,
                    labelStyle: const TextStyle(
                      color: AppColors.softCream,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    backgroundColor: AppColors.ink,
                    selectedColor: AppColors.ink,
                    deleteIcon: const Icon(
                      AppIcons.close,
                      size: 14,
                      color: AppColors.softCream,
                    ),
                    onDeleted: () =>
                        context.read<AddArticleCubit>().onTagToggled(tagName),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.ink),
                    ),
                  );
                }).toList(),
              ),
            ] else ...[
              const Text(
                'No tags selected yet (select between 1 and 5 tags).',
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
