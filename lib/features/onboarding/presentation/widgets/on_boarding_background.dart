import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_images.dart';

class OnBoardingBackground extends StatelessWidget {
  const OnBoardingBackground({
    super.key,
    required this.pageController,
  });
  final PageController? pageController;
  @override
  Widget build(BuildContext context) {
    final int currentPage = (pageController?.hasClients ?? false)
        ? (pageController!.page?.round() ?? 0)
        : 0;
    final String imagePath = currentPage == 0
        ? Assets.assetsImagesOnBoarding1
        : (currentPage == 1
              ? Assets.assetsImagesOnBoarding2
              : Assets.assetsImagesOnBoarding3);
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            AppColors.ink.withValues(
              alpha: currentPage == 2 ? 0.45 : (currentPage == 1 ? 0.55 : 0.65),
            ),
            BlendMode.darken,
          ),
          child: Image(
            image: AssetImage(imagePath),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.ink.withValues(alpha: 0.15),
                AppColors.ink.withValues(alpha: 0.4),
                AppColors.ink.withValues(alpha: 0.95),
              ],
              stops: const [0.0, 0.45, 0.85],
            ),
          ),
        ),
      ],
    );
  }
}
