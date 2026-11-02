import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';

@immutable
class EditorialFilterOption {
  const EditorialFilterOption({
    required this.id,
    required this.label,
    this.icon,
  });

  final String id;
  final String label;
  final IconData? icon;
}

@immutable
class EditorialFilterSelection {
  const EditorialFilterSelection({
    required this.selectedCategoryId,
    required this.selectedTags,
  });

  final String? selectedCategoryId;
  final List<String> selectedTags;
}

Future<EditorialFilterSelection?> showEditorialFilterDialog({
  required BuildContext context,
  required List<EditorialFilterOption> categories,
  required List<String> tags,
  String? initialCategoryId,
  List<String> initialTags = const [],
}) {
  return showDialog<EditorialFilterSelection>(
    context: context,
    builder: (_) => EditorialFilterDialog(
      categories: categories,
      tags: tags,
      initialCategoryId: initialCategoryId,
      initialTags: initialTags,
    ),
  );
}

class EditorialFilterDialog extends StatefulWidget {
  const EditorialFilterDialog({
    super.key,
    required this.categories,
    required this.tags,
    this.initialCategoryId,
    this.initialTags = const [],
  });

  final List<EditorialFilterOption> categories;
  final List<String> tags;
  final String? initialCategoryId;
  final List<String> initialTags;

  @override
  State<EditorialFilterDialog> createState() => _EditorialFilterDialogState();
}

class _EditorialFilterDialogState extends State<EditorialFilterDialog> {
  late final TextEditingController _queryController;
  late final ValueNotifier<String> _queryNotifier;
  late final ValueNotifier<String?> _categoryNotifier;
  late final ValueNotifier<List<String>> _tagsNotifier;
  late final Listenable _selectionListenable;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
    _queryNotifier = ValueNotifier<String>('');
    _categoryNotifier = ValueNotifier<String?>(widget.initialCategoryId);
    _tagsNotifier = ValueNotifier<List<String>>(
      List<String>.of(widget.initialTags),
    );
    _selectionListenable = Listenable.merge([
      _categoryNotifier,
      _tagsNotifier,
    ]);
  }

  @override
  void dispose() {
    _queryController.dispose();
    _queryNotifier.dispose();
    _categoryNotifier.dispose();
    _tagsNotifier.dispose();
    super.dispose();
  }

  void _toggleCategory(String id) {
    _categoryNotifier.value = _categoryNotifier.value == id ? null : id;
  }

  void _toggleTag(String tag) {
    final next = List<String>.of(_tagsNotifier.value);
    next.contains(tag) ? next.remove(tag) : next.add(tag);
    _tagsNotifier.value = next;
  }

  void _resetAll() {
    _categoryNotifier.value = null;
    _tagsNotifier.value = const [];
  }

  void _applyAndClose() {
    Navigator.of(context).pop(
      EditorialFilterSelection(
        selectedCategoryId: _categoryNotifier.value,
        selectedTags: List<String>.unmodifiable(_tagsNotifier.value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;
    return Dialog(
      backgroundColor: AppColors.charcoal,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorders.card,
        side: BorderSide(color: AppColors.borderDark),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480, maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(
                selectionListenable: _selectionListenable,
                hasSelection: () =>
                    _categoryNotifier.value != null ||
                    _tagsNotifier.value.isNotEmpty,
                onReset: _resetAll,
                onClose: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 12),
              _DialogSearchField(
                controller: _queryController,
                onChanged: (value) => _queryNotifier.value = value,
              ),
              const SizedBox(height: 14),
              Flexible(child: _buildScrollableFilterSections()),
              const SizedBox(height: 16),
              _DialogApplyBar(
                selectionListenable: _selectionListenable,
                activeCount: () =>
                    (_categoryNotifier.value != null ? 1 : 0) +
                    _tagsNotifier.value.length,
                onApply: _applyAndClose,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableFilterSections() {
    return ValueListenableBuilder<String>(
      valueListenable: _queryNotifier,
      builder: (context, rawQuery, _) {
        final q = rawQuery.trim().toLowerCase();
        final filteredCategories = q.isEmpty
            ? widget.categories
            : widget.categories
                .where((c) => c.label.toLowerCase().contains(q))
                .toList();
        final filteredTags = q.isEmpty
            ? widget.tags
            : widget.tags
                .where((t) => t.toLowerCase().contains(q))
                .toList();

        if (filteredCategories.isEmpty && filteredTags.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text(
                'No matching categories or tags.',
                style: AppTextStyles.filterDialogSubtitle,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (filteredCategories.isNotEmpty)
                _CategoriesFilterSection(
                  categories: filteredCategories,
                  categoryNotifier: _categoryNotifier,
                  onToggleCategory: _toggleCategory,
                ),
              if (filteredCategories.isNotEmpty && filteredTags.isNotEmpty)
                const SizedBox(height: 20),
              if (filteredTags.isNotEmpty)
                _TagsFilterSection(
                  tags: filteredTags,
                  tagsNotifier: _tagsNotifier,
                  onToggleTag: _toggleTag,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.selectionListenable,
    required this.hasSelection,
    required this.onReset,
    required this.onClose,
  });

  final Listenable selectionListenable;
  final bool Function() hasSelection;
  final VoidCallback onReset;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          AppIcons.displaySettings,
          color: AppColors.cream,
          size: 20,
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text('Filter Stories', style: AppTextStyles.filterDialogTitle),
        ),
        AnimatedBuilder(
          animation: selectionListenable,
          builder: (context, _) {
            if (!hasSelection()) return const SizedBox.shrink();
            return TextButton(
              onPressed: onReset,
              child: const Text(
                'Reset',
                style: AppTextStyles.filterDialogResetAction,
              ),
            );
          },
        ),
        IconButton(
          onPressed: onClose,
          tooltip: 'Close filters',
          visualDensity: VisualDensity.compact,
          icon: const Icon(
            AppIcons.close,
            color: AppColors.softCream,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _DialogSearchField extends StatelessWidget {
  const _DialogSearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.filterDialogInput,
      decoration: const InputDecoration(
        hintText: 'Find category or tag...',
        hintStyle: AppTextStyles.filterDialogHint,
        prefixIcon: Icon(
          AppIcons.search,
          color: AppColors.greyText,
          size: 18,
        ),
        filled: true,
        fillColor: AppColors.darkTile,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: AppBorders.bar,
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorders.bar,
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.bar,
          borderSide: BorderSide(color: AppColors.cream, width: 1.5),
        ),
      ),
    );
  }
}

class _CategoriesFilterSection extends StatelessWidget {
  const _CategoriesFilterSection({
    required this.categories,
    required this.categoryNotifier,
    required this.onToggleCategory,
  });

  final List<EditorialFilterOption> categories;
  final ValueNotifier<String?> categoryNotifier;
  final ValueChanged<String> onToggleCategory;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: categoryNotifier,
      builder: (context, selectedId, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: AppTextStyles.filterDialogSectionTitle,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories
                  .map((option) => _buildCategoryChip(option, selectedId))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChip(EditorialFilterOption option, String? selectedId) {
    final isSelected = selectedId == option.id;
    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      avatar: option.icon != null
          ? Icon(
              option.icon,
              size: 15,
              color: isSelected ? AppColors.ink : AppColors.creamDark,
            )
          : null,
      label: Text(option.label),
      labelStyle: isSelected
          ? AppTextStyles.filterChipCategorySelected
          : AppTextStyles.filterChipCategoryUnselected,
      backgroundColor: AppColors.darkTile,
      selectedColor: AppColors.cream,
      side: BorderSide(
        color: isSelected ? AppColors.cream : AppColors.borderDark,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppBorders.pill),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      onSelected: (_) => onToggleCategory(option.id),
    );
  }
}

class _TagsFilterSection extends StatelessWidget {
  const _TagsFilterSection({
    required this.tags,
    required this.tagsNotifier,
    required this.onToggleTag,
  });

  final List<String> tags;
  final ValueNotifier<List<String>> tagsNotifier;
  final ValueChanged<String> onToggleTag;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: tagsNotifier,
      builder: (context, selectedTags, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by tags',
              style: AppTextStyles.filterDialogSectionTitle,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map((tag) => _buildTagChip(tag, selectedTags.contains(tag)))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTagChip(String tag, bool isSelected) {
    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      label: Text('#$tag'),
      labelStyle: isSelected
          ? AppTextStyles.filterChipTagSelected
          : AppTextStyles.filterChipTagUnselected,
      backgroundColor: AppColors.darkSurface,
      selectedColor: AppColors.yellowHighlight,
      side: BorderSide(
        color: isSelected ? AppColors.yellowHighlight : AppColors.borderDark,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppBorders.xxs),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      onSelected: (_) => onToggleTag(tag),
    );
  }
}

class _DialogApplyBar extends StatelessWidget {
  const _DialogApplyBar({
    required this.selectionListenable,
    required this.activeCount,
    required this.onApply,
  });

  final Listenable selectionListenable;
  final int Function() activeCount;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: selectionListenable,
      builder: (context, _) {
        final count = activeCount();
        final label = count > 0 ? 'Apply Filters ($count)' : 'Apply Filters';
        return CustomButton(
          buttonText: label,
          height: 48,
          onTap: onApply,
        );
      },
    );
  }
}
