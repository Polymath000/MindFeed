import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';

class SearchCategoryChipsBar extends StatelessWidget {
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategory;
  final ValueChanged<CategoryEntity> onCategorySelected;

  const SearchCategoryChipsBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            color: AppColors.softCream,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategory?.id == category.id;
            return FilterChip(
              selected: isSelected,
              showCheckmark: false,
              label: Text(category.name),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.ink : AppColors.softCream,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
              ),
              backgroundColor: AppColors.darkTile,
              selectedColor: AppColors.cream,
              side: BorderSide(
                color: isSelected ? AppColors.cream : AppColors.darkerEdge,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              onSelected: (_) => onCategorySelected(category),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class SearchTagChipsBar extends StatelessWidget {
  final List<TagEntity> tags;
  final List<String> selectedTags;
  final ValueChanged<String> onTagToggled;

  const SearchTagChipsBar({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagToggled,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter by tags',
          style: TextStyle(
            color: AppColors.softCream,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            final isSelected = selectedTags.contains(tag.name);
            return FilterChip(
              selected: isSelected,
              showCheckmark: false,
              label: Text('#${tag.name}'),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.ink : AppColors.greyText,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 12,
              ),
              backgroundColor: AppColors.darkSurface,
              selectedColor: AppColors.yellowHighlight,
              side: BorderSide(
                color: isSelected
                    ? AppColors.yellowHighlight
                    : AppColors.darkerEdge,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              onSelected: (_) => onTagToggled(tag.name),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
