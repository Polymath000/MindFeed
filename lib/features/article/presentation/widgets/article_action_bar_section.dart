import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_action_bar.dart';

class ArticleActionBarSection extends StatelessWidget {
  const ArticleActionBarSection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ArticleReaderCubit>();
    return BlocSelector<
      ArticleReaderCubit,
      ArticleReaderState,
      ({
        bool isLiked,
        int likeCount,
        bool isStarred,
        int starCount,
        bool isSaved,
        bool isDownloaded,
      })
    >(
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
