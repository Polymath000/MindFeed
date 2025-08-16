import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/features/auth/presentation/views/signup_view.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?',
              style: AppTextStyles.bodyMedium!.copyWith(color: AppColors.white),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                overlayColor: MaterialStateProperty.all(AppColors.transparent),
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(context, SignUpView.routeName);
              },
              child: Text(
                'Sign Up',
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
