import 'package:flutter/material.dart';
import 'package:mind_feed/features/profile/presentation/widget/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const routeName = "profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProfileViewBody());
  }
}
