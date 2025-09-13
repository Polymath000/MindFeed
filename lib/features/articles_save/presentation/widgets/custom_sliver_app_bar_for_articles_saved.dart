import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/constants/borders.dart';

class CustomSliverAppBarForArticlesSaved extends StatelessWidget {
  const CustomSliverAppBarForArticlesSaved({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      pinned: false,
      automaticallyImplyLeading: false,
      actions: [
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              border: Border.all(),
              borderRadius: AppBorders.xs,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 14,
              ),
              child: Text(
                'New list',
                style: AppTextStyles.titleMedium!.copyWith(
                  color: isDark ? AppColors.lightBlack : AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
      toolbarHeight: 145,
      title: ZoomIn(
        config: BaseAnimationConfig(
          child: Text(
            'Your library',
            style: AppTextStyles.headlineSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
