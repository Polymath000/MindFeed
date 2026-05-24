import 'package:flutter/material.dart';
import 'package:mind_feed/core/utls/app_icons.dart';

class AddToFavoriteArticleCard extends StatefulWidget {
  AddToFavoriteArticleCard({super.key, required this.isFav});
  bool isFav;
  @override
  State<AddToFavoriteArticleCard> createState() =>
      _AddToFavoriteArticleCardState();
}

class _AddToFavoriteArticleCardState extends State<AddToFavoriteArticleCard> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.isFav ? AppIcons.favorite : AppIcons.favoriteOutline,
      ),
      color: Colors.red,
      onPressed: () {
        setState(() {
          widget.isFav = !widget.isFav;
        });
      },
    );
  }
}
