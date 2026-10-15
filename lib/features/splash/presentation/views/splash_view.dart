import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import '../controllers/splash_cubit/splash_cubit.dart';
import '../controllers/splash_cubit/splash_state.dart';
import '../widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashCubit>()..initApp(),
      child: const Scaffold(
        backgroundColor: AppColors.ink,
        body: SplashListener(
          child: SplashViewBody(),
        ),
      ),
    );
  }
}

class SplashListener extends StatelessWidget {
  const SplashListener({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        switch (state) {
          case SplashNavigateToOnboarding():
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.onboarding,
              (route) => false,
            );
          case SplashNavigateToLogin():
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          case SplashNavigateToMain():
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.main,
              (route) => false,
            );
          case SplashInitial():
            break;
        }
      },
      child: child,
    );
  }
}
