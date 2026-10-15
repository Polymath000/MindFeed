import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class DotsWidget extends StatelessWidget {
  // Now only takes the currentPage index as a parameter
  const DotsWidget({super.key, required this.currentPage});
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    const int totalPages = 3;
    const double activeDotWidth = 32.0;
    const double inactiveDotWidth = 8.0;
    const double dotHeight = 6.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final bool isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          height: dotHeight,
          width: isActive ? activeDotWidth : inactiveDotWidth,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.butter : AppColors.borderDark,
            borderRadius: BorderRadius.circular(dotHeight / 2),
          ),
        );
      }),
    );
  }
}
