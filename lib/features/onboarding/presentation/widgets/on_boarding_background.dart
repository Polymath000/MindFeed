import 'package:flutter/material.dart';
import 'package:mind_feed/core/utls/app_images.dart';

class OnBoardingBackground extends StatelessWidget {
  const OnBoardingBackground({
    super.key,
    required PageController this.pageController,
  });
  final PageController? pageController;
  @override
  Widget build(BuildContext context) {
    final int currentPage = (pageController?.hasClients ?? false)
        ? (pageController!.page!.round())
        : 0;
    String imagePath = currentPage == 0
        ? Assets.assetsImagesOnBoarding1
        : (currentPage == 1
              ? Assets.assetsImagesOnBoarding2
              : Assets.assetsImagesOnBoarding3);
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(
          currentPage == 2 ? 0.45 : (currentPage == 1 ? 0.55 : 0.65),
        ),
        BlendMode.darken,
      ),
      child: Image(
        image: AssetImage(imagePath),
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
