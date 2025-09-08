import 'package:flutter/material.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_view_body.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({super.key});
  static const String routeName = 'article';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ArticleViewBody());
  }
}
