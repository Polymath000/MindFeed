import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        widget.isFav ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
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
