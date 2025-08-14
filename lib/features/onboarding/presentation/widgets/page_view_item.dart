import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 20),
      child: Column(
        children: [
          SizedBox(
            width: 292,
            child: Text(
              title,
              style: AppTextStyles.headlineLarge!.copyWith(
                color: AppColors.white,
                fontSize: 36,
                height: 1.3,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 25),
          SizedBox(
            width: 297,
            child: Text(
              description,
              style: AppTextStyles.titleMedium!.copyWith(
                color: AppColors.lightGrey,
                fontSize: 18,
                height: 1.67,
                wordSpacing: 0.85,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
