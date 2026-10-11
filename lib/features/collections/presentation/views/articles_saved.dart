import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_saved_stack.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';
import 'package:mind_feed/features/collections/presentation/cubit/collections_cubit.dart';

class ArticlesSaved extends StatelessWidget {
  const ArticlesSaved({super.key});
  static const String routeName = 'articlesSaved';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CollectionsCubit(),
      child: const _ArticlesSavedContent(),
    );
  }
}

class _ArticlesSavedContent extends StatefulWidget {
  const _ArticlesSavedContent();

  @override
  State<_ArticlesSavedContent> createState() => _ArticlesSavedContentState();
}

class _ArticlesSavedContentState extends State<_ArticlesSavedContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CollectionsCubit>().loadSavedStories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.ink,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
            children: [
              Row(
                children: [
                  EditorialIconButton(
                    icon: AppIcons.arrowBackRounded,
                    label: 'Back',
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Saved News',
                    style: TextStyle(
                      color: AppColors.softCream,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                ],
              ),
              CustomSearchBar(
                controller: _searchController,
                semanticLabel: 'Search saved news',
                hintText: 'Search news',
                trailingSearchIcon: true,
                onChanged: (value) {
                  context.read<CollectionsCubit>().searchStories(value);
                },
              ),
              const SizedBox(height: 8),
              BlocBuilder<CollectionsCubit, CollectionsState>(
                builder: (context, state) {
                  if (state is CollectionsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CollectionsLoaded) {
                    return EditorialSavedStack(
                      items: state.stories,
                      onOpenArticle: (item) => Navigator.pushNamed(context, AppRoutes.article, arguments: item),
                      onDeleteArticle: (item) {
                        context.read<CollectionsCubit>().deleteArticle(item.id);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
