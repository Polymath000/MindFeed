import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/utls/app_icons.dart';
import 'package:mind_feed/core/widgets/more_vert_icon.dart';

class CustomPopupMenuButtonForArticleView extends StatelessWidget {
  const CustomPopupMenuButtonForArticleView({
    super.key,
    required this.isDwonload,
  });
  final bool isDwonload;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: MoreVertIcon(),
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
        PopupMenuItem(
          value: 'Display Settings',
          child: Row(
            children: [
              Icon(AppIcons.displaySettings, size: 20),
              SizedBox(width: 8),
              Text('Display Settings'),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          height: 2,
          child: Container(color: AppColors.black, height: 1),
        ),
        isDwonload
            ? PopupMenuItem(
                value: 'delete',
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
          enabled: false,
          padding: EdgeInsets.zero,
          height: 2,
          child: Container(color: AppColors.black, height: 1),
        ),
        PopupMenuItem(
          value: 'save',
          child: Row(
            children: [
              Icon(
                AppIcons.save,
                size: 20,
              ), //TODO: change to solidBookmark if it is saved
              SizedBox(width: 8),
              Text('Save'),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          height: 2,
          child: Container(color: AppColors.black, height: 1),
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
