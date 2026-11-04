import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_cubit.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_state.dart';
import 'package:mind_feed/features/collections/presentation/widgets/downloaded_article_card_tile.dart';
import 'package:mind_feed/features/collections/presentation/widgets/downloaded_articles_empty_state.dart';

class DownloadedArticlesViewBody extends StatefulWidget {
  const DownloadedArticlesViewBody({super.key, this.refreshSeed = 0});

  final int refreshSeed;

  @override
  State<DownloadedArticlesViewBody> createState() =>
      _DownloadedArticlesViewBodyState();
}

class _DownloadedArticlesViewBodyState
    extends State<DownloadedArticlesViewBody> {
  @override
  void didUpdateWidget(covariant DownloadedArticlesViewBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshSeed != oldWidget.refreshSeed) {
      context.read<DownloadsCubit>().loadDownloads();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<DownloadsCubit, DownloadsState>(
      listenWhen: (prev, curr) =>
          curr.feedbackMessage != null &&
          curr.feedbackMessage != prev.feedbackMessage,
      listener: (context, state) {
        if (state.feedbackMessage != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(state.feedbackMessage!),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<DownloadsCubit>();

        return Material(
          color: Navigator.canPop(context) ? AppColors.ink : Colors.transparent,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (Navigator.canPop(context)) ...[
                                  EditorialIconButton(
                                    icon: AppIcons.arrowBackRounded,
                                    label: 'Back',
                                    onPressed: () => Navigator.maybePop(context),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                const Text(
                                  'Downloads',
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
                              semanticLabel: 'Search downloaded articles',
                              hintText: 'Search downloads...',
                              trailingSearchIcon: true,
                              onChanged: (query) => cubit.filterArticles(query),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.status == DownloadsStatus.loading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (state.filteredArticles.isEmpty)
                      DownloadedArticlesEmptyState(
                        searchQuery: state.searchQuery,
                        isDark: isDark,
                      )
                    else
                      SliverPadding(
                        padding:
                            EdgeInsets.fromLTRB(20, 0, 20, 100 + bottomInset),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final article = state.filteredArticles[index];
                              return DownloadedArticleCardTile(
                                article: article,
                                isDark: isDark,
                                onDelete: () =>
                                    cubit.deleteDownload(article.id),
                              );
                            },
                            childCount: state.filteredArticles.length,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
