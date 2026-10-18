import 'package:flutter/material.dart';
import 'package:mind_feed/features/profile/presentation/widgets/personal_infromation.dart';
import 'package:mind_feed/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:mind_feed/features/profile/presentation/widgets/user_articles.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: const CustomScrollView(
          slivers: [
            ProfileAppBar(),
            PersonalInfromation(),
            UserArticles(),
          ],
        ),
      ),
    );
  }
}
