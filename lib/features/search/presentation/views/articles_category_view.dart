import 'package:flutter/material.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_view_body.dart';

class ArticlesCategoryView extends StatelessWidget {
  const ArticlesCategoryView({super.key});
  static const routeName = "articles_category_view";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
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
