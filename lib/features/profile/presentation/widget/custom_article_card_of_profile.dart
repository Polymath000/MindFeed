import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/utls/app_icons.dart';
import 'package:mind_feed/core/utls/app_images.dart';

class CustomArticleCardOfProfile extends StatelessWidget {
  const CustomArticleCardOfProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: isDark ? AppColors.spaceBlack : AppColors.lightGray,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
            side: BorderSide(color: const Color(0xFFE5E7EB)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.35,
              child: Image.asset(Assets.assetsImagesJustTest),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).height * 0.2,
                  child: Text(
                    'Sustainable Living in Urban Environments: A Practical Guide',
                    style: AppTextStyles.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      wordSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(AppIcons.edit, size: 16),
                    SizedBox(width: 12),
                    Icon(AppIcons.delete, size: 16),
                    SizedBox(width: 12),
                    Icon(AppIcons.share, size: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
