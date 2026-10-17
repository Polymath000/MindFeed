import 'dart:async';
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
import 'package:mind_feed/features/home/presentation/widgets/widgets/article_slow_scroll_bar.dart';

export 'package:mind_feed/core/design/editorial_models.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({super.key, this.item, this.cubit});
  static const String routeName = 'article';
  final EditorialNewsItem? item;
  final ArticleReaderCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (item == null && cubit == null) return const ArticleReaderEmptyView();
    if (cubit != null) {
      if (cubit!.state.item == null && item != null) cubit!.initArticle(item);
      return BlocProvider<ArticleReaderCubit>.value(value: cubit!, child: _ArticleViewContent(initialItem: item));
    }
    return BlocProvider<ArticleReaderCubit>(
      create: (_) => ArticleReaderCubit()..initArticle(item),
      child: _ArticleViewContent(initialItem: item),
    );
  }
}

class _ArticleViewContent extends StatefulWidget {
  const _ArticleViewContent({this.initialItem});
  final EditorialNewsItem? initialItem;
  @override
  State<_ArticleViewContent> createState() => _ArticleViewContentState();
}

class _ArticleViewContentState extends State<_ArticleViewContent> {
  late final ScrollController _scrollController;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void _restartTimer(double pace) {
    _stopTimer();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 32), (_) {
      if (!mounted || !_scrollController.hasClients) return;
      final step = 1.4 * pace, maxExtent = _scrollController.position.maxScrollExtent;
      final nextOffset = (_scrollController.offset + step).clamp(0.0, maxExtent);
      _scrollController.jumpTo(nextOffset);
      if (nextOffset >= maxExtent && maxExtent > 0) context.read<ArticleReaderCubit>().stopSlowScroll();
    });
  }

  void _stopTimer() { _scrollTimer?.cancel(); _scrollTimer = null; }

  @override
  void dispose() {
    _stopTimer();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticleReaderCubit, ArticleReaderState>(
      listenWhen: (prev, curr) =>
          (curr.userFeedback != null && curr.userFeedback != prev.userFeedback) ||
          curr.isSlowScrolling != prev.isSlowScrolling ||
          curr.scrollPace != prev.scrollPace,
      listener: (context, state) {
        if (state.userFeedback != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 2), content: Text(state.userFeedback!)));
        }
        if (!state.isSlowScrolling) { _stopTimer(); } else { _restartTimer(state.scrollPace); }
      },
      builder: (context, state) {
        final article = state.item ?? widget.initialItem;
        if (article == null) return const ArticleReaderEmptyView();
        final cubit = context.read<ArticleReaderCubit>();

        return Scaffold(
          backgroundColor: article.color,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Stack(
                  children: [
                    ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                      children: [
                        ArticleReaderTopBar(badge: article.badge, badgeColor: article.badgeColor),
                        const SizedBox(height: 16),
                        ArticleReaderMetadataHeader(title: article.title, updated: article.updated, readingTimeMinutes: article.readingTimeMinutes),
                        const SizedBox(height: 16),
                        ArticleReaderAuthorBar(authorName: article.authorName, authorRole: article.authorRole, authorAvatar: article.authorAvatar, authorRatingAvg: state.authorRatingAvg, authorRatingCount: state.authorRatingCount, userAuthorStars: state.userAuthorStars, onRateAuthor: cubit.rateAuthor),
                        if (article.tags.isNotEmpty) ...[const SizedBox(height: 16), ArticleReaderTagsWrap(tags: article.tags)],
                        const SizedBox(height: 20),
                        ArticleReaderCoverImage(
                          coverImageUrl: article.coverImageUrl,
                          overlay: ArticleReaderActionBar(
                            isLiked: state.isLiked, likeCount: state.likeCount, isStarred: state.isStarred,
                            starCount: state.starCount, isSaved: state.isSaved, isDownloaded: state.isDownloaded,
                            onLikeToggle: cubit.toggleLike, onStarToggle: cubit.toggleStar,
                            onBookmarkToggle: cubit.toggleBookmark, onDownload: cubit.downloadArticle,
                            onShare: () => showEditorialShareSheet(context, title: article.title),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ArticleReaderMarkdownBody(content: article.content, excerpt: article.excerpt, title: article.title),
                      ],
                    ),
                    Positioned(
                      bottom: 16, left: 20, right: 20,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ArticleSlowScrollBar(
                          isScrolling: state.isSlowScrolling, currentPace: state.scrollPace,
                          isRetracted: state.isScrollBarRetracted, onToggleSlowScroll: cubit.toggleSlowScroll,
                          onSelectPace: cubit.setScrollPace, onToggleRetract: cubit.toggleScrollBarRetracted,
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
