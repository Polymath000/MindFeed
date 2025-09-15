import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xff1F1F2E)
          : AppColors.lightGray,
      actionsPadding: EdgeInsets.symmetric(horizontal: 32),
      centerTitle: true,
      title: Text('Profile', style: AppTextStyles.headlineMedium),
    );
  }
}
