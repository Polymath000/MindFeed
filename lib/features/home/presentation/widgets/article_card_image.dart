import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/borders.dart';

class ArticleCardImage extends StatelessWidget {
  const ArticleCardImage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: AppBorders.xxxs.topLeft,
        topRight: AppBorders.xxxs.topRight,
      ),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}
