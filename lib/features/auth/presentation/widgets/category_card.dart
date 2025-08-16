import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/constants/borders.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key, required this.category});
  final List<String> category;
  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
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
                widget.category[1],
                width: 40,
                height: 40,
                color: isSelected ? AppColors.black : AppColors.white,
              ),
              SizedBox(height: 8),
              Text(
                widget.category[0],
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
