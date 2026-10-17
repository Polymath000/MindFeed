import 'package:flutter/material.dart';
import 'package:mind_feed/features/home/presentation/views/article_view.dart';

class ArticleViewBody extends StatelessWidget {
  const ArticleViewBody({super.key, this.item});

  final EditorialNewsItem? item;

  @override
  Widget build(BuildContext context) {
    return ArticleView(item: item);
  }
}
