import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/home/presentation/cubit/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/home/presentation/cubit/article_reader/article_reader_state.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/article_reader_action_bar.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/article_reader_header.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/article_reader_markdown_body.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/article_reader_top_bar.dart';

export 'package:mind_feed/core/design/editorial_models.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({
    super.key,
    this.item,
    this.cubit,
  });

  static const String routeName = 'article';
  final EditorialNewsItem? item;
  final ArticleReaderCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (item == null && cubit == null) {
      return const ArticleReaderEmptyView();
    }

    if (cubit != null) {
      return BlocProvider<ArticleReaderCubit>.value(
        value: cubit!,
        child: _ArticleViewContent(initialItem: item),
      );
    }

    return BlocProvider<ArticleReaderCubit>(
      create: (_) => ArticleReaderCubit()..initArticle(item),
      child: _ArticleViewContent(initialItem: item),
    );
  }
}

class _ArticleViewContent extends StatelessWidget {
  const _ArticleViewContent({this.initialItem});

  final EditorialNewsItem? initialItem;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticleReaderCubit, ArticleReaderState>(
      listenWhen: (previous, current) =>
          current.userFeedback != null &&
          current.userFeedback != previous.userFeedback,
      listener: (context, state) {
        if (state.userFeedback != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(state.userFeedback!),
            ),
          );
        }
      },
      builder: (context, state) {
        final article = state.item ?? initialItem;
        if (article == null) {
          return const ArticleReaderEmptyView();
        }

        final cubit = context.read<ArticleReaderCubit>();

        return Scaffold(
          backgroundColor: article.color,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
                  children: [
                    ArticleReaderTopBar(
                      badge: article.badge,
                      badgeColor: article.badgeColor,
                    ),
                    const SizedBox(height: 20),
                    ArticleReaderMetadataHeader(
                      title: article.title,
                      updated: article.updated,
                      readingTimeMinutes: article.readingTimeMinutes,
                    ),
                    const SizedBox(height: 16),
                    ArticleReaderAuthorBar(
                      authorName: article.authorName,
                      authorRole: article.authorRole,
                      authorAvatar: article.authorAvatar,
                    ),
                    if (article.tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ArticleReaderTagsWrap(tags: article.tags),
                    ],
                    const SizedBox(height: 22),
                    ArticleReaderCoverImage(
                      coverImageUrl: article.coverImageUrl,
                      overlay: ArticleReaderActionBar(
                        isStarred: state.isStarred,
                        starCount: state.starCount,
                        isSaved: state.isSaved,
                        isDownloaded: state.isDownloaded,
                        onStarToggle: cubit.toggleStar,
                        onBookmarkToggle: cubit.toggleBookmark,
                        onDownload: cubit.downloadArticle,
                        onShare: () => showEditorialShareSheet(
                          context,
                          title: article.title,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ArticleReaderMarkdownBody(
                      content: article.content,
                      excerpt: article.excerpt,
                      title: article.title,
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
