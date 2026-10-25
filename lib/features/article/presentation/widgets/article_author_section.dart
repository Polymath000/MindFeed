import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_header.dart';
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
      ({double avg, int count, int stars})
    >(
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
          authorAvatarBytes: article.authorAvatarBytes,
          authorRatingAvg: ratings.avg,
          authorRatingCount: ratings.count,
          userAuthorStars: ratings.stars,
          onRateAuthor: cubit.rateAuthor,
          onAuthorTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.author,
              arguments: AuthorProfileArgs(
                authorName: article.authorName,
                authorRole: article.authorRole,
                authorAvatar: article.authorAvatar,
                authorId: article.authorId,
              ),
            );
          },
        );
      },
    );
  }
}
