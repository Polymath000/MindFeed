import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/home/presentation/cubit/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/home/presentation/views/article_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_reader_empty_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_reader_scroll_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_slow_scroll_bar_section.dart';

class ArticleViewContent extends StatefulWidget {
  const ArticleViewContent({super.key, this.initialItem});
  final EditorialNewsItem? initialItem;

  @override
  State<ArticleViewContent> createState() => _ArticleViewContentState();
}

class _ArticleViewContentState extends State<ArticleViewContent>
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
      SnackBar(duration: const Duration(seconds: 2), content: Text(message)),
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
    final article =
        context.select<ArticleReaderCubit, EditorialNewsItem?>(
          (c) => c.state.item,
        ) ??
        widget.initialItem;
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
                  ArticleReaderScrollView(
                    controller: _scrollController,
                    article: article,
                  ),
                  const Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ArticleSlowScrollBarSection(),
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
