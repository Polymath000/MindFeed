import 'package:flutter/material.dart';

class AddToFavoriteArticleCard extends StatefulWidget {
  const AddToFavoriteArticleCard({super.key});

  @override
  State<AddToFavoriteArticleCard> createState() =>
      _AddToFavoriteArticleCardState();
}

class _AddToFavoriteArticleCardState extends State<AddToFavoriteArticleCard> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isSelected ? Icons.favorite : Icons.favorite_border),
      color: Colors.red,
      onPressed: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
    );
  }
}
