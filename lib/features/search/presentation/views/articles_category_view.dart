import 'package:flutter/material.dart';

class ArticlesCategoryView extends StatelessWidget {
  const ArticlesCategoryView({super.key});
  static const routeName = "articles_category_view";
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Category stories')));
  }
}
