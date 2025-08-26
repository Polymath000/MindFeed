import 'package:flutter/material.dart';
import 'package:mind_feed/features/articles_save/presentation/widgets/saved_articles_view_body.dart';

class ArticlesSaved extends StatelessWidget {
  const ArticlesSaved({super.key});
  static const String routeName = 'articlesSaved';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SavedArticlesViewBody());
  }
}
