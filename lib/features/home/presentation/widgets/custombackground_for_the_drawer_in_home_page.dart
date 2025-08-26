import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';

class CustombackgroundForTheDrawerInHomePage extends StatelessWidget {
  const CustombackgroundForTheDrawerInHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.pickledBluewood,
            AppColors.darkGrey,
            AppColors.grey,
            AppColors.lightGray,
          ],
        ),
      ),
    );
  }
}
