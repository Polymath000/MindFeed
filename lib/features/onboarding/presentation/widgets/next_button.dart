import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.pageController,
    this.currentPage = 0,
  });

  final PageController? pageController;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final int page = (pageController?.hasClients ?? false)
        ? (pageController!.page?.round() ?? currentPage)
        : currentPage;
    final bool isLastPage = page >= 2;
    final double progress = ((page + 1) / 3.0).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () async {
        if ((pageController?.hasClients ?? false) && !isLastPage) {
          await pageController!.nextPage(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      child: Container(
        height: 58,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.butter,
          borderRadius: AppBorders.control,
          boxShadow: [
            BoxShadow(
              color: AppColors.butter.withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.ink.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '0${page + 1} / 03',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        isLastPage ? 'Get Started' : 'Continue',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    isLastPage
                        ? AppIcons.checkRounded
                        : AppIcons.arrowForwardIosRounded,
                    color: AppColors.ink,
                    size: isLastPage ? 18 : 14,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3.5,
                color: AppColors.ink.withValues(alpha: 0.12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    widthFactor: progress,
                    child: Container(
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
