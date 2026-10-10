import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: EditorialPalette.ink,
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
            icon: Icons.settings_outlined,
            label: 'Settings',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ),
      ],
      title: const Text(
        'Profile',
        style: TextStyle(
          color: EditorialPalette.softCream,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
