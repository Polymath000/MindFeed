import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/features/profile/presentation/widget/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const routeName = "profile";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.ink,
      body: ProfileViewBody(),
    );
  }
}
