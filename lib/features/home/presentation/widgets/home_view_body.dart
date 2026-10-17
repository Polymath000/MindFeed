import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/design/editorial_card_stack.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/home/presentation/cubit/home_feed/home_feed_cubit.dart';
import 'package:mind_feed/features/home/presentation/cubit/home_feed/home_feed_state.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/home_breathing_background.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/home_feed_status_views.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/home_lead_story_section.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/home_masthead_header.dart';

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
      create: (_) => HomeFeedCubit()..fetchFeed(),
      child: const _HomeViewBodyContent(),
    );
  }
}

class _HomeViewBodyContent extends StatelessWidget {
  const _HomeViewBodyContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: HomeBreathingBackground()),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: BlocBuilder<HomeFeedCubit, HomeFeedState>(
                builder: (context, state) {
                  final cubit = context.read<HomeFeedCubit>();
                  final stories = state.filteredArticles;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(AppConstants.page, 12, AppConstants.page, 96),
                    children: [
                      const HomeMastheadHeader(),
                      const SizedBox(height: 20),
                      HomeTopicTabsBar(
                        topics: state.topics,
                        selectedTopic: state.selectedTopic,
                        onTopicSelected: cubit.selectTopic,
                      ),
                      const SizedBox(height: 18),
                      if (state.status == HomeFeedStatus.loading || state.status == HomeFeedStatus.initial)
                        const HomeFeedLoadingView()
                      else if (state.status == HomeFeedStatus.error && state.errorMessage != null)
                        HomeFeedErrorView(errorMessage: state.errorMessage!, onRetry: cubit.fetchFeed)
                      else if (stories.isEmpty)
                        HomeFeedEmptyView(onRefresh: cubit.fetchFeed)
                      else ...[
                        EditorialCardStack(
                          key: ValueKey(state.selectedTopic),
                          items: stories,
                          height: 570,
                          onOpenArticle: (item) => Navigator.pushNamed(context, AppRoutes.article, arguments: item),
                          onSwipeRight: (item) async {
                            final messenger = ScaffoldMessenger.of(context);
                            final saved = await cubit.saveArticleOnSwipeRight(item);
                            messenger.clearSnackBars();
                            final isLogged = CurrentUserSession.currentUserId != null && CurrentUserSession.currentUserId!.isNotEmpty;
                            messenger.showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Text(
                                  saved
                                      ? 'Saved "${item.title.replaceAll('\n', ' ')}"'
                                      : (!isLogged ? 'Sign in to save articles' : 'Failed to save article'),
                                ),
                              ),
                            );
                          },
                          onSwipeLeft: (item) {
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text('Skipped: ${item.title.split('\n').first}'),
                                ),
                              );
                          },
                          onToggleSave: cubit.toggleBookmark,
                          onToggleLike: cubit.toggleStar,
                        ),
                        if (stories.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'More Stories',
                            style: TextStyle(
                              color: AppColors.softCream,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...stories.map(
                            (item) => HomeSecondaryStoryTile(
                              item: item,
                              onTap: () => Navigator.pushNamed(context, AppRoutes.article, arguments: item),
                              onToggleSave: () => cubit.toggleBookmark(item),
                            ),
                          ),
                        ],
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
