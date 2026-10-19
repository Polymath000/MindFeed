import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/add_article/presentation/routes/add_article_routes.dart';

class AddArticleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AddArticleAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.sandLight,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(AppIcons.arrowBackRounded, color: AppColors.ink),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w900,
          fontSize: 20,
          letterSpacing: -0.4,
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, AddArticleRoutes.drafts),
          icon: const Icon(
            Icons.folder_outlined,
            size: 18,
            color: AppColors.ink,
          ),
          label: const Text(
            'Drafts',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
