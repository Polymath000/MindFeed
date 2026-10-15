import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_icons.dart';

class AddToFavoriteArticleCard extends StatefulWidget {
  const AddToFavoriteArticleCard({super.key, required this.isFav});
  final bool isFav;
  @override
  State<AddToFavoriteArticleCard> createState() =>
      _AddToFavoriteArticleCardState();
}

class _AddToFavoriteArticleCardState extends State<AddToFavoriteArticleCard> {
  late bool isFav = widget.isFav;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isFav ? AppIcons.favorite : AppIcons.favoriteOutline),
      color: Colors.red,
      onPressed: () {
        setState(() {
          isFav = !isFav;
        });
      },
    );
  }
}
