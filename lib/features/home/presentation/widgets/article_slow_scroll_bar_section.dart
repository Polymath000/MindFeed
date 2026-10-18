import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/features/home/presentation/cubit/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_slow_scroll_bar.dart';

class ArticleSlowScrollBarSection extends StatelessWidget {
  const ArticleSlowScrollBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ArticleReaderCubit>();
    return BlocSelector<
      ArticleReaderCubit,
      ArticleReaderState,
      ({bool isScrolling, double pace, bool isRetracted})
    >(
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
