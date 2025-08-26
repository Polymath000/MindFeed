import 'package:flutter/material.dart';
import 'package:mind_feed/features/articles_save/presentation/widgets/custom_sliver_app_bar_for_articles_saved.dart';
import 'package:mind_feed/features/articles_save/presentation/widgets/list_for_saved_articles.dart';

class SavedArticlesViewBody extends StatelessWidget {
  const SavedArticlesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [CustomSliverAppBarForArticlesSaved(), ListForSavedArticles()],
    );
  }
}
