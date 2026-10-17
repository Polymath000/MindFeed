import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/design/editorial_card_stack.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';

import '../cubit/home_feed/home_feed_cubit.dart';
import '../cubit/home_feed/home_feed_state.dart';
import 'home_feed_empty_view.dart';
import 'home_feed_error_view.dart';
import 'home_feed_loading_views.dart';
import 'home_lead_story_section.dart';
import 'home_masthead_header.dart';
import 'home_write_article_fab.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key, this.cubit});

  final HomeFeedCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider<HomeFeedCubit>.value(
        value: cubit!,
        child: const _HomeViewBodyContent(),
      );
    }
    return BlocProvider<HomeFeedCubit>(
      create: (_) => _createCubit()..fetchFeed(),
      child: const _HomeViewBodyContent(),
    );
  }

  HomeFeedCubit _createCubit() => getIt.isRegistered<HomeFeedCubit>()
      ? getIt<HomeFeedCubit>()
      : HomeFeedCubit();
}

class _HomeViewBodyContent extends StatelessWidget {
  const _HomeViewBodyContent();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Material(
      color: AppColors.transparent,
      child: Stack(
        children: [
          SafeArea(
            top: true,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _HomeFeedScrollArea(bottomInset: bottomInset),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 88 + bottomInset,
            child: const HomeWriteArticleFab(),
          ),
        ],
      ),
    );
  }
}

class _HomeFeedScrollArea extends StatelessWidget {
  const _HomeFeedScrollArea({required this.bottomInset});

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeFeedCubit, HomeFeedState>(
      builder: (context, state) {
        final stories = state.filteredArticles;
        final isLoading =
            state is HomeFeedLoading || state is HomeFeedInitial;
        final showLoadedStories =
            state is HomeFeedLoaded && stories.isNotEmpty;

        return CustomScrollView(
          slivers: [
            _buildTopSliver(context, state, stories, isLoading, showLoadedStories),
            if (showLoadedStories)
              _SecondaryStoriesSliver(
                stories: stories,
                bottomInset: bottomInset,
              ),
          ],
        );
      },
    );
  }

  Widget _buildTopSliver(
    BuildContext context,
    HomeFeedState state,
    List<EditorialNewsItem> stories,
    bool isLoading,
    bool showLoadedStories,
  ) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppConstants.page,
        12,
        AppConstants.page,
        showLoadedStories ? 12 : 152 + bottomInset,
      ),
      sliver: SliverToBoxAdapter(
        child: _HomeHeaderAndLeadSection(
          state: state,
          stories: stories,
          isLoading: isLoading,
        ),
      ),
    );
  }
}

class _HomeHeaderAndLeadSection extends StatelessWidget {
  const _HomeHeaderAndLeadSection({
    required this.state,
    required this.stories,
    required this.isLoading,
  });

  final HomeFeedState state;
  final List<EditorialNewsItem> stories;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeFeedCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HomeMastheadHeader(),
        const SizedBox(height: 20),
        _buildTopicsSkeleton(cubit),
        const SizedBox(height: 18),
        _buildMainBody(context, cubit),
      ],
    );
  }

  Widget _buildTopicsSkeleton(HomeFeedCubit cubit) {
    final displayTopics = isLoading && state.topics.length <= 1
        ? const ['All', 'Category', 'Category', 'Category']
        : state.topics;
    return Skeletonizer(
      enabled: isLoading,
      effect: HomeFeedLoadingView.editorialShimmerEffect,
      child: HomeTopicTabsBar(
        topics: displayTopics,
        selectedTopic: state.selectedTopic,
        onTopicSelected: cubit.selectTopic,
      ),
    );
  }

  Widget _buildMainBody(BuildContext context, HomeFeedCubit cubit) {
    return switch (state) {
      HomeFeedInitial() || HomeFeedLoading() => const HomeFeedLoadingView(),
      HomeFeedError(:final errorMessage) when errorMessage != null =>
        HomeFeedErrorView(errorMessage: errorMessage, onRetry: cubit.fetchFeed),
      _ when stories.isEmpty => HomeFeedEmptyView(onRefresh: cubit.fetchFeed),
      _ => _LoadedDeckSection(
          selectedTopic: state.selectedTopic,
          stories: stories,
        ),
    };
  }
}

class _LoadedDeckSection extends StatelessWidget {
  const _LoadedDeckSection({
    required this.selectedTopic,
    required this.stories,
  });

  final String selectedTopic;
  final List<EditorialNewsItem> stories;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeFeedCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EditorialCardStack(
          key: ValueKey(selectedTopic),
          items: stories,
          height: 570,
          onOpenArticle: (item) =>
              Navigator.pushNamed(context, AppRoutes.article, arguments: item),
          onSwipeRight: (item) => _handleSwipeSave(context, cubit, item),
          onToggleSave: cubit.toggleBookmark,
          onToggleLike: cubit.toggleStar,
        ),
        const SizedBox(height: 24),
        const Text('More Stories', style: AppTextStyles.homeSectionTitle),
      ],
    );
  }

  Future<void> _handleSwipeSave(
    BuildContext context,
    HomeFeedCubit cubit,
    EditorialNewsItem item,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final status = await cubit.saveArticleWithStatus(item);
    final message = switch (status) {
      SwipeSaveStatus.saved => 'Saved "${item.title.replaceAll('\n', ' ')}"',
      SwipeSaveStatus.unauthenticated => 'Sign in to save articles',
      SwipeSaveStatus.failed => 'Failed to save article',
    };
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(message),
        ),
      );
  }
}

class _SecondaryStoriesSliver extends StatelessWidget {
  const _SecondaryStoriesSliver({
    required this.stories,
    required this.bottomInset,
  });

  final List<EditorialNewsItem> stories;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeFeedCubit>();
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppConstants.page,
        0,
        AppConstants.page,
        152 + bottomInset,
      ),
      sliver: SliverList.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final item = stories[index];
          return RepaintBoundary(
            child: HomeSecondaryStoryTile(
              item: item,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.article,
                arguments: item,
              ),
              onToggleSave: () => cubit.toggleBookmark(item),
            ),
          );
        },
      ),
    );
  }
}
