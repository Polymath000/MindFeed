import 'package:flutter/material.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';

class ListSavedArticles extends StatelessWidget {
  const ListSavedArticles({super.key});
  static const routeName = "list_saved_articles";
  @override
  Widget build(BuildContext context) {
    return const ArticlesSaved();
  }
}
