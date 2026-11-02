import 'package:flutter/material.dart';

import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';

class SearchFilterTriggerButton extends StatelessWidget {
  const SearchFilterTriggerButton({
    super.key,
    required this.activeCount,
    required this.onTap,
  });

  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = activeCount > 0;
    return Semantics(
      button: true,
      label: 'Open filters',
      child: Material(
        color: isActive ? AppColors.cream : AppColors.darkTile,
        borderRadius: AppBorders.control,
        child: InkWell(
          key: const ValueKey('search_filter_dialog_button'),
          onTap: onTap,
          borderRadius: AppBorders.control,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: AppBorders.control,
              border: Border.all(
                color: isActive ? AppColors.cream : AppColors.borderDark,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIcons.displaySettings,
                  size: 19,
                  color: isActive ? AppColors.ink : AppColors.softCream,
                ),
                const SizedBox(width: 7),
                Text(
                  'Filter',
                  style: isActive
                      ? AppTextStyles.filterTriggerActiveLabel
                      : AppTextStyles.filterTriggerLabel,
                ),
                if (isActive) ...[
                  const SizedBox(width: 7),
                  _ActiveFilterCountBadge(count: activeCount),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveFilterCountBadge extends StatelessWidget {
  const _ActiveFilterCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: const BoxDecoration(
        color: AppColors.yellowHighlight,
        borderRadius: AppBorders.circular,
      ),
      child: Text('$count', style: AppTextStyles.filterBadgeCount),
    );
  }
}

class SearchActiveFiltersBar extends StatelessWidget {
  const SearchActiveFiltersBar({
    super.key,
    required this.selectedCategory,
    required this.selectedTags,
    required this.onClearCategory,
    required this.onRemoveTag,
    required this.onClearAll,
  });

  final CategoryEntity? selectedCategory;
  final List<String> selectedTags;
  final VoidCallback onClearCategory;
  final ValueChanged<String> onRemoveTag;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null && selectedTags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (selectedCategory != null)
            _SelectedCategoryChip(
              category: selectedCategory!,
              onDeleted: onClearCategory,
            ),
          for (final tag in selectedTags)
            _SelectedTagChip(
              tag: tag,
              onDeleted: () => onRemoveTag(tag),
            ),
          TextButton(
            onPressed: onClearAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Clear all',
              style: AppTextStyles.filterDialogResetAction,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedCategoryChip extends StatelessWidget {
  const _SelectedCategoryChip({
    required this.category,
    required this.onDeleted,
  });

  final CategoryEntity category;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: Icon(
        AppIcons.getCategoryIcon(category.name),
        size: 15,
        color: AppColors.ink,
      ),
      label: Text(
        category.name,
        style: AppTextStyles.filterChipCategorySelected,
      ),
      backgroundColor: AppColors.cream,
      deleteIcon: const Icon(AppIcons.close, size: 15, color: AppColors.ink),
      deleteButtonTooltipMessage: 'Remove ${category.name} filter',
      onDeleted: onDeleted,
      side: const BorderSide(color: AppColors.cream),
      shape: const RoundedRectangleBorder(borderRadius: AppBorders.pill),
    );
  }
}

class _SelectedTagChip extends StatelessWidget {
  const _SelectedTagChip({
    required this.tag,
    required this.onDeleted,
  });

  final String tag;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text('#$tag', style: AppTextStyles.filterChipTagSelected),
      backgroundColor: AppColors.yellowHighlight,
      deleteIcon: const Icon(AppIcons.close, size: 15, color: AppColors.ink),
      deleteButtonTooltipMessage: 'Remove #$tag filter',
      onDeleted: onDeleted,
      side: const BorderSide(color: AppColors.yellowHighlight),
      shape: const RoundedRectangleBorder(borderRadius: AppBorders.xxs),
    );
  }
}
