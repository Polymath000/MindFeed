import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
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

  Future<void> _pickAndUploadAvatar(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null && context.mounted) {
          context.read<ProfileInfoCubit>().uploadAvatar(
                bytes: file.bytes!,
                fileName: file.name,
              );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.roseRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileInfoCubit, ProfileInfoState>(
      listenWhen: (prev, curr) =>
          curr.avatarErrorMessage != null &&
          curr.avatarErrorMessage != prev.avatarErrorMessage,
      listener: (context, state) {
        if (state.avatarErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.avatarErrorMessage!),
              backgroundColor: AppColors.roseRed,
            ),
          );
        }
      },
      builder: (context, state) {
        return ProfileAvatarAndStats(
          avatarUrl: state.avatarUrl,
          displayName: state.displayName,
          userSubtitle: state.userSubtitle,
          articlesCount: state.articlesCount,
          followingCount: state.followingCount,
          isUploadingAvatar: state.isUploadingAvatar,
          onTapAvatar: () => _pickAndUploadAvatar(context),
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
