import 'package:flutter/material.dart';
import 'package:mind_feed/core/widgets/more_vert_icon.dart';

class CustomPopupMenuButtonForSavedArticlesView extends StatelessWidget {
  const CustomPopupMenuButtonForSavedArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'Edit Info',
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('Edit List Info'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Download',
          child: Row(
            children: [
              Icon(Icons.download, size: 20),
              SizedBox(width: 8),
              Text('Download'),
            ],
          ),
        ),
      ],
      icon: MoreVertIcon(),
    );
  }
}
