import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/widgets/more_vert_icon.dart';

class CustomPopupMenuButtonForHomeView extends StatelessWidget {
  const CustomPopupMenuButtonForHomeView({super.key, required this.isDwonload});
  final bool isDwonload;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: MoreVertIcon(),
      onSelected: (value) {},
      itemBuilder: (context) => [
        isDwonload
            ? PopupMenuItem(
                value: 'Delete',
                child: Row(
                  children: [
                    Icon(AppIcons.delete, size: 20),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              )
            : PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(AppIcons.download, size: 20),
                    SizedBox(width: 8),
                    Text('Download'),
                  ],
                ),
              ),
        PopupMenuItem(
          value: 'save',
          child: Row(
            children: [
              Icon(AppIcons.save, size: 20),
              SizedBox(width: 8),
              Text('Save'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(AppIcons.share, size: 20),
              SizedBox(width: 8),
              Text('Share'),
            ],
          ),
        ),
      ],
    );
  }
}
