import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_state.dart';
import 'package:mind_feed/features/profile/presentation/widget/custom_article_card_of_profile.dart';
import 'package:mind_feed/features/profile/presentation/widget/profile_articles_status_views.dart';

class UserArticles extends StatelessWidget {
  final ProfileArticlesCubit? cubit;

  const UserArticles({super.key, this.cubit});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      sliver: SliverToBoxAdapter(
        child: _buildScope(context),
      ),
    );
  }

  Widget _buildScope(BuildContext context) {
    if (cubit != null) {
      return BlocProvider<ProfileArticlesCubit>.value(
        value: cubit!,
        child: const _UserArticlesBody(),
      );
    }

    ProfileArticlesCubit? existingCubit;
    try {
      existingCubit = BlocProvider.of<ProfileArticlesCubit>(context);
    } catch (_) {}

    if (existingCubit != null) {
      return const _UserArticlesBody();
    }

    return BlocProvider<ProfileArticlesCubit>(
      create: (_) => ProfileArticlesCubit()..loadArticles(),
      child: const _UserArticlesBody(),
    );
  }
}

class _UserArticlesBody extends StatelessWidget {
  const _UserArticlesBody();

  String _buildCountLabel(int publishedCount, int draftCount) {
    if (draftCount > 0 && publishedCount > 0) {
      return '$publishedCount published · $draftCount ${draftCount == 1 ? 'draft' : 'drafts'}';
    } else if (draftCount > 0) {
      return '$draftCount ${draftCount == 1 ? 'draft' : 'drafts'}';
    } else {
      return '$publishedCount published';
    }
  }

  Future<void> _handleDelete(BuildContext context, EditorialNewsItem item) async {
    final confirmed = await showDeleteArticleDialog(context, item);
    if (confirmed != true || !context.mounted) return;

    final cubit = context.read<ProfileArticlesCubit>();
    final success = await cubit.deleteArticle(item.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          success
              ? 'Removed: ${item.title.split('\n').first}'
              : 'Failed to delete article. Please try again.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileArticlesCubit, ProfileArticlesState>(
      builder: (context, state) {
        final int publishedCount = state is ProfileArticlesLoaded ? state.publishedCount : 0;
        final int draftCount = state is ProfileArticlesLoaded ? state.draftCount : 0;
        final bool showBadge = state is ProfileArticlesLoaded || state is ProfileArticlesEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Articles',
                  style: TextStyle(
                    color: AppColors.softCream,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                if (showBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Text(
                      _buildCountLabel(publishedCount, draftCount),
                      style: const TextStyle(
                        color: AppColors.cream,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            if (state is ProfileArticlesLoading)
              const ProfileArticlesLoadingView()
            else if (state is ProfileArticlesError)
              ProfileArticlesErrorView(
                message: state.message,
                onRetry: () => context.read<ProfileArticlesCubit>().loadArticles(),
              )
            else if (state is ProfileArticlesEmpty)
              const ProfileArticlesEmptyView()
            else if (state is ProfileArticlesLoaded)
              ...state.articles.map(
                (item) => CustomArticleCardOfProfile(
                  item: item,
                  onEdit: () async {
                    await Navigator.pushNamed(context, AppRoutes.addArticle, arguments: item);
                    if (context.mounted) {
                      context.read<ProfileArticlesCubit>().loadArticles();
                    }
                  },
                  onDelete: () => _handleDelete(context, item),
                ),
              ),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}
