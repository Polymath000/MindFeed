import 'package:flutter/material.dart';
import 'package:mind_feed/features/onboarding/presentation/widgets/dots_widget.dart';
import 'package:mind_feed/features/onboarding/presentation/widgets/next_button.dart';
import 'package:mind_feed/features/onboarding/presentation/widgets/on_boarding_background.dart';
import 'package:mind_feed/features/onboarding/presentation/widgets/on_boarding_page_view.dart';
import 'package:mind_feed/features/onboarding/presentation/widgets/skip_button.dart';

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
        OnBoardingBackground(pageController: _pageController),
        SkipButton(),
        OnBoardingPageView(
          pageController: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
        DotsWidget(currentPage: _currentPage),
        NextButton(pageController: _pageController),
      ],
    );
  }
}
