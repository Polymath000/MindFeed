import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_state.dart';
import 'package:mind_feed/features/profile/presentation/widgets/profile_avatar_and_stats.dart';

class PersonalInfromation extends StatelessWidget {
  final ProfileInfoCubit? cubit;

  const PersonalInfromation({super.key, this.cubit});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 20),
            child: _buildBody(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!,
        child: const _PersonalInformationContent(),
      );
    }

    try {
      BlocProvider.of<ProfileInfoCubit>(context);
      return const _PersonalInformationContent();
    } catch (_) {}

    if (GetIt.instance.isRegistered<ProfileInfoCubit>()) {
      return BlocProvider(
        create: (_) => GetIt.instance<ProfileInfoCubit>()..loadProfileData(),
        child: const _PersonalInformationContent(),
      );
    }

    return const _PersonalInformationFallback();
  }
}

class _PersonalInformationContent extends StatelessWidget {
  const _PersonalInformationContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
      builder: (context, state) {
        return ProfileAvatarAndStats(
          avatarUrl: state.avatarUrl,
          displayName: state.displayName,
          userSubtitle: state.userSubtitle,
          articlesCount: state.articlesCount,
          followingCount: state.followingCount,
        );
      },
    );
  }
}

class _PersonalInformationFallback extends StatelessWidget {
  const _PersonalInformationFallback();

  @override
  Widget build(BuildContext context) {
    final sessionUser = CurrentUserSession.resolveCurrentUser();
    final localUser = CurrentUserSession.resolveCachedUserEntity();

    final initialName = sessionUser?.displayName ??
        localUser?.userName ??
        (sessionUser?.email != null ? sessionUser!.email!.split('@').first : '');
    final initialSubtitle = sessionUser?.email ?? localUser?.email ?? '';

    return ProfileAvatarAndStats(
      avatarUrl: sessionUser?.avatarUrl,
      displayName: initialName,
      userSubtitle: initialSubtitle,
      articlesCount: 0,
      followingCount: localUser?.favoriteCategories?.length ?? 0,
    );
  }
}
