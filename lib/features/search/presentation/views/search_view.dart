import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';
import 'package:mind_feed/features/search/presentation/cubit/search_cubit.dart';
import 'package:mind_feed/features/search/presentation/widgets/search_filter_chips_bar.dart';
import 'package:mind_feed/features/search/presentation/widgets/search_results_view.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});
  static const String routeName = 'search';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const _SearchViewContent(),
    );
  }
}

class _SearchViewContent extends StatelessWidget {
  const _SearchViewContent();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.ink,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 132),
            children: [
              const Text(
                'Search',
                style: TextStyle(
                  color: AppColors.softCream,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              CustomSearchBar(
                onChanged: (val) {
                  context.read<SearchCubit>().onQueryChanged(val);
                },
              ),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  final cubit = context.read<SearchCubit>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchCategoryChipsBar(
                        categories: state.categories,
                        selectedCategory: state.selectedCategory,
                        onCategorySelected: cubit.selectCategory,
                      ),
                      SearchTagChipsBar(
                        tags: state.tags,
                        selectedTags: state.selectedTags,
                        onTagToggled: cubit.toggleTag,
                      ),
                    ],
                  );
                },
              ),
              BlocBuilder<SearchCubit, SearchState>(
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
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
