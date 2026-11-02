import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/core/widgets/editorial_filter_dialog.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';

import '../controllers/search_cubit.dart';
import '../widgets/search_filter_chips_bar.dart';
import '../widgets/search_results_view.dart';

class SearchView extends StatelessWidget {
  final SearchCubit? cubit;

  const SearchView({super.key, this.cubit});
  static const String routeName = 'search';

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider<SearchCubit>.value(
        value: cubit!,
        child: const _SearchViewContent(),
      );
    }
    return BlocProvider<SearchCubit>(
      create: (_) => getIt<SearchCubit>(),
      child: const _SearchViewContent(),
    );
  }
}

class _SearchViewContent extends StatelessWidget {
  const _SearchViewContent();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Material(
      color: AppColors.transparent,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 100 + bottomInset),
              children: const [
                Text('Search', style: AppTextStyles.searchHeaderTitle),
                _SearchBarAndFilterRow(),
                _ActiveFiltersSection(),
                _SearchResultsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBarAndFilterRow extends StatelessWidget {
  const _SearchBarAndFilterRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();
        final activeCount = (state.selectedCategory != null ? 1 : 0) +
            state.selectedTags.length;

        return Row(
          children: [
            Expanded(
              child: CustomSearchBar(onChanged: cubit.onQueryChanged),
            ),
            const SizedBox(width: 10),
            SearchFilterTriggerButton(
              activeCount: activeCount,
              onTap: () => _openFilterDialog(context, cubit, state),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openFilterDialog(
    BuildContext context,
    SearchCubit cubit,
    SearchState state,
  ) async {
    FocusScope.of(context).unfocus();
    final categoryOptions = state.categories
        .map(
          (c) => EditorialFilterOption(
            id: c.id,
            label: c.name,
            icon: AppIcons.getCategoryIcon(c.name),
          ),
        )
        .toList();
    final tagNames = state.tags.map((t) => t.name).toList();

    final selection = await showEditorialFilterDialog(
      context: context,
      categories: categoryOptions,
      tags: tagNames,
      initialCategoryId: state.selectedCategory?.id,
      initialTags: state.selectedTags,
    );
    if (selection == null) return;

    CategoryEntity? chosenCategory;
    if (selection.selectedCategoryId != null) {
      for (final category in state.categories) {
        if (category.id == selection.selectedCategoryId) {
          chosenCategory = category;
          break;
        }
      }
    }
    await cubit.applyFilters(
      category: chosenCategory,
      tags: selection.selectedTags,
    );
  }
}

class _ActiveFiltersSection extends StatelessWidget {
  const _ActiveFiltersSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();
        return SearchActiveFiltersBar(
          selectedCategory: state.selectedCategory,
          selectedTags: state.selectedTags,
          onClearCategory: () => cubit.selectCategory(null),
          onRemoveTag: cubit.toggleTag,
          onClearAll: cubit.clearFilters,
        );
      },
    );
  }
}

class _SearchResultsSection extends StatelessWidget {
  const _SearchResultsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.cream),
            ),
          );
        }
        if (state is SearchError) {
          return SearchErrorView(
            message: state.message,
            onRetry: () => context.read<SearchCubit>().retry(),
          );
        }
        if (state is SearchEmpty) {
          return const SearchEmptyView();
        }
        if (state is SearchLoaded) {
          return SearchResultsList(results: state.results);
        }
        return const SearchInitialPromptView();
      },
    );
  }
}
