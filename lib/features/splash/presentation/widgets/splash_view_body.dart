import 'package:flutter/material.dart';
import 'splash_background.dart';
import 'splash_logo_widget.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        SplashBackground(),
        SafeArea(
          child: Center(
            child: SplashLogoWidget(),
          ),
        ),
      ],
    );
  }
}
