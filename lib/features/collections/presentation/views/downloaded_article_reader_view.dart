import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;

import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/category_items.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_empty_view.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_header.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_markdown_body.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_top_bar.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_slow_scroll_bar.dart';

class DownloadedArticleReaderView extends StatefulWidget {
  const DownloadedArticleReaderView({
    super.key,
    required this.article,
  });

  final DownloadedArticleEntity? article;

  @override
  State<DownloadedArticleReaderView> createState() =>
      _DownloadedArticleReaderViewState();
}

class _DownloadedArticleReaderViewState
    extends State<DownloadedArticleReaderView>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final Ticker _ticker;
  late final ValueNotifier<({bool isScrolling, double pace, bool isRetracted})>
      _scrollStateNotifier;
  Duration _lastTick = Duration.zero;
  double _currentPace = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _ticker = createTicker(_onTick);
    _scrollStateNotifier = ValueNotifier((
      isScrolling: false,
      pace: 1.0,
      isRetracted: false,
    ));
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
      _stopSlowScroll();
    }
  }

  void _toggleSlowScroll() {
    final current = _scrollStateNotifier.value;
    final nextScrolling = !current.isScrolling;
    _scrollStateNotifier.value = (
      isScrolling: nextScrolling,
      pace: current.pace,
      isRetracted: current.isRetracted,
    );
    if (nextScrolling) {
      _startTicker(current.pace);
    } else {
      _stopTicker();
    }
  }

  void _setScrollPace(double pace) {
    final current = _scrollStateNotifier.value;
    _scrollStateNotifier.value = (
      isScrolling: current.isScrolling,
      pace: pace,
      isRetracted: current.isRetracted,
    );
    _currentPace = pace;
  }

  void _toggleRetract() {
    final current = _scrollStateNotifier.value;
    _scrollStateNotifier.value = (
      isScrolling: current.isScrolling,
      pace: current.pace,
      isRetracted: !current.isRetracted,
    );
  }

  void _startTicker(double pace) {
    _currentPace = pace;
    _lastTick = Duration.zero;
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  void _stopTicker() {
    if (_ticker.isActive) {
      _ticker.stop();
    }
    _lastTick = Duration.zero;
  }

  void _stopSlowScroll() {
    _stopTicker();
    final current = _scrollStateNotifier.value;
    if (current.isScrolling) {
      _scrollStateNotifier.value = (
        isScrolling: false,
        pace: current.pace,
        isRetracted: current.isRetracted,
      );
    }
  }

  @override
  void dispose() {
    _stopTicker();
    _ticker.dispose();
    _scrollController.dispose();
    _scrollStateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    if (article == null) {
      return const ArticleReaderEmptyView();
    }

    final badgeText = article.categorySlug.isNotEmpty
        ? article.categorySlug.toUpperCase()
        : 'OFFLINE';

    return Scaffold(
      backgroundColor: AppColors.cream,
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
                    ArticleReaderTopBar(
                      badge: badgeText,
                      badgeColor: getCategoryColor(article.categorySlug),
                    ),
                    const SizedBox(height: 16),
                    ArticleReaderMetadataHeader(
                      title: article.title,
                      updated: 'Offline edition',
                      readingTimeMinutes: article.readingTimeMinutes,
                    ),
                    const SizedBox(height: 24),
                    ArticleReaderMarkdownBody(
                      content: article.content,
                      excerpt: article.excerpt,
                      title: article.title,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  left: 20,
                  right: 20,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ValueListenableBuilder<
                        ({bool isScrolling, double pace, bool isRetracted})>(
                      valueListenable: _scrollStateNotifier,
                      builder: (context, state, _) {
                        return ArticleSlowScrollBar(
                          isScrolling: state.isScrolling,
                          currentPace: state.pace,
                          isRetracted: state.isRetracted,
                          onToggleSlowScroll: _toggleSlowScroll,
                          onSelectPace: _setScrollPace,
                          onToggleRetract: _toggleRetract,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
