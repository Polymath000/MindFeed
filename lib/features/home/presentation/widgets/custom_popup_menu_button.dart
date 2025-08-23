import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';

class CustomPopupMenuButton extends StatelessWidget {
  const CustomPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: AppColors.gunmetal),
      onSelected: (value) {
        if (value == 'download') {
          // TODO: handle download action
        } else if (value == 'save') {
          // TODO: handle save action
        } else if (value == 'share') {
          // TODO: handle share action
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'download',
          child: Row(
            children: [
              Icon(Icons.download, size: 20),
              SizedBox(width: 8),
              Text('Download'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'save',
          child: Row(
            children: [
              Icon(Icons.bookmark, size: 20),
              SizedBox(width: 8),
              Text('Save'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share, size: 20),
              SizedBox(width: 8),
              Text('Share'),
            ],
          ),
        ),
      ],
    );
  }
}
