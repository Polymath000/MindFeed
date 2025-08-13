import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';

class DotsWidget extends StatelessWidget {
  // Now only takes the currentPage index as a parameter
  const DotsWidget({super.key, required this.currentPage});
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    const int totalPages = 3;
    const double activeDotWidth = 40.0;
    const double inactiveDotWidth = 12.0;
    const double dotHeight = 8.0;

    return Positioned(
      bottom: 150,
      left: 130,
      right: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (index) {
          bool isActive = index == currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: dotHeight,
            width: isActive ? activeDotWidth : inactiveDotWidth,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(dotHeight / 2),
            ),
          );
        }),
      ),
    );
  }
}
