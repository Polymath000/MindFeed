import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final List<String> category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.black,
          border: Border.all(color: AppColors.white, width: 2),
          borderRadius: AppBorders.xxs,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                category[1],
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.black : AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category[0],
                style: AppTextStyles.bodyMedium!.copyWith(
                  color: isSelected ? AppColors.black : AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
