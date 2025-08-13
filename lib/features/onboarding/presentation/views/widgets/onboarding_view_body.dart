import 'package:flutter/material.dart';
import 'package:mind_feed/features/onboarding/presentation/views/widgets/dots_widget.dart';
import 'package:mind_feed/features/onboarding/presentation/views/widgets/next_button.dart';
import 'package:mind_feed/features/onboarding/presentation/views/widgets/on_boarding_background.dart';
import 'package:mind_feed/features/onboarding/presentation/views/widgets/on_boarding_page_view.dart';
import 'package:mind_feed/features/onboarding/presentation/views/widgets/skip_button.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The background widget needs to listen to page changes
        OnBoardingBackground(pageController: _pageController),
        SkipButton(),
        // Pass the onPageChanged callback to the PageView
        OnBoardingPageView(
          pageController: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
        // Pass the currentPage to the DotsWidget
        DotsWidget(currentPage: _currentPage),
        NextButton(pageController: _pageController),
      ],
    );
  }
}
