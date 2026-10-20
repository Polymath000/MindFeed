import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/widgets/article_card.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_cubit.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_state.dart';
import 'package:mind_feed/features/author/presentation/views/author_personal_info.dart';
import 'package:mind_feed/features/author/presentation/widgets/author_app_bar.dart';

class AuthorView extends StatelessWidget {
  final AuthorCubit? cubit;
  final String authorName;
  final String? authorRole;
  final String? authorAvatar;
  final String? authorId;

  const AuthorView({
    super.key,
    this.cubit,
    this.authorName = 'Wade Warren',
    this.authorRole,
    this.authorAvatar,
    this.authorId,
  });

  static const String routeName = 'author';

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!,
        child: _AuthorViewBody(
          authorName: authorName,
          authorRole: authorRole,
          authorAvatar: authorAvatar,
        ),
      );
    }
    return BlocProvider(
      create: (_) =>
          GetIt.instance<AuthorCubit>()
            ..loadAuthorArticles(authorName, authorId: authorId),
      child: _AuthorViewBody(
        authorName: authorName,
        authorRole: authorRole,
        authorAvatar: authorAvatar,
      ),
    );
  }
}

class _AuthorViewBody extends StatelessWidget {
  final String authorName;
  final String? authorRole;
  final String? authorAvatar;

  const _AuthorViewBody({
    required this.authorName,
    this.authorRole,
    this.authorAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: CustomScrollView(
            slivers: [
              const AuthorAppBar(),
              AuthorPersonalInfo(
                authorName: authorName,
                authorRole: authorRole,
                authorAvatar: authorAvatar,
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: BlocBuilder<AuthorCubit, AuthorState>(
                    builder: (context, state) {
                      final authorArticles = state is AuthorLoaded
                          ? state.articles
                          : const <EditorialNewsItem>[];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Published Stories',
                                style: TextStyle(
                                  color: AppColors.softCream,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.6,
                                ),
                              ),
                              Text(
                                '${authorArticles.length} stories',
                                style: const TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ...authorArticles.map(
                            (item) => ArticleCard(item: item),
                          ),
                          const SizedBox(height: 80),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
