import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_author_bar.dart';
import 'package:mind_feed/features/author/domain/entities/author_profile_args.dart';

class ArticleAuthorSection extends StatelessWidget {
  const ArticleAuthorSection({super.key, required this.article});
  final EditorialNewsItem article;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ArticleReaderCubit>();
    return BlocSelector<
      ArticleReaderCubit,
      ArticleReaderState,
      ({
        double avg,
        int count,
        int stars,
        bool canFollow,
        bool isFollowing,
        bool isFollowLoading,
      })
    >(
      selector: (state) => (
        avg: state.authorRatingAvg,
        count: state.authorRatingCount,
        stars: state.userAuthorStars,
        canFollow: state.canFollowAuthor,
        isFollowing: state.isFollowingAuthor,
        isFollowLoading: state.isFollowLoading,
      ),
      builder: (context, barState) {
        return ArticleReaderAuthorBar(
          authorName: article.authorName,
          authorRole: article.authorRole,
          authorAvatar: article.authorAvatar,
          authorAvatarBytes: article.authorAvatarBytes,
          authorRatingAvg: barState.avg,
          authorRatingCount: barState.count,
          userAuthorStars: barState.stars,
          canFollowAuthor: barState.canFollow,
          isFollowingAuthor: barState.isFollowing,
          isFollowLoading: barState.isFollowLoading,
          onToggleFollow: cubit.toggleFollowAuthor,
          onRateAuthor: cubit.rateAuthor,
          onAuthorTap: () async {
            await Navigator.pushNamed(
              context,
              AppRoutes.author,
              arguments: AuthorProfileArgs(
                authorName: article.authorName,
                authorRole: article.authorRole,
                authorAvatar: article.authorAvatar,
                authorId: article.authorId,
              ),
            );
            if (context.mounted) {
              await cubit.refreshAuthorEngagement();
            }
          },
        );
      },
    );
  }
}
