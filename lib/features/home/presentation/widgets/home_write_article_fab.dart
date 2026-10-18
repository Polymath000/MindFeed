import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';

import '../controllers/home_feed/home_feed_cubit.dart';

class HomeWriteArticleFab extends StatelessWidget {
  const HomeWriteArticleFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'home_write_article_fab',
      tooltip: 'Write article',
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.ink,
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: AppBorders.control),
      onPressed: () async {
        await Navigator.pushNamed(context, AppRoutes.addArticle);
        if (context.mounted) {
          try {
            context.read<HomeFeedCubit>().fetchFeed();
          } catch (_) {}
        }
      },
      child: const Icon(AppIcons.edit, size: 22),
    );
  }
}
