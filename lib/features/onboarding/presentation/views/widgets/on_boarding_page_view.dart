import 'package:flutter/material.dart';
import 'package:mind_feed/features/onboarding/presentation/views/widgets/page_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.pageController,
    required this.onPageChanged,
  });

  final PageController pageController;
  final Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 430),
          Expanded(
            child: PageView(
              controller: pageController,
              // Add the onPageChanged callback here
              onPageChanged: onPageChanged,
              children: [
                PageViewItem(
                  title: 'Discover Stories That Matter',
                  description:
                      'Explore thousands of articles from writers around the world. Find your next favorite read.',
                ),
                PageViewItem(
                  title: 'Read What You Love',
                  description:
                      'Choose your favorite categories and get content that matches your passions.',
                ),
                PageViewItem(
                  title: 'Learn Anytime, Anywhere',
                  description:
                      'Whether you’re at home or on the move, keep up with the latest stories and ideas.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
