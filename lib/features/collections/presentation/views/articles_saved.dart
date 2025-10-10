import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/features/collections/presentation/widgets/saved_articles_view_body.dart';

class ArticlesSaved extends StatelessWidget {
  const ArticlesSaved({super.key});
  static const String routeName = 'articlesSaved';

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SavedArticlesViewBody(),
      backgroundColor: isDark ? AppColors.lightBlack : AppColors.white,
    );
  }
}
