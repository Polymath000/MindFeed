import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
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
        Uint8List? bytes = file.bytes;
        if (bytes == null) {
          try {
            bytes = await file.xFile.readAsBytes();
          } catch (_) {}
        }
        if (bytes != null && context.mounted) {
          if (bytes.lengthInBytes > 10 * 1024 * 1024) {
            final mb = (bytes.lengthInBytes / (1024 * 1024)).toStringAsFixed(1);
            customShowSnackBar(
              context: context,
              message: 'Avatar size must be 10 MB or less (selected: $mb MB)',
            );
            return;
          }
          context.read<ProfileInfoCubit>().uploadAvatar(
                bytes: bytes,
                fileName: file.name,
              );
        }
      }
    } catch (e) {
      if (context.mounted) {
        customShowSnackBar(
          context: context,
          message: 'Failed to pick image: $e',
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
          customShowSnackBar(
            context: context,
            message: state.avatarErrorMessage!,
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
