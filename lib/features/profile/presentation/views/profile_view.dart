import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/profile/presentation/widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  final ProfileArticlesCubit? cubit;
  final ProfileInfoCubit? infoCubit;

  const ProfileView({
    super.key,
    this.cubit,
    this.infoCubit,
  });

  static const routeName = "profile";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (cubit != null)
          BlocProvider<ProfileArticlesCubit>.value(value: cubit!)
        else if (GetIt.instance.isRegistered<ProfileArticlesCubit>())
          BlocProvider<ProfileArticlesCubit>(
            create: (_) => GetIt.instance<ProfileArticlesCubit>()..loadArticles(),
          )
        else
          BlocProvider<ProfileArticlesCubit>(
            create: (_) => GetIt.instance<ProfileArticlesCubit>()..loadArticles(),
          ),
        if (infoCubit != null)
          BlocProvider<ProfileInfoCubit>.value(value: infoCubit!)
        else if (GetIt.instance.isRegistered<ProfileInfoCubit>())
          BlocProvider<ProfileInfoCubit>(
            create: (_) => GetIt.instance<ProfileInfoCubit>()..loadProfileData(),
          ),
      ],
      child: const Material(
        color: Colors.transparent,
        child: ProfileViewBody(),
      ),
    );
  }
}
