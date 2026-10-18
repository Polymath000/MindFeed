import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/widgets/custom_app_bar.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_cubit.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_state.dart';
import 'package:mind_feed/features/collections/presentation/widgets/downloaded_article_card_tile.dart';
import 'package:mind_feed/features/collections/presentation/widgets/downloaded_articles_empty_state.dart';

class DownloadedArticlesViewBody extends StatelessWidget {
  const DownloadedArticlesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
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
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return CustomScrollView(
          slivers: [
            const CustomAppBar(title: 'Your Downloads'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: CustomSearchBar(
                  semanticLabel: 'Search downloaded articles',
                  hintText: 'Search downloads...',
                  onChanged: (query) => cubit.filterArticles(query),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final article = state.filteredArticles[index];
                      return DownloadedArticleCardTile(
                        article: article,
                        isDark: isDark,
                        onDelete: () => cubit.deleteDownload(article.id),
                      );
                    },
                    childCount: state.filteredArticles.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
