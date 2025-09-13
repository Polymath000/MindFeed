import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';

class MoreVertIcon extends StatelessWidget {
  const MoreVertIcon({super.key});

  @override
  Widget build(BuildContext context) {
        bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Icon(Icons.more_vert, color:isDark? AppColors.white:AppColors.gunmetal);
  }
}
