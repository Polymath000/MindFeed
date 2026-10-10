import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class AuthorAppBar extends StatelessWidget {
  const AuthorAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: EditorialIconButton(
          icon: Icons.arrow_back_rounded,
          label: 'Back',
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: EditorialIconButton(
            icon: Icons.ios_share_rounded,
            label: 'Share profile',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile link copied to clipboard')),
              );
            },
          ),
        ),
      ],
      title: const Text(
        'Author Profile',
        style: TextStyle(
          color: AppColors.softCream,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
