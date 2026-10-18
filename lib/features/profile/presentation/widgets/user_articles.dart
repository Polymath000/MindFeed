import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_state.dart';
import 'package:mind_feed/core/widgets/article_card.dart';
import 'package:mind_feed/features/profile/presentation/widgets/profile_articles_status_views.dart';

class UserArticles extends StatelessWidget {
  final ProfileArticlesCubit? cubit;

  const UserArticles({super.key, this.cubit});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      sliver: SliverToBoxAdapter(child: _buildScope(context)),
    );
  }

  Widget _buildScope(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(value: cubit!, child: const _UserArticlesBody());
    }
    try {
      BlocProvider.of<ProfileArticlesCubit>(context);
      return const _UserArticlesBody();
    } catch (_) {}
    return BlocProvider(
      create: (_) => GetIt.instance<ProfileArticlesCubit>()..loadArticles(),
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
    }
    return '$publishedCount published';
  }

  Future<void> _handleDelete(BuildContext context, EditorialNewsItem item) async {
    final confirmed = await showDeleteArticleDialog(context, item);
    if (confirmed != true || !context.mounted) return;
    final success = await context.read<ProfileArticlesCubit>().deleteArticle(item.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(success ? 'Removed: ${item.title.split('\n').first}' : 'Failed to delete article. Please try again.'),
    ));
  }

  Future<void> _openAddArticle(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.addArticle);
    if (context.mounted) context.read<ProfileArticlesCubit>().loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileArticlesCubit, ProfileArticlesState>(
      builder: (context, state) {
        final publishedCount = state is ProfileArticlesLoaded ? state.publishedCount : 0;
        final draftCount = state is ProfileArticlesLoaded ? state.draftCount : 0;
        final showBadge = state is ProfileArticlesLoaded || state is ProfileArticlesEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'My Articles',
                    style: TextStyle(
                      color: AppColors.softCream,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showBadge) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.charcoal, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderDark)),
                    child: Text(_buildCountLabel(publishedCount, draftCount), style: const TextStyle(color: AppColors.cream, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _openAddArticle(context),
                  icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.cream),
                  label: const Text('Write', style: TextStyle(color: AppColors.cream, fontSize: 13, fontWeight: FontWeight.w700)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    backgroundColor: AppColors.charcoal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.borderDark)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (state is ProfileArticlesLoading)
              const ProfileArticlesLoadingView()
            else if (state is ProfileArticlesError)
              ProfileArticlesErrorView(message: state.message, onRetry: () => context.read<ProfileArticlesCubit>().loadArticles())
            else if (state is ProfileArticlesEmpty)
              ProfileArticlesEmptyView(onCreateArticle: () => _openAddArticle(context))
            else if (state is ProfileArticlesLoaded)
              ...state.articles.map(
                (item) => CustomArticleCardOfProfile(
                  item: item,
                  onEdit: () async {
                    await Navigator.pushNamed(context, AppRoutes.addArticle, arguments: item);
                    if (context.mounted) context.read<ProfileArticlesCubit>().loadArticles();
                  },
                  onDelete: () => _handleDelete(context, item),
                ),
              ),
            SizedBox(height: 100 + MediaQuery.viewPaddingOf(context).bottom),
          ],
        );
      },
    );
  }
}
