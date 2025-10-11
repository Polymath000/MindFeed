import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_view_body.dart';

class ListSavedArticles extends StatelessWidget {
  const ListSavedArticles({super.key});
  static const routeName = "list_saved_articles";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xff1F1F2E)
                  : AppColors.lightGray,
              actionsPadding: EdgeInsets.symmetric(horizontal: 32),
              title: Text('Reading List', style: AppTextStyles.headlineMedium),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              sliver: ArticlesForTest(),
            ),
          ],
        ),
      ),
    );
  }
}
