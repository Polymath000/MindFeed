import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/features/onboarding/presentation/views/widgets/onboarding_view_body.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});
  static const String routeName = 'onBoarding';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.black,
      body: OnboardingViewBody(),
    );
  }
}
