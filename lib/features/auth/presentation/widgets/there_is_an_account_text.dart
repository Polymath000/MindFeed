import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';

class ThereIsAnAccountText extends StatelessWidget {
  const ThereIsAnAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Are you have an account?',
              style: AppTextStyles.bodyMedium!.copyWith(color: AppColors.white),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                overlayColor: MaterialStateProperty.all(AppColors.transparent),
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Login',
                style: AppTextStyles.bodyMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
