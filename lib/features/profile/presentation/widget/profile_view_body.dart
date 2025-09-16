import 'package:flutter/material.dart';
import 'package:mind_feed/features/profile/presentation/widget/personal_infromation.dart';
import 'package:mind_feed/features/profile/presentation/widget/profile_app_bar.dart';
import 'package:mind_feed/features/profile/presentation/widget/user_articles.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [ProfileAppBar(), PersonalInfromation(), UserArticles()],
    );
  }
}
