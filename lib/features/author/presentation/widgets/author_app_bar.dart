import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';

class AuthorAppBar extends StatelessWidget {
  const AuthorAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xff1F1F2E)
          : AppColors.lightGray,
      actionsPadding: EdgeInsets.symmetric(horizontal: 32),
      centerTitle: true,
      title: Text('Author Profile', style: AppTextStyles.headlineMedium),
    );
  }
}
