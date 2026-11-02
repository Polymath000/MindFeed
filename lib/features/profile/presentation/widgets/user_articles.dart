import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_state.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/widgets/custom_article_card_of_profile.dart';
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

  void _refreshProfile(BuildContext context) {
    context.read<ProfileArticlesCubit>().loadArticles();
    try {
      BlocProvider.of<ProfileInfoCubit>(context).loadProfileData();
    } catch (_) {}
  }

  Future<void> _handleDelete(BuildContext context, EditorialNewsItem item) async {
    final confirmed = await showDeleteArticleDialog(context, item);
    if (confirmed != true || !context.mounted) return;
    final success = await context.read<ProfileArticlesCubit>().deleteArticle(item.id);
    if (!context.mounted) return;
    if (success) {
      try {
        BlocProvider.of<ProfileInfoCubit>(context).loadProfileData();
      } catch (_) {}
    }
    customShowSnackBar(
      context: context,
      duration: const Duration(seconds: 2),
      message: success
          ? 'Removed: ${item.title.split('\n').first}'
          : 'Failed to delete article. Please try again.',
    );
  }

  Future<void> _openAddArticle(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.addArticle);
    if (context.mounted) {
      _refreshProfile(context);
    }
  }

  Future<void> _openDrafts(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.drafts);
    if (context.mounted) {
      _refreshProfile(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileArticlesCubit, ProfileArticlesState>(
      builder: (context, state) {
        final publishedCount =
            state is ProfileArticlesLoaded ? state.publishedCount : 0;
        final draftCount =
            state is ProfileArticlesLoaded ? state.draftCount : 0;
        final showBadge =
            state is ProfileArticlesLoaded || state is ProfileArticlesEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 10,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.charcoal,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderDark),
                        ),
                        child: Text(
                          '$publishedCount published',
                          style: const TextStyle(
                            color: AppColors.cream,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton.icon(
                      key: const Key('profile_drafts_button'),
                      onPressed: () => _openDrafts(context),
                      icon: const Icon(
                        AppIcons.draftsOutlined,
                        size: 16,
                        color: AppColors.cream,
                      ),
                      label: Text(
                        draftCount > 0 ? 'Drafts ($draftCount)' : 'Drafts',
                        style: const TextStyle(
                          color: AppColors.cream,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        backgroundColor: AppColors.charcoal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.borderDark),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      key: const Key('profile_write_button'),
                      onPressed: () => _openAddArticle(context),
                      icon: const Icon(
                        AppIcons.edit,
                        size: 16,
                        color: AppColors.cream,
                      ),
                      label: const Text(
                        'Write',
                        style: TextStyle(
                          color: AppColors.cream,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        backgroundColor: AppColors.charcoal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.borderDark),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (state is ProfileArticlesLoading)
              const ProfileArticlesLoadingView()
            else if (state is ProfileArticlesError)
              ProfileArticlesErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<ProfileArticlesCubit>().loadArticles(),
              )
            else if (state is ProfileArticlesEmpty ||
                (state is ProfileArticlesLoaded &&
                    state.publishedArticles.isEmpty))
              ProfileArticlesEmptyView(
                onCreateArticle: () => _openAddArticle(context),
              )
            else if (state is ProfileArticlesLoaded)
              ...state.publishedArticles.map(
                (item) => CustomArticleCardOfProfile(
                  item: item,
                  onEdit: () async {
                    await Navigator.pushNamed(
                      context,
                      AppRoutes.addArticle,
                      arguments: item,
                    );
                    if (context.mounted) {
                      _refreshProfile(context);
                    }
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
