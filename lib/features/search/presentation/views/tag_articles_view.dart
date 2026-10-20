import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/core/widgets/article_card.dart';
import 'package:mind_feed/features/search/presentation/controllers/tag_articles_cubit/tag_articles_cubit.dart';
import 'package:mind_feed/features/search/presentation/controllers/tag_articles_cubit/tag_articles_state.dart';

class TagArticlesView extends StatelessWidget {
  final TagArticlesCubit? cubit;
  final String tag;

  const TagArticlesView({super.key, this.cubit, required this.tag});

  static const String routeName = 'tag_articles';

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!,
        child: _TagArticlesBody(tag: tag),
      );
    }
    return BlocProvider(
      create: (_) => getIt<TagArticlesCubit>()..loadArticlesByTag(tag),
      child: _TagArticlesBody(tag: tag),
    );
  }
}

class _TagArticlesBody extends StatelessWidget {
  final String tag;

  const _TagArticlesBody({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(
        backgroundColor: AppColors.ink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.softCream),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          '#$tag',
          style: const TextStyle(
            color: AppColors.softCream,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: BlocBuilder<TagArticlesCubit, TagArticlesState>(
            builder: (context, state) {
              if (state is TagArticlesLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.cream),
                );
              }

              if (state is TagArticlesError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<TagArticlesCubit>()
                              .loadArticlesByTag(tag),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is TagArticlesEmpty) {
                return Center(
                  child: Text(
                    'No articles found with #$tag',
                    style: const TextStyle(
                      color: AppColors.greyText,
                      fontSize: 15,
                    ),
                  ),
                );
              }

              if (state is TagArticlesLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) {
                    return ArticleCard(item: state.articles[index]);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
