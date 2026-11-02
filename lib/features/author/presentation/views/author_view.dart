import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_cubit.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_state.dart';
import 'package:mind_feed/features/author/presentation/widgets/article_card_of_author.dart';
import 'package:mind_feed/features/author/presentation/widgets/author_app_bar.dart';
import 'package:mind_feed/features/author/presentation/widgets/author_dossier_header.dart';
import 'package:mind_feed/features/author/presentation/widgets/author_status_views.dart';
import 'package:mind_feed/features/author/presentation/widgets/author_topic_filter_bar.dart';

class AuthorView extends StatelessWidget {
  final AuthorCubit? cubit;
  final String authorName;
  final String? authorRole;
  final String? authorAvatar;
  final String? authorId;

  const AuthorView({
    super.key,
    this.cubit,
    this.authorName = '',
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
          authorId: authorId,
        ),
      );
    }
    return BlocProvider(
      create: (_) => GetIt.instance<AuthorCubit>()
        ..loadAuthorArticles(
          authorName,
          authorId: authorId,
          authorRole: authorRole,
          authorAvatar: authorAvatar,
        ),
      child: _AuthorViewBody(
        authorName: authorName,
        authorRole: authorRole,
        authorAvatar: authorAvatar,
        authorId: authorId,
      ),
    );
  }
}

class _AuthorViewBody extends StatelessWidget {
  final String authorName;
  final String? authorRole;
  final String? authorAvatar;
  final String? authorId;

  const _AuthorViewBody({
    required this.authorName,
    this.authorRole,
    this.authorAvatar,
    this.authorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: BlocConsumer<AuthorCubit, AuthorState>(
            listenWhen: (prev, curr) {
              final prevMsg = prev is AuthorLoaded
                  ? prev.feedbackMessage
                  : (prev is AuthorEmpty ? prev.feedbackMessage : null);
              final currMsg = curr is AuthorLoaded
                  ? curr.feedbackMessage
                  : (curr is AuthorEmpty ? curr.feedbackMessage : null);
              return currMsg != null && currMsg != prevMsg;
            },
            listener: (context, state) {
              final msg = state is AuthorLoaded
                  ? state.feedbackMessage
                  : (state is AuthorEmpty ? state.feedbackMessage : null);
              if (msg != null && msg.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  const AuthorAppBar(),
                  _buildHeaderSliver(context, state),
                  if (state is AuthorLoaded && state.topics.length > 1)
                    SliverToBoxAdapter(
                      child: AuthorTopicFilterBar(
                        topics: state.topics,
                        selectedTopic: state.selectedTopic,
                        onTopicSelected: (topic) =>
                            context.read<AuthorCubit>().selectTopic(topic),
                      ),
                    ),
                  ..._buildContentSlivers(context, state),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSliver(BuildContext context, AuthorState state) {
    final cubit = context.read<AuthorCubit>();

    final (
      displayName,
      bio,
      avatarUrl,
      storiesCount,
      followersCount,
      ratingAvg,
      ratingCount,
      userStars,
      topics,
      canFollow,
      isFollowing,
      isFollowLoading,
      canRate,
    ) = switch (state) {
      AuthorLoaded() => (
          state.displayName.isNotEmpty ? state.displayName : authorName,
          state.bio.isNotEmpty ? state.bio : (authorRole ?? ''),
          state.avatarUrl.isNotEmpty ? state.avatarUrl : (authorAvatar ?? ''),
          state.articles.length,
          state.followersCount,
          state.ratingAvg,
          state.ratingCount,
          state.userStars,
          state.topics,
          state.canFollow,
          state.isFollowing,
          state.isFollowLoading,
          state.canRate,
        ),
      AuthorEmpty() => (
          state.displayName.isNotEmpty ? state.displayName : authorName,
          state.bio.isNotEmpty ? state.bio : (authorRole ?? ''),
          state.avatarUrl.isNotEmpty ? state.avatarUrl : (authorAvatar ?? ''),
          0,
          state.followersCount,
          state.ratingAvg,
          state.ratingCount,
          state.userStars,
          state.topics,
          state.canFollow,
          state.isFollowing,
          state.isFollowLoading,
          state.canRate,
        ),
      _ => (
          authorName.isNotEmpty ? authorName : 'MindFeed Author',
          authorRole ?? '',
          authorAvatar ?? '',
          0,
          0,
          0.0,
          0,
          0,
          const <String>[],
          false,
          false,
          false,
          false,
        ),
    };

    return SliverToBoxAdapter(
      child: AuthorDossierHeader(
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
        storiesCount: storiesCount,
        followersCount: followersCount,
        ratingAvg: ratingAvg,
        ratingCount: ratingCount,
        userStars: userStars,
        topics: topics,
        canFollow: canFollow,
        isFollowing: isFollowing,
        isFollowLoading: isFollowLoading,
        canRate: canRate,
        onToggleFollow: () => cubit.toggleFollow(),
        onRate: (stars) => cubit.rateAuthor(stars),
      ),
    );
  }

  List<Widget> _buildContentSlivers(BuildContext context, AuthorState state) {
    if (state is AuthorLoading) {
      return const [
        SliverToBoxAdapter(
          child: AuthorLoadingView(),
        ),
      ];
    }

    if (state is AuthorError) {
      return [
        SliverToBoxAdapter(
          child: AuthorErrorView(
            message: state.message,
            onRetry: () => context.read<AuthorCubit>().loadAuthorArticles(
                  authorName,
                  authorId: authorId,
                  authorRole: authorRole,
                  authorAvatar: authorAvatar,
                ),
          ),
        ),
      ];
    }

    final articles = state is AuthorLoaded
        ? state.filteredArticles
        : const <EditorialNewsItem>[];

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        sliver: SliverToBoxAdapter(
          child: Row(
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
                '${articles.length} stories',
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      if (articles.isEmpty)
        const SliverToBoxAdapter(
          child: AuthorEmptyView(),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: ArticleCardOfAuthor(
                  item: articles[index],
                ),
              );
            },
          ),
        ),
    ];
  }
}
