import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_saved_stack.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';
import 'package:mind_feed/features/collections/presentation/cubit/collections_cubit.dart';

class ArticlesSaved extends StatelessWidget {
  const ArticlesSaved({super.key, this.refreshSeed = 0});
  static const String routeName = 'articlesSaved';
  final int refreshSeed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CollectionsCubit(),
      child: _ArticlesSavedContent(refreshSeed: refreshSeed),
    );
  }
}

class _ArticlesSavedContent extends StatefulWidget {
  const _ArticlesSavedContent({this.refreshSeed = 0});
  final int refreshSeed;

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
  void didUpdateWidget(covariant _ArticlesSavedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshSeed != oldWidget.refreshSeed) {
      context.read<CollectionsCubit>().loadSavedStories();
    }
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
                  EditorialIconButton(icon: AppIcons.arrowBackRounded, label: 'Back', onPressed: () => Navigator.maybePop(context)),
                  const SizedBox(width: 12),
                  const Text('Saved News', style: TextStyle(color: AppColors.softCream, fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -0.6)),
                ],
              ),
              CustomSearchBar(
                controller: _searchController,
                semanticLabel: 'Search saved news',
                hintText: 'Search news',
                trailingSearchIcon: true,
                onChanged: (value) => context.read<CollectionsCubit>().searchStories(value),
              ),
              const SizedBox(height: 8),
              BlocBuilder<CollectionsCubit, CollectionsState>(
                builder: (context, state) {
                  if (state is CollectionsLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator(color: AppColors.cream)),
                    );
                  } else if (state is CollectionsError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_rounded, color: AppColors.softCream, size: 44),
                          const SizedBox(height: 12),
                          Text(state.message, textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.softCream, fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cream,
                              foregroundColor: AppColors.ink,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            ),
                            onPressed: () => context.read<CollectionsCubit>().loadSavedStories(),
                            child: const Text('Retry', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    );
                  } else if (state is CollectionsEmpty || (state is CollectionsLoaded && state.stories.isEmpty)) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Text(
                          'No saved articles yet.',
                          style: TextStyle(color: AppColors.greyText, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  } else if (state is CollectionsLoaded) {
                    return EditorialSavedStack(
                      items: state.stories,
                      onOpenArticle: (item) => Navigator.pushNamed(context, AppRoutes.article, arguments: item),
                      onDeleteArticle: (item) => context.read<CollectionsCubit>().deleteArticle(item.id),
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
