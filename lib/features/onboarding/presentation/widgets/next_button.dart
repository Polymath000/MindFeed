import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.pageController});
  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    final currentPage = (pageController?.hasClients ?? false)
        ? (pageController!.page ?? 0)
        : 0;
    final bool isLastPage = currentPage.round() == 2;
    return Positioned(
      bottom: 20,
      left: 40,
      right: 40,
      child: GestureDetector(
        onTap: () async {
          if ((pageController?.hasClients ?? false) && !isLastPage) {
            await pageController!.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInQuad,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
          }
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: AppBorders.circular,
          ),
          child: Center(
            child: Text(
              isLastPage ? 'Start' : 'Next',
              style: AppTextStyles.bodyLarge!.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
