import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_reader_empty_view.dart';

import '../cubit/article_reader/article_reader_cubit.dart';
import '../widgets/article_reader_action_bar.dart';
import '../widgets/article_reader_header.dart';
import '../widgets/article_reader_markdown_body.dart';
import '../widgets/article_reader_top_bar.dart';
import '../widgets/article_slow_scroll_bar.dart';

export 'package:mind_feed/core/design/editorial_models.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({super.key, this.item, this.cubit});
  static const String routeName = 'article';
  final EditorialNewsItem? item;
  final ArticleReaderCubit? cubit;

  ArticleReaderCubit _createCubit() {
    final c = getIt.isRegistered<ArticleReaderCubit>()
        ? getIt<ArticleReaderCubit>()
        : ArticleReaderCubit();
    return c..initArticle(item);
  }

  @override
  Widget build(BuildContext context) {
    if (item == null && cubit == null) return const ArticleReaderEmptyView();
    if (cubit != null) {
      if (cubit!.state.item == null && item != null) cubit!.initArticle(item);
      return BlocProvider<ArticleReaderCubit>.value(
        value: cubit!,
        child: _ArticleViewContent(initialItem: item),
      );
    }
    return BlocProvider<ArticleReaderCubit>(
      create: (_) => _createCubit(),
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

class _ArticleViewContentState extends State<_ArticleViewContent>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;
  double _currentPace = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (!mounted || !_scrollController.hasClients) return;
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (dt <= 0) return;
    const baseSpeed = 43.75;
    final step = baseSpeed * _currentPace * dt;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final nextOffset = (_scrollController.offset + step).clamp(0.0, maxExtent);
    _scrollController.jumpTo(nextOffset);
    if (nextOffset >= maxExtent && maxExtent > 0) {
      context.read<ArticleReaderCubit>().stopSlowScroll();
    }
  }

  void _syncSlowScroll(bool isScrolling, double pace) {
    _currentPace = pace;
    if (!isScrolling) {
      _stopTicker();
    } else if (!_ticker.isActive) {
      _startTicker(pace);
    }
  }

  void _startTicker(double pace) {
    _currentPace = pace;
    _lastTick = Duration.zero;
    if (!_ticker.isActive) _ticker.start();
  }

  void _stopTicker() {
    if (_ticker.isActive) _ticker.stop();
    _lastTick = Duration.zero;
  }

  void _showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _stopTicker();
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = context.select<ArticleReaderCubit, EditorialNewsItem?>(
      (c) => c.state.item,
    ) ?? widget.initialItem;
    if (article == null) return const ArticleReaderEmptyView();

    return BlocListener<ArticleReaderCubit, ArticleReaderState>(
      listenWhen: (prev, curr) =>
          (curr.userFeedback != null &&
              curr.userFeedback != prev.userFeedback) ||
          curr.isSlowScrolling != prev.isSlowScrolling ||
          curr.scrollPace != prev.scrollPace,
      listener: (context, state) {
        if (state.userFeedback != null) {
          _showFeedback(context, state.userFeedback!);
        }
        _syncSlowScroll(state.isSlowScrolling, state.scrollPace);
      },
      child: Scaffold(
        backgroundColor: article.color,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Stack(
                children: [
                  _ArticleReaderScrollView(
                    controller: _scrollController,
                    article: article,
                  ),
                  const Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: _ArticleSlowScrollBarSection(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleReaderScrollView extends StatelessWidget {
  const _ArticleReaderScrollView({
    required this.controller,
    required this.article,
  });

  final ScrollController controller;
  final EditorialNewsItem article;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
      children: [
        ArticleReaderTopBar(
          badge: article.badge,
          badgeColor: article.badgeColor,
        ),
        const SizedBox(height: 16),
        ArticleReaderMetadataHeader(
          title: article.title,
          updated: article.updated,
          readingTimeMinutes: article.readingTimeMinutes,
        ),
        const SizedBox(height: 16),
        _ArticleAuthorSection(article: article),
        if (article.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          ArticleReaderTagsWrap(tags: article.tags),
        ],
        const SizedBox(height: 20),
        ArticleReaderCoverImage(
          coverImageUrl: article.coverImageUrl,
          overlay: _ArticleActionBarSection(title: article.title),
        ),
        const SizedBox(height: 24),
        ArticleReaderMarkdownBody(
          content: article.content,
          excerpt: article.excerpt,
          title: article.title,
        ),
      ],
    );
  }
}

class _ArticleAuthorSection extends StatelessWidget {
  const _ArticleAuthorSection({required this.article});
  final EditorialNewsItem article;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ArticleReaderCubit>();
    return BlocSelector<ArticleReaderCubit, ArticleReaderState,
        ({double avg, int count, int stars})>(
      selector: (state) => (
        avg: state.authorRatingAvg,
        count: state.authorRatingCount,
        stars: state.userAuthorStars,
      ),
      builder: (context, ratings) {
        return ArticleReaderAuthorBar(
          authorName: article.authorName,
          authorRole: article.authorRole,
          authorAvatar: article.authorAvatar,
          authorRatingAvg: ratings.avg,
          authorRatingCount: ratings.count,
          userAuthorStars: ratings.stars,
          onRateAuthor: cubit.rateAuthor,
        );
      },
    );
  }
}

class _ArticleActionBarSection extends StatelessWidget {
  const _ArticleActionBarSection({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ArticleReaderCubit>();
    return BlocSelector<ArticleReaderCubit, ArticleReaderState,
        ({bool isLiked, int likeCount, bool isStarred, int starCount, bool isSaved, bool isDownloaded})>(
      selector: (state) => (
        isLiked: state.isLiked,
        likeCount: state.likeCount,
        isStarred: state.isStarred,
        starCount: state.starCount,
        isSaved: state.isSaved,
        isDownloaded: state.isDownloaded,
      ),
      builder: (context, data) {
        return ArticleReaderActionBar(
          isLiked: data.isLiked,
          likeCount: data.likeCount,
          isStarred: data.isStarred,
          starCount: data.starCount,
          isSaved: data.isSaved,
          isDownloaded: data.isDownloaded,
          onLikeToggle: cubit.toggleLike,
          onStarToggle: cubit.toggleStar,
          onBookmarkToggle: cubit.toggleBookmark,
          onDownload: cubit.downloadArticle,
          onShare: () => showEditorialShareSheet(context, title: title),
        );
      },
    );
  }
}

class _ArticleSlowScrollBarSection extends StatelessWidget {
  const _ArticleSlowScrollBarSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ArticleReaderCubit>();
    return BlocSelector<ArticleReaderCubit, ArticleReaderState,
        ({bool isScrolling, double pace, bool isRetracted})>(
      selector: (state) => (
        isScrolling: state.isSlowScrolling,
        pace: state.scrollPace,
        isRetracted: state.isScrollBarRetracted,
      ),
      builder: (context, data) {
        return ArticleSlowScrollBar(
          isScrolling: data.isScrolling,
          currentPace: data.pace,
          isRetracted: data.isRetracted,
          onToggleSlowScroll: cubit.toggleSlowScroll,
          onSelectPace: cubit.setScrollPace,
          onToggleRetract: cubit.toggleScrollBarRetracted,
        );
      },
    );
  }
}
