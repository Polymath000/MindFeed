import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/widget/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const routeName = "profile";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileArticlesCubit()..loadArticles(),
      child: const Material(
        color: Colors.transparent,
        child: ProfileViewBody(),
      ),
    );
  }
}
